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
      # @overload include_deferred(description, *arguments, **keywords, &block)
      #   Includes the deferred examples with the given definition.
      #
      #   @param description [String] the name of the deferred examples.
      #   @param arguments [Array] arguments passed to the deferred examples.
      #   @param keywords [Hash] keywords passed to the deferred examples.
      #   @param block [Block] a block passed to the deferred examples.
      def include_deferred(description, ...)
        deferred = find_deferred_examples(description)

        if deferred.is_a?(Proc)
          deferred = define_deferred_module(deferred, description, ...)
        end

        include deferred
      end

      private

      def define_deferred_module(implementation, description, ...)
        Module.new do
          include RSpec::SleepingKingStudios::Deferred::Examples

          self.description = description

          define_singleton_method(
            :deferred_examples_implementation,
            &implementation
          )

          deferred_examples_implementation(...)
        end
      end
    end
  end
end
