# frozen_string_literal: true

require 'rspec/sleeping_king_studios/deferred/call'
require 'rspec/sleeping_king_studios/deferred/calls'

module RSpec::SleepingKingStudios::Deferred::Calls
  # Value object representing a deferred RSpec example.
  class Example < RSpec::SleepingKingStudios::Deferred::Call
    # (see RSpec::SleepingKingStudios::Deferred::Call#type)
    def type
      :example
    end
  end
end