# frozen_string_literal: true

require 'securerandom'

require 'sleeping_king_studios/tools/toolbelt'

require 'rspec/sleeping_king_studios/concerns'

module RSpec::SleepingKingStudios::Concerns
  # Defines helpers for including reusable contracts in RSpec example groups.
  #
  # RSpec contracts are a mechanism for sharing tests between projects. For
  # example, one library may define an interface or specification for a type of
  # object, while a second library implements that object. By defining a
  # contract and sharing that contract as part of the library, the developer
  # ensures that any object that matches the contract has correctly implemented
  # and conforms to the interface. This reduces duplication of tests and
  # provides resiliency as an interface is developed over time and across
  # versions of the library.
  #
  # Mechanically speaking, each contract encapsulates a section of RSpec code.
  # When the contract is included in a spec, that code is then injected into the
  # spec. Writing a contract, therefore, is no different than writing any other
  # RSpec specification - it is only the delivery mechanism that differs. A
  # contract can be any object that responds to #to_proc; the simplest contract
  # is therefore a Proc or lambda that contains some RSpec code.
  #
  # @example Defining A Contract
  #   module ExampleContracts
  #     # This contract asserts that the object has the Enumerable module as an
  #     # ancestor, and that it responds to the #each method.
  #     SHOULD_BE_ENUMERABLE_CONTRACT = lambda do
  #       it 'should be Enumerable' do
  #         expect(subject).to be_a Enumerable
  #       end
  #
  #       it 'should respond to #each' do
  #         expect(subject).to respond_to(:each).with(0).arguments
  #       end
  #     end
  #   end
  #
  #   RSpec.describe Array do
  #     extend RSpec::SleepingKingStudios::Concerns::IncludeContract
  #
  #     include_contract ExampleContracts::SHOULD_BE_ENUMERABLE_CONTRACT
  #   end
  #
  #   RSpec.describe Hash do
  #     extend  RSpec::SleepingKingStudios::Concerns::IncludeContract
  #     include ExampleContracts
  #
  #     include_contract 'should be enumerable'
  #   end
  #
  # @example Defining A Contract With Parameters
  #   module SerializerContracts
  #     # This contract asserts that the serialized result has the expected
  #     # values.
  #     #
  #     # First, we pass the contract a series of attribute names. These are
  #     # used to assert that the serialized attributes match the values on the
  #     # original object.
  #     #
  #     # Second, we pass the contract a set of attribute names and values.
  #     # These are used to assert that the serialized attributes have the
  #     # specified values.
  #     #
  #     # Finally, we can pass the contract a block, which the contract then
  #     # executes. Note that the block is executed in the context of our
  #     # describe block, and thus can take advantage of our memoized
  #     # #serialized helper method.
  #     SHOULD_SERIALIZE_ATTRIBUTES_CONTRACT = lambda \
  #     do |*attributes, **values, &block|
  #       describe '#serialize' do
  #         let(:serialized) { subject.serialize }
  #
  #         it { expect(subject).to respond_to(:serialize).with(0).arguments }
  #
  #         attributes.each do |attribute|
  #           it "should serialize #{attribute}" do
  #             expect(serialized[attribute]).to be == subject[attribute]
  #           end
  #         end
  #
  #         values.each do |attribute, value|
  #           it "should serialize #{attribute}" do
  #             expect(serialized[attribute]).to be == value
  #           end
  #         end
  #
  #         instance_exec(&block) if block
  #       end
  #     end
  #
  #   RSpec.describe CaptainPicard do
  #     extend  RSpec::SleepingKingStudios::Concerns::IncludeContract
  #     include SerializerContracts
  #
  #     include_contract 'should serialize attributes',
  #       :name,
  #       :rank,
  #       lights: 4 do
  #         it 'should serialize the catchphrase' do
  #           expect(serialized[:catchphrase]).to be == 'Make it so.'
  #         end
  #     end
  #   end
  #
  # @see RSpec::SleepingKingStudios::Contract.
  module IncludeContract
    class << self
      # @private
      def define_contract_method(context:, contract:, name:)
        method_name = +'rspec_include_contract'
        method_name << '_' << tools.str.underscore(name) if contract_name?(name)
        method_name << '_' << tools.str.underscore(SecureRandom.uuid)
        method_name = method_name.tr(' ', '_').intern

        context.singleton_class.define_method(method_name, &contract)

        yield method_name
      ensure
        context.singleton_class.remove_method(method_name)
      end

      # @private
      def resolve_contract(context:, contract_or_name:)
        validate_contract!(contract_or_name)

        return contract_or_name unless contract_name?(contract_or_name)

        contract_name = contract_or_name.to_s
        contract      =
          resolve_contract_class(context, "#{contract_name} contract") ||
          resolve_contract_const(context, "#{contract_name} contract") ||
          resolve_contract_class(context, contract_name) ||
          resolve_contract_const(context, contract_name)

        return contract if contract

        raise ArgumentError, "undefined contract #{contract_or_name.inspect}"
      end

      private

      def contract?(contract_or_name)
        contract_or_name.respond_to?(:to_proc)
      end

      def contract_name?(contract_or_name)
        contract_or_name.is_a?(String) || contract_or_name.is_a?(Symbol)
      end

      def resolve_contract_class(context, contract_name)
        class_name = tools.str.camelize(contract_name.tr(' ', '_'))

        return nil unless context.const_defined?(class_name)

        context.const_get(class_name)
      end

      def resolve_contract_const(context, contract_name)
        const_name = tools.str.underscore(contract_name.tr(' ', '_')).upcase

        return nil unless context.const_defined?(const_name)

        context.const_get(const_name)
      end

      def tools
        SleepingKingStudios::Tools::Toolbelt.instance
      end

      def validate_contract!(contract_or_name)
        raise ArgumentError, "contract can't be blank" if contract_or_name.nil?

        if contract_name?(contract_or_name)
          return unless contract_or_name.to_s.empty?

          raise ArgumentError, "contract can't be blank"
        end

        return if contract?(contract_or_name)

        raise ArgumentError, 'contract must be a name or respond to #to_proc'
      end
    end

    # As #include_contract, but wraps the contract in a focused example group.
    #
    # @see include_contract.
    def finclude_contract(contract_or_name, *arguments, **keywords, &block)
      fdescribe '(focused)' do
        if keywords.empty?
          include_contract(contract_or_name, *arguments, &block)
        else
          include_contract(contract_or_name, *arguments, **keywords, &block)
        end
      end
    end

    # Adds the contract to the example group with the given parameters.
    #
    # @overload include_contract(contract, *arguments, **keywords, &block)
    #   @param contract [#to_proc] The contract to include.
    #   @param arguments [Array] The arguments to pass to the contract.
    #   @param keywords [Hash] The keywords to pass to the contract.
    #
    #   @yield A block passed to the contract.
    #
    # @overload include_contract(contract_name, *arguments, **keywords, &block)
    #   @param contract_name [String, Symbol] The name of contract to include.
    #     The contract must be defined as a Class or constant in the same scope,
    #     e.g. include_contract('does something') expects the example group to
    #     define either a DoSomething class or a DO_SOMETHING constant. The name
    #     can optionally be suffixed with "contract", so it will also match a
    #     DoSomethingContract class or a DO_SOMETHING_CONTRACT constant.
    #   @param arguments [Array] The arguments to pass to the contract.
    #   @param keywords [Hash] The keywords to pass to the contract.
    #
    #   @yield A block passed to the contract.
    #
    #   @raise ArgumentError
    def include_contract(contract_or_name, *arguments, **keywords, &block) # rubocop:disable Metrics/MethodLength
      concern  = RSpec::SleepingKingStudios::Concerns::IncludeContract
      contract = concern.resolve_contract(
        context:          self,
        contract_or_name: contract_or_name
      )

      concern.define_contract_method(
        context:  self,
        contract: contract,
        name:     contract_or_name
      ) do |method_name|
        if keywords.empty?
          send(method_name, *arguments, &block)
        else
          send(method_name, *arguments, **keywords, &block)
        end
      end
    end

    # As #include_contract, but wraps the contract in a skipped example group.
    #
    # @see include_contract.
    def xinclude_contract(contract_or_name, *arguments, **keywords, &block)
      xdescribe '(skipped)' do
        if keywords.empty?
          include_contract(contract_or_name, *arguments, &block)
        else
          include_contract(contract_or_name, *arguments, **keywords, &block)
        end
      end
    end
  end
end
