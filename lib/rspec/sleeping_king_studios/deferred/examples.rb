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
      DEFERRED_CALL_ORDERING = [
        :example,
        :example_group,
        nil
      ].freeze
      private_constant :DEFERRED_CALL_ORDERING

      ORDERED_TYPES = Set.new(DEFERRED_CALL_ORDERING).freeze
      private_constant :ORDERED_TYPES

      def call(example_group)
        ordered_deferred_calls.each do |deferred|
          deferred.call(example_group)
        end
      end

      # Callback invoked when the module is included in another module or class.
      #
      # Calls the deferred calls with the other module as the receiver if the
      # module is an RSpec::Core::ExampleGroup.
      #
      # @param other [Module] the other module or class.
      def included(other)
        super

        call(other) if other < RSpec::Core::ExampleGroup
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

      def grouped_deferred_calls # rubocop:disable Metrics/MethodLength
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

      def ordered_deferred_calls
        grouped = grouped_deferred_calls

        DEFERRED_CALL_ORDERING.reduce([]) do |calls, key|
          calls + grouped[key]
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
            deferred_calls <<
              RSpec::SleepingKingStudios::Deferred::Example.new(
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
      #     Defines a deferred example group using the $1 method.
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
      #     Defines a deferred example using the $1 method.
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
