# frozen_string_literal: true

require 'rspec/sleeping_king_studios/deferred/call'
require 'rspec/sleeping_king_studios/deferred/calls'

module RSpec::SleepingKingStudios::Deferred::Calls
  # Value object representing a deferred RSpec included example group.
  class IncludedExamples < RSpec::SleepingKingStudios::Deferred::Call
    # @return [String] the description for the shared example group.
    def name
      arguments.first
    end

    private

    def validate_name!
      return if name.is_a?(Module)

      return if (name.is_a?(String) || name.is_a?(Symbol)) && !name.to_s.empty?

      message =
        'shared example group name must be a non-empty String, Symbol, or ' \
        'Module'

      raise ArgumentError, message
    end

    def validate_parameters!
      super

      validate_name!
    end
  end
end
