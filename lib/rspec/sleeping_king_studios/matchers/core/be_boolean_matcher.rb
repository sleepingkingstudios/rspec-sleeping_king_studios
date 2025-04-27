# lib/rspec/sleeping_king_studios/matchers/core/be_boolean_matcher.rb

require 'rspec/sleeping_king_studios/matchers/base_matcher'
require 'rspec/sleeping_king_studios/matchers/core'

module RSpec::SleepingKingStudios::Matchers::Core
  # Matcher for testing whether an object is true or false.
  #
  # @since 1.0.0
  class BeBooleanMatcher < RSpec::SleepingKingStudios::Matchers::BaseMatcher
    include RSpec::Matchers::Composable

    # (see BaseMatcher#description)
    def description
      'be true or false'
    end # method description

    # Checks if the object is true or false.
    #
    # @param [Object] actual The object to check.
    #
    # @return [Boolean] True if the object is true or false, otherwise false.
    def matches? actual
      super

      true === actual || false === actual
    end # method matches?

    # (see BaseMatcher#failure_message)
    def failure_message
      "expected #{@actual.inspect} to be true or false"
    end # method failure_message

    # (see BaseMatcher#failure_message_when_negated)
    def failure_message_when_negated
      "expected #{@actual.inspect} not to be true or false"
    end # method failure_message_when_negated
  end # class
end # module
