# frozen_string_literal: true

require 'sleeping_king_studios/tools/toolbelt'

require 'rspec/sleeping_king_studios/deferred'

module RSpec::SleepingKingStudios::Deferred
  # Methods for registering deferred examples.
  module Provider
    # Exception raised when the requested deferred examples are not defined.
    class DeferredExamplesNotFoundError < StandardError; end

    # Class methods for registering deferred examples.
    module ClassMethods
      # Defines deferred examples in the current context.
      #
      # @param description [String] the name of the deferred examples.
      #
      # @yield [*arguments, **keywords, &block] the definition for the deferred
      #   examples. Supports the same DSL as an RSpec::Core::ExampleGroup. If
      #   the block takes parameters, these can be used to customize the
      #   behavior of the deferred examples when they are included in an example
      #   group.
      # @yieldparam arguments [Array] arguments passed to the deferred examples.
      # @yieldparam keywords [Hash] keywords passed to the deferred examples.
      # @yieldparam block [Block] a block passed to the deferred examples.
      #
      # @example Defining Deferred Examples
      #   deferred_examples 'should be a Rocket' do
      #     it { expect(subject).to be_a Rocket }
      #   end
      #
      # @example Defining Parameterized Examples
      #   deferred_examples 'should be a Vehicle' do |expected_type:|
      #     it { expect(subject).to be_a Vehicle }
      #
      #     it { expect(subject.tyoe).to be == expected_type }
      #   end
      def deferred_examples(description, &block)
        raise ArgumentError, 'block is required' unless block_given?

        tools.assertions.validate_name(description, as: 'description')

        defined_deferred_examples[description.to_s] = block

        nil
      end

      # @api private
      def defined_deferred_examples
        @defined_deferred_examples ||= {}
      end

      # @api private
      def find_deferred_examples(description)
        tools.assertions.validate_name(description, as: 'description')

        deferred = find_deferred_by_description(description.to_s)

        return deferred if deferred

        message =
          'deferred examples not found with description ' \
          "#{description.to_s.inspect}"

        raise DeferredExamplesNotFoundError, message
      end

      protected

      def find_deferred_by_name(description, const_name, full_name)
        if defined_deferred_examples.key?(description)
          return defined_deferred_examples[description]
        end

        return const_get(const_name) if const_defined?(const_name, false)

        const_get(full_name) if full_name && const_defined?(full_name, false)
      end

      private

      def find_deferred_by_description(description) # rubocop:disable Metrics/MethodLength
        const_name =
          tools.string_tools.camelize(description.tr(' ', '_').tr('-', ' '))
        full_name  =
          const_name.end_with?('Examples') ? nil : "#{const_name}Examples"

        ancestors.each do |ancestor|
          break unless ancestor.respond_to?(:defined_deferred_examples)

          deferred =
            ancestor.find_deferred_by_name(description, const_name, full_name)

          return deferred if deferred
        end

        nil
      end

      def tools
        SleepingKingStudios::Tools::Toolbelt.instance
      end
    end

    # Callback invoked when the module is included in another module or class.
    #
    # Extends ClassMethods into the other module.
    #
    # @param other [Module] the other module or class.
    def self.included(other)
      super

      other.extend(ClassMethods)
    end
  end
end
