# frozen_string_literal: true

require 'set'

require 'rspec/sleeping_king_studios/deferred'
require 'rspec/sleeping_king_studios/deferred/example'
require 'rspec/sleeping_king_studios/deferred/example_group'

module RSpec::SleepingKingStudios::Deferred
  # Defines a deferred example group for declaring shared tests.
  module Examples
    # Class methods for defining a registry of deferred calls.
    module Definitions
      # The defined ordering for calling deferred calls by type.
      DEFERRED_CALL_ORDERING = %i[
        example
        example_group
      ].freeze

      ORDERED_TYPES = Set.new(DEFERRED_CALL_ORDERING).freeze
      private_constant :DEFERRED_CALL_ORDERING

      def call(example_group)
        ordered_calls = ordered_deferred_calls

        ORDERED_TYPES.each do |type|
          ordered_calls[type].each do |deferred|
            deferred.call(example_group)
          end
        end
      end

      protected

      def deferred_calls
        @deferred_calls ||= []
      end

      private

      def deferred_call_key(deferred_call)
        return nil unless ORDERED_TYPES.include?(deferred_call.type)

        deferred_call.type
      end

      def empty_ordered_calls
        [*DEFERRED_CALL_ORDERING, nil].to_h { |key| [key, []] }
      end

      def ordered_deferred_calls # rubocop:disable Metrics/MethodLength
        ancestors.reduce(empty_ordered_calls) do |memo, ancestor|
          unless ancestor < RSpec::SleepingKingStudios::Deferred::Examples
            return memo
          end

          ancestor.deferred_calls.each_with_object(memo) \
          do |deferred_call, calls|
            key = deferred_call_key(deferred_call)

            calls[key] << deferred_call

            calls
          end
        end
      end
    end

    # DSL for defining deferred examples and test setup.
    module DSL
      include RSpec::SleepingKingStudios::Deferred::Examples::Definitions

      class << self
        private

        def define_example_method(method_name)
          define_method(method_name) do |*args, **kwargs, &block|
            deferred_calls << RSpec::SleepingKingStudios::Deferred::Example.new(
              method_name,
              *args,
              **kwargs,
              &block
            )
          end
        end

        def define_example_group_method(method_name)
          define_method(method_name) do |*args, **kwargs, &block|
            deferred_calls <<
              RSpec::SleepingKingStudios::Deferred::ExampleGroup.new(
                method_name,
                *args,
                **kwargs,
                &block
              )
          end
        end
      end

      # @!macro [new] define_example_group_method
      #   @!method $1(doc_string = nil, *flags, **metadata, &block)
      #     Defines a deferred example group.
      #
      #     @param doc_string [String] the example group's doc string.
      #     @param flags [Array<Symbol>] metadata flags for the example group.
      #       Will be transformed into metadata entries with true values.
      #     @param metadata [Hash] metadata for the example group.
      #     @param block [Proc] the implementation of the example group.
      #
      #     @return [void]

      # @!macro [new] define_example_method
      #   @!method $1(doc_string = nil, *flags, **metadata, &block)
      #     Defines a deferred example.
      #
      #     @param doc_string [String] the example's doc string.
      #     @param flags [Array<Symbol>] metadata flags for the example. Will be
      #       transformed into metadata entries with true values.
      #     @param metadata [Hash] metadata for the example.
      #     @param block [Proc] the implementation of the example.
      #
      #     @return [void]

      # @!macro define_example_method
      define_example_method :example

      # @!macro define_example_method
      define_example_method :fexample

      # @!macro define_example_method
      define_example_method :fit

      # @!macro define_example_method
      define_example_method :focus

      # @!macro define_example_method
      define_example_method :fspecify

      # @!macro define_example_method
      define_example_method :it

      # @!macro define_example_method
      define_example_method :pending

      # @!macro define_example_method
      define_example_method :skip

      # @!macro define_example_method
      define_example_method :specify

      # @!macro define_example_method
      define_example_method :xexample

      # @!macro define_example_method
      define_example_method :xit

      # @!macro define_example_method
      define_example_method :xspecify

      # @!macro define_example_group_method
      define_example_group_method :context

      # @!macro define_example_group_method
      define_example_group_method :describe

      # @!macro define_example_group_method
      define_example_group_method :example_group

      # @!macro define_example_group_method
      define_example_group_method :fcontext

      # @!macro define_example_group_method
      define_example_group_method :fdescribe

      # @!macro define_example_group_method
      define_example_group_method :xcontext

      # @!macro define_example_group_method
      define_example_group_method :xdescribe
    end

    # Callback invoked when the module is included in another module or class.
    #
    # Extends the class or module with the Deferred::Examples::Definitions
    # and Deferred::Examples::DSL modules.
    #
    # @param other [Module] the other module or class.
    #
    # @see RSpec::SleepingKingStudios::Deferred::Definitions.
    # @see RSpec::SleepingKingStudios::Deferred::DSL.
    def self.included(other)
      super

      other.extend(RSpec::SleepingKingStudios::Deferred::Examples::DSL)
    end
  end
end
