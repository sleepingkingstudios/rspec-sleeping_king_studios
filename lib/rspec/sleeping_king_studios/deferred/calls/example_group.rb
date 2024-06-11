# frozen_string_literal: true

require 'rspec/sleeping_king_studios/deferred/call'
require 'rspec/sleeping_king_studios/deferred/calls'

module RSpec::SleepingKingStudios::Deferred::Calls
  # Value object representing a deferred RSpec example group.
  class ExampleGroup < RSpec::SleepingKingStudios::Deferred::Call; end
end
