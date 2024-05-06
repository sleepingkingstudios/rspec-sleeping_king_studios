# frozen_string_literal: true

require 'set'

require 'rspec/sleeping_king_studios/deferred'
require 'rspec/sleeping_king_studios/deferred/example'

module RSpec::SleepingKingStudios::Deferred
  # Defines a deferred example group for declaring shared tests.
  module Examples
    # Class methods for defining a registry of deferred calls.
    module Definitions
      # The defined ordering for calling deferred calls by type.
      DEFERRED_CALL_ORDERING = %i[
        example
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

      def ordered_deferred_calls # rubocop:disable Metrics/MethodLength
        ancestors.reduce({}) do |memo, ancestor|
          unless ancestor < RSpec::SleepingKingStudios::Deferred::Examples
            return memo
          end

          ancestor.deferred_calls.each_with_object(memo) \
          do |deferred_call, calls|
            key = deferred_call_key(deferred_call)

            (calls[key] ||= []) << deferred_call

            calls
          end
        end
      end
    end

    # DSL for defining deferred examples and test setup.
    module DSL
      include RSpec::SleepingKingStudios::Deferred::Examples::Definitions

      # Methods that define a deferred example.
      EXAMPLE_METHODS = %i[
        example
        fexample
        fit
        focus
        fspecify
        it
        pending
        skip
        specify
        xexample
        xit
        xspecify
      ].freeze

      class << self
        private

        def define_deferred_example(method_name)
          define_method(method_name) do |*args, **kwargs, &block|
            deferred_calls << RSpec::SleepingKingStudios::Deferred::Example.new(
              method_name,
              *args,
              **kwargs,
              &block
            )
          end
        end
      end

      # @!macro [new] example_method
      #   @param doc_string [String] the example's doc string.
      #   @param flags [Array<Symbol>] metadata flags for the example. Will be
      #     transformed into metadata entries with true values.
      #   @param metadata [Hash] metadata for the example.
      #   @param block [Proc] the implementation of the example.
      #
      #   @return [void]

      # @!method example(doc_string = nil, *flags, **metadata, &block)
      #   Defines a deferred example.
      #
      #   @!macro example_method

      # @!method fexample(doc_string = nil, *flags, **metadata, &block)
      #   Defines a deferred example with focus: true.
      #
      #   @!macro example_method

      # @!method fit(doc_string = nil, *flags, **metadata, &block)
      #   Defines a deferred example with focus: true.
      #
      #   @!macro example_method

      # @!method focus(doc_string = nil, *flags, **metadata, &block)
      #   Defines a deferred example with focus: true.
      #
      #   @!macro example_method

      # @!method fspecify(doc_string = nil, *flags, **metadata, &block)
      #   Defines a deferred example with focus: true.
      #
      #   @!macro example_method

      # @!method example(doc_string = nil, *flags, **metadata, &block)
      #   Defines a deferred example.
      #
      #   @!macro example_method

      # @!method pending(doc_string = nil, *flags, **metadata, &block)
      #   Defines a deferred example with pending: true.
      #
      #   @!macro example_method

      # @!method skip(doc_string = nil, *flags, **metadata, &block)
      #   Defines a deferred example with skip: true.
      #
      #   @!macro example_method

      # @!method specify(doc_string = nil, *flags, **metadata, &block)
      #   Defines a deferred example.
      #
      #   @!macro example_method

      # @!method xexample(doc_string = nil, *flags, **metadata, &block)
      #   Defines a deferred example with skip: 'Temporarily skipped ...'.
      #
      #   @!macro example_method

      # @!method xit(doc_string = nil, *flags, **metadata, &block)
      #   Defines a deferred example with skip: 'Temporarily skipped ...'.
      #
      #   @!macro example_method

      # @!method xspecify(doc_string = nil, *flags, **metadata, &block)
      #   Defines a deferred example with skip: 'Temporarily skipped ...'.
      #
      #   @!macro example_method

      EXAMPLE_METHODS.each do |method_name|
        define_deferred_example(method_name)
      end
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
