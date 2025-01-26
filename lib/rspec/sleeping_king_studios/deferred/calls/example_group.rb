# frozen_string_literal: true

require 'rspec/sleeping_king_studios/deferred/call'
require 'rspec/sleeping_king_studios/deferred/calls'

module RSpec::SleepingKingStudios::Deferred::Calls
  # Value object representing a deferred RSpec example group.
  class ExampleGroup < RSpec::SleepingKingStudios::Deferred::Call
    # @param method_name [String, Symbol] the name of the method to call.
    # @param arguments [Array] the arguments to pass to the method.
    # @param keywords [Hash] the keywords to pass to the method.
    # @param deferred_example_group [Deferred::Examples] the deferred example
    #   group defining the deferred call.
    # @param block [Proc] the block to pass to the method.
    def initialize(
      method_name,
      *arguments,
      deferred_example_group: nil,
      **keywords,
      &block
    )
      super(method_name, *arguments, **keywords, &block)

      @deferred_example_group = deferred_example_group
    end

    # @return [Deferred::Examples] the deferred example group defining the
    #   deferred call.
    attr_reader :deferred_example_group
  end
end
