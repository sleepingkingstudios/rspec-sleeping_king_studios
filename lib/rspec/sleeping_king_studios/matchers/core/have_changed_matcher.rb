require 'rspec/sleeping_king_studios/matchers/base_matcher'
require 'rspec/sleeping_king_studios/matchers/core'
require 'rspec/sleeping_king_studios/support/value_observation'

module RSpec::SleepingKingStudios::Matchers::Core
  DEFAULT_VALUE = Object.new.freeze
  private_constant :DEFAULT_VALUE

  # Matcher for testing the change in a value.
  #
  # @since 2.4.0
  class HaveChangedMatcher < RSpec::SleepingKingStudios::Matchers::BaseMatcher
    def initialize
      super

      @expected_initial_value = DEFAULT_VALUE
      @expected_current_value = DEFAULT_VALUE
    end

    # Creates an difference expectation between the initial and current values.
    # The matcher will subtract the current value from the initial value and
    # compare the result with the specified value.
    #
    # @param [Object] difference The expected difference between the initial
    #   value and the current value.
    #
    # @return [HaveChangedMatcher] the matcher instance.
    def by(difference)
      @expected_difference = difference

      self
    end

    # (see BaseMatcher#description)
    def description
      'have changed'
    end

    # (see BaseMatcher#does_not_match?)
    def does_not_match?(actual)
      @actual = actual

      unless actual.is_a?(RSpec::SleepingKingStudios::Support::ValueObservation)
        raise ArgumentError, 'You must pass a value observation to `expect`.'
      end

      unless @expected_current_value == DEFAULT_VALUE
        raise NotImplementedError,
          "`expect { }.not_to have_changed().to()` is not supported"
      end

      if @expected_difference
        raise NotImplementedError,
          "`expect { }.not_to have_changed().by()` is not supported"
      end

      match_initial_value? && !value_has_changed?
    end

    # (see BaseMatcher#failure_message)
    def failure_message
      unless @match_initial_value.nil? || @match_initial_value
        return "expected #{value_observation.description} to have initially " \
          "been #{@expected_initial_value.inspect}, but was " \
          "#{initial_value.inspect}"
      end

      message = "expected #{value_observation.description} to have changed"

      if @expected_difference
        message << " by #{@expected_difference.inspect}"
      end

      unless @expected_current_value == DEFAULT_VALUE
        message << " to #{@expected_current_value.inspect}"
      end

      unless @match_difference.nil? || @match_difference
        return message << ", but was changed by #{@actual_difference.inspect}"
      end

      unless @match_current_value.nil? || @match_current_value
        return message << ", but is now #{current_value.inspect}"
      end

      message << ", but is still #{current_value.inspect}"

      message
    end

    # (see BaseMatcher#failure_message_when_negated)
    def failure_message_when_negated
      unless @match_initial_value.nil? || @match_initial_value
        return "expected #{value_observation.description} to have initially " \
          "been #{@expected_initial_value.inspect}, but was " \
          "#{initial_value.inspect}"
      end

      message = "expected #{value_observation.description} not to have changed"

      message <<
        ", but did change from #{initial_value.inspect} to " <<
        current_value.inspect

      message
    end

    # Creates an expectation on the initial value. The matcher will compare the
    # initial value from the value observation with the specified value.
    #
    # @param [Object] value The expected initial value.
    #
    # @return [HaveChangedMatcher] the matcher instance.
    def from(value)
      @expected_initial_value = value

      self
    end

    # Checks if the observed value has changed.
    #
    # @param [RSpec::SleepingKingStudios::Support::ValueObservation] actual The
    #   observed value.
    #
    # @return [Boolean] True if the observed value has changed, otherwise false.
    #
    # @raise ArgumentError unless the actual object is a value observation.
    def matches?(actual)
      super

      unless actual.is_a?(RSpec::SleepingKingStudios::Support::ValueObservation)
        raise ArgumentError, 'You must pass a value observation to `expect`.'
      end

      match_initial_value? &&
        value_has_changed? &&
        match_current_value? &&
        match_difference?
    end

    # Creates an expectation on the current value. The matcher will compare the
    # current value from the value observation with the specified value.
    #
    # @param [Object] value The expected current value.
    #
    # @return [HaveChangedMatcher] the matcher instance.
    def to(value)
      @expected_current_value = value

      self
    end

    private

    alias_method :value_observation, :actual

    def current_value
      value_observation.current_value
    end

    def initial_value
      value_observation.initial_value
    end

    def match_current_value?
      return @match_current_value unless @match_current_value.nil?

      if @expected_current_value == DEFAULT_VALUE
        return @match_current_value = true
      end

      @match_current_value = RSpec::Support::FuzzyMatcher.values_match?(
        current_value,
        @expected_current_value
      )
    end

    def match_difference?
      return @match_difference unless @match_difference.nil?

      return @match_difference = true unless @expected_difference

      @actual_difference = current_value - initial_value

      @match_difference = RSpec::Support::FuzzyMatcher.values_match?(
        @actual_difference,
        @expected_difference
      )
    end

    def match_initial_value?
      return @match_initial_value unless @match_initial_value.nil?

      if @expected_initial_value == DEFAULT_VALUE
        return @match_initial_value = true
      end

      @match_initial_value = RSpec::Support::FuzzyMatcher.values_match?(
        initial_value,
        @expected_initial_value
      )
    end

    def value_has_changed?
      value_observation.changed?
    end
  end
end
