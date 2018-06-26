require 'rspec/sleeping_king_studios/matchers/base_matcher'
require 'rspec/sleeping_king_studios/matchers/core'
require 'rspec/sleeping_king_studios/support/value_observation'

module RSpec::SleepingKingStudios::Matchers::Core
  # Matcher for testing the change in a value.
  #
  # @since 2.4.0
  class HaveChangedMatcher < RSpec::SleepingKingStudios::Matchers::BaseMatcher
    # (see BaseMatcher#description)
    def description
      'have changed'
    end

    # (see BaseMatcher#does_not_match?)
    def does_not_match? actual
      super

      unless actual.is_a?(RSpec::SleepingKingStudios::Support::ValueObservation)
        raise ArgumentError, 'You must pass a value observation to `expect`.'
      end

      !value_has_changed?
    end

    # (see BaseMatcher#failure_message)
    def failure_message
      message = "expected #{value_observation.description} to have changed"

      message << ", but is still #{current_value.inspect}"

      message
    end

    # (see BaseMatcher#failure_message_when_negated)
    def failure_message_when_negated
      message = "expected #{value_observation.description} not to have changed"

      message <<
        ", but did change from #{initial_value.inspect} to " <<
        current_value.inspect

      message
    end

    # Checks if the observed value has changed.
    #
    # @param [RSpec::SleepingKingStudios::Support::ValueObservation] actual The
    #   observed value.
    #
    # @return [Boolean] True if the observed value has changed, otherwise false.
    #
    # @raise ArgumentError unless the actual object is a value observation.
    def matches? actual
      super

      unless actual.is_a?(RSpec::SleepingKingStudios::Support::ValueObservation)
        raise ArgumentError, 'You must pass a value observation to `expect`.'
      end

      value_has_changed?
    end

    private

    alias_method :value_observation, :actual

    def current_value
      value_observation.current_value
    end

    def initial_value
      value_observation.initial_value
    end

    def value_has_changed?
      value_observation.changed?
    end
  end
end
