# frozen_string_literal: true

require 'rspec/sleeping_king_studios/deferred/examples'

module RSpec::SleepingKingStudios::Deferred::Examples
  # Class methods for defining a registry of deferred calls.
  module Definitions
    DEFERRED_CALL_ORDERING = [
      :example,
      :example_group,
      :hooks,
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
        unless ancestor.singleton_class.method_defined?(:deferred_calls)
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
end
