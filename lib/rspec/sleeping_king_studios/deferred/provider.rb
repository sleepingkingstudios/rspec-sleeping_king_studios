# frozen_string_literal: true

require 'sleeping_king_studios/tools/toolbelt'
require 'sleeping_king_studios/tools/toolbox/mixin'

require 'rspec/sleeping_king_studios/deferred'

module RSpec::SleepingKingStudios::Deferred
  # Methods for registering deferred examples.
  module Provider
    extend SleepingKingStudios::Tools::Toolbox::Mixin

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
      alias deferred_context deferred_examples

      # @api private
      def defined_deferred_examples
        @defined_deferred_examples ||= {}
      end

      # Checks if the given deferred example group is defined.
      #
      # @param description [String] the name of the deferred examples.
      #
      # @return [true, false] true if a deferred example group with the given
      #   description is defined in the current context; otherwise false.
      def defined_deferred_examples?(description)
        ancestors.any? do |ancestor|
          next false unless ancestor.respond_to?(:defined_deferred_examples)

          ancestor.deferred_definition_exists?(description) ||
            ancestor.deferred_module_exists?(description)
        end
      end
      alias defined_deferred_context? defined_deferred_examples?

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

      def deferred_definition_exists?(description)
        defined_deferred_examples.key?(description)
      end

      def deferred_module_exists?(description)
        constants(false)
          .any? do |const_name|
            value = const_get(const_name)

            next false unless module_is_deferred_examples?(value)

            return true if matches_description?(description, const_name, value)
          end
      end

      def find_deferred_definition(description)
        defined_deferred_examples.fetch(description, nil)
      end

      def find_deferred_module(description)
        constants(false)
          .each do |const_name|
            value = const_get(const_name)

            next false unless module_is_deferred_examples?(value)

            return value if matches_description?(description, const_name, value)
          end

        nil
      end

      private

      def find_deferred_by_description(description)
        ancestors.each do |ancestor|
          next unless ancestor.respond_to?(:defined_deferred_examples)

          deferred =
            ancestor.find_deferred_definition(description) ||
            ancestor.find_deferred_module(description)

          return deferred if deferred
        end

        nil
      end

      def matches_description?(description, const_name, value)
        return true if value.description == description

        const_name = const_name.to_s

        return true if const_name == description

        const_name = const_name.gsub(/(Context|Examples?)\z/, '')

        const_name == description
      end

      def module_is_deferred_examples?(value)
        return false unless value.is_a?(Module)

        return false unless value.respond_to?(:deferred_examples?)

        value.deferred_examples?
      end

      def tools
        SleepingKingStudios::Tools::Toolbelt.instance
      end
    end
  end
end
