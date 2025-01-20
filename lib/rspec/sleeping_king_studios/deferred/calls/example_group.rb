# frozen_string_literal: true

require 'rspec/sleeping_king_studios/deferred/call'
require 'rspec/sleeping_king_studios/deferred/calls'

module RSpec::SleepingKingStudios::Deferred::Calls
  # Value object representing a deferred RSpec example group.
  class ExampleGroup < RSpec::SleepingKingStudios::Deferred::Call
    def initialize(method_name, *, deferred_example_group:, **, &)
      super(method_name, *, **, &)

      # Store a reference to the deferred group where this is defined.
      @deferred_example_group = deferred_example_group
    end

    def call(parent_group)
      example_group = super

      # Store a reference to the deferred group when adding to an actual example
      # group.
      example_group.metadata[:deferred_example_group] = @deferred_example_group

      example_group
    end
  end
end
