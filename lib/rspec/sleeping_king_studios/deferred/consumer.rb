# frozen_string_literal: true

require 'sleeping_king_studios/tools/toolbox/mixin'

require 'rspec/sleeping_king_studios/deferred'
require 'rspec/sleeping_king_studios/deferred/examples'
require 'rspec/sleeping_king_studios/deferred/provider'

module RSpec::SleepingKingStudios::Deferred
  # Methods for including deferred examples.
  module Consumer
    extend  SleepingKingStudios::Tools::Toolbox::Mixin
    include RSpec::SleepingKingStudios::Deferred::Provider

    # Class methods for registering deferred examples.
    module ClassMethods
      # @overload finclude_deferred(description, *arguments, **keywords, &block)
      #   Includes the deferred examples inside a focused example group.
      #
      #   @param description [String] the name of the deferred examples.
      #   @param arguments [Array] arguments passed to the deferred examples.
      #   @param keywords [Hash] keywords passed to the deferred examples.
      #   @param block [Block] a block passed to the deferred examples.
      def finclude_deferred(description, ...)
        fdescribe '(focused)' do
          include_deferred(description, ...)
        end
      end

      # @overload fwrap_deferred(description, *arguments, **keywords, &block)
      #   Includes the deferred examples inside a focused example group.
      #
      #   Unlike #include_deferred, a block parameter will be included in the
      #   created example group, not passed to the deferred examples. To wrap
      #   deferred examples that require a block, create the example group
      #   separately and call #include_deferred.
      #
      #   @param description [String] the name of the deferred examples.
      #   @param arguments [Array] arguments passed to the deferred examples.
      #   @param keywords [Hash] keywords passed to the deferred examples.
      #   @param block [Block] additional examples to be evaluated inside the
      #     example group.
      def fwrap_deferred(description, *args, **kwargs, &block)
        fdescribe "(focused) #{description}" do
          include_deferred(description, *args, **kwargs)

          instance_exec(&block) if block_given?
        end
      end

      # @overload include_deferred(description, *arguments, **keywords, &block)
      #   Includes the deferred examples with the given definition.
      #
      #   @param description [String] the name of the deferred examples.
      #   @param arguments [Array] arguments passed to the deferred examples.
      #   @param keywords [Hash] keywords passed to the deferred examples.
      #   @param block [Block] a block passed to the deferred examples.
      def include_deferred(description, ...)
        deferred = find_deferred_examples(description)

        deferred =
          if deferred.is_a?(Proc)
            define_deferred_module(deferred, description, ...)
          else
            wrap_deferred_module(deferred)
          end

        deferred.parent_group = self

        include deferred
      end

      # @overload wrap_deferred(description, *arguments, **keywords, &block)
      #   Includes the deferred examples inside an example group.
      #
      #   Unlike #include_deferred, a block parameter will be included in the
      #   created example group, not passed to the deferred examples. To wrap
      #   deferred examples that require a block, create the example group
      #   separately and call #include_deferred.
      #
      #   @param description [String] the name of the deferred examples.
      #   @param arguments [Array] arguments passed to the deferred examples.
      #   @param keywords [Hash] keywords passed to the deferred examples.
      #   @param block [Block] additional examples to be evaluated inside the
      #     example group.
      def wrap_deferred(description, *args, **kwargs, &block)
        describe description do
          include_deferred(description, *args, **kwargs)

          instance_exec(&block) if block_given?
        end
      end

      # @overload xinclude_deferred(description, *arguments, **keywords, &block)
      #   Includes the deferred examples inside a skipped example group.
      #
      #   @param description [String] the name of the deferred examples.
      #   @param arguments [Array] arguments passed to the deferred examples.
      #   @param keywords [Hash] keywords passed to the deferred examples.
      #   @param block [Block] a block passed to the deferred examples.
      def xinclude_deferred(description, ...)
        xdescribe '(skipped)' do
          include_deferred(description, ...)
        end
      end

      # @overload xwrap_deferred(description, *arguments, **keywords, &block)
      #   Includes the deferred examples inside a skipped example group.
      #
      #   Unlike #include_deferred, a block parameter will be included in the
      #   created example group, not passed to the deferred examples. To wrap
      #   deferred examples that require a block, create the example group
      #   separately and call #include_deferred.
      #
      #   @param description [String] the name of the deferred examples.
      #   @param arguments [Array] arguments passed to the deferred examples.
      #   @param keywords [Hash] keywords passed to the deferred examples.
      #   @param block [Block] additional examples to be evaluated inside the
      #     example group.
      def xwrap_deferred(description, *args, **kwargs, &block)
        xdescribe "(skipped) #{description}" do
          include_deferred(description, *args, **kwargs)

          instance_exec(&block) if block_given?
        end
      end

      private

      def define_deferred_module(implementation, description, ...)
        Module.new do
          extend  RSpec::SleepingKingStudios::Deferred::Examples::ClassMethods
          include RSpec::SleepingKingStudios::Deferred::Examples

          self.description     = description
          self.source_location = implementation.source_location

          define_singleton_method(
            :deferred_examples_implementation,
            &implementation
          )

          deferred_examples_implementation(...)
        end
      end

      def wrap_deferred_module(examples)
        Module.new do
          extend  RSpec::SleepingKingStudios::Deferred::Examples::ClassMethods
          include RSpec::SleepingKingStudios::Deferred::Examples
          include examples

          self.description     = examples.description
          self.source_location = examples.source_location
        end
      end
    end
  end
end
