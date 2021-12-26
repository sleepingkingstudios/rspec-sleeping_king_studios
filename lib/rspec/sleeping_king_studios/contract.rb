# frozen_string_literal: true

require 'rspec/sleeping_king_studios'
require 'rspec/sleeping_king_studios/concerns/include_contract'

module RSpec::SleepingKingStudios
  # A Contract wraps RSpec functionality for sharing and reusability.
  #
  # An RSpec::SleepingKingStudios::Contract integrates with the
  # .include_contract class method to share and reuse RSpec examples and
  # configuration. The major advantage a Contract object provides over using a
  # Proc is documentation - tools such as YARD do not gracefully handle bare
  # lambdas, while the functionality and requirements of a Contract can be
  # specified using standard patterns, such as documenting the parameters passed
  # to a contract using the #apply method.
  #
  # @example Defining A Contract
  #   module ExampleContracts
  #     # This contract asserts that the object has the Enumerable module as an
  #     # ancestor, and that it responds to the #each method.
  #     class ShouldBeEnumerableContract < RSpec::SleepingKingStudios::Contract
  #       # @!method apply(example_group)
  #       #   Adds the contract to the example group.
  #
  #       contract do
  #         it 'should be Enumerable' do
  #           expect(subject).to be_a Enumerable
  #         end
  #
  #         it 'should respond to #each' do
  #           expect(subject).to respond_to(:each).with(0).arguments
  #         end
  #       end
  #     end
  #   end
  #
  #   RSpec.describe Array do
  #     ExampleContracts::SHOULD_BE_ENUMERABLE_CONTRACT.apply(self)
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
  #     class ShouldSerializeAttributesContract < RSpec::SleepingKingStudios::Contract
  #       contract do |*attributes, **values, &block|
  #         describe '#serialize' do
  #           let(:serialized) { subject.serialize }
  #
  #           it { expect(subject).to respond_to(:serialize).with(0).arguments }
  #
  #           attributes.each do |attribute|
  #             it "should serialize #{attribute}" do
  #               expect(serialized[attribute]).to be == subject[attribute]
  #             end
  #           end
  #
  #           values.each do |attribute, value|
  #             it "should serialize #{attribute}" do
  #               expect(serialized[attribute]).to be == value
  #             end
  #           end
  #
  #           instance_exec(&block) if block
  #         end
  #       end
  #     end
  #
  #   RSpec.describe CaptainPicard do
  #     SerializerContracts::ShouldSerializeAttributesContract.apply(
  #       :name,
  #       :rank,
  #       lights: 4) \
  #     do
  #       it 'should serialize the catchphrase' do
  #         expect(serialized[:catchphrase]).to be == 'Make it so.'
  #       end
  #     end
  #   end
  #
  # @see RSpec::SleepingKingStudios::Concerns::IncludeContract.
  class Contract
    # Error class used when defining a contract on an abstract class.
    class AbstractContractError < StandardError; end

    class << self
      # Adds the contract to the given example group.
      #
      # @param example_group [RSpec::Core::ExampleGroup] The example group to
      #   which the contract is applied.
      # @param arguments [Array] Optional arguments to pass to the contract.
      # @param keywords [Hash] Optional keywords to pass to the contract.
      #
      # @yield A block to pass to the contract.
      #
      # @see #to_proc
      def apply(example_group, *arguments, **keywords, &block)
        concern = RSpec::SleepingKingStudios::Concerns::IncludeContract

        concern.define_contract_method(
          context:  example_group,
          contract: self,
          name:     tools.str.underscore(name).gsub('::', '_')
        ) do |method_name|
          if keywords.empty?
            example_group.send(method_name, *arguments, &block)
          else
            example_group.send(method_name, *arguments, **keywords, &block)
          end
        end
      end

      # @overload contract()
      #   @return [Proc, nil] the contract implementation for the class.
      #
      # @overload contract()
      #   Sets the contract implementation for the class.
      #
      #   @yield [*arguments, **keywords, &block] The implementation to
      #     configure for the class.
      #
      #   @yieldparam arguments [Array] Optional arguments to pass to the
      #     contract.
      #   @yieldparam keywords [Hash] Optional keywords defined for the
      #     contract.
      #   @yieldparam block [Array] A block to pass to the contract.
      def contract(&block)
        return get_contract unless block_given?

        set_contract(block)
      end

      # @return [Proc, nil] the contract implementation for the class.
      def to_proc
        get_contract
      end

      private

      def get_contract
        return @contract if @contract

        if superclass < RSpec::SleepingKingStudios::Contract
          return superclass.contract
        end

        nil
      end

      def set_contract(contract)
        unless self < RSpec::SleepingKingStudios::Contract
          raise AbstractContractError,
            'RSpec::SleepingKingStudios::Contract is an abstract class -' \
              ' create a subclass to define a contract'
        end

        @contract = contract
      end

      def tools
        SleepingKingStudios::Tools::Toolbelt.instance
      end
    end

    # @yield [*arguments, **keywords, &block] The implementation to configure
    #   for the instance.
    #
    # @yieldparam arguments [Array] Optional arguments to pass to the contract.
    # @yieldparam keywords [Hash] Optional keywords defined for the contract.
    # @yieldparam block [Array] A block to pass to the contract.
    def initialize(&contract)
      @contract = contract
    end

    # Adds the contract to the given example group.
    #
    # If the contract was initialized with a block implementation, then that
    # implementation will be called in the context of the example group with the
    # given attributes, keywords, and block. Otherwise, the configured
    # implementation for the class (if any) will be applied to the example
    # group.
    #
    # @param example_group [RSpec::Core::ExampleGroup] The example group to
    #   which the contract is applied.
    # @param arguments [Array] Optional arguments to pass to the contract.
    # @param keywords [Hash] Optional keywords to pass to the contract.
    #
    # @yield A block to pass to the contract.
    #
    # @see #to_proc
    def apply(example_group, *arguments, **keywords, &block)
      concern = RSpec::SleepingKingStudios::Concerns::IncludeContract
      name    =
        unless self.class == RSpec::SleepingKingStudios::Contract
          tools.str.underscore(self.class.name).gsub('::', '_')
        end

      concern.define_contract_method(
        context:  example_group,
        contract: self,
        name:     name
      ) do |method_name|
        if keywords.empty?
          example_group.send(method_name, *arguments, &block)
        else
          example_group.send(method_name, *arguments, **keywords, &block)
        end
      end
    end

    # @return [Proc, nil] the contract implementation for the instance or class.
    def to_proc
      contract || self.class.to_proc
    end

    private

    attr_reader :contract

    def tools
      SleepingKingStudios::Tools::Toolbelt.instance
    end
  end
end
