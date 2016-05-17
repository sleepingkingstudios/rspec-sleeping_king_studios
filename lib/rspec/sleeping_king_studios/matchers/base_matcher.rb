# lib/rspec/sleeping_king_studios/matchers/base_matcher.rb

require 'rspec/sleeping_king_studios/matchers'
require 'rspec/sleeping_king_studios/matchers/description'

require 'sleeping_king_studios/tools/string_tools'

module RSpec::SleepingKingStudios::Matchers
  # Minimal implementation of the RSpec matcher interface.
  #
  # @since 1.0.0
  class BaseMatcher
    include RSpec::SleepingKingStudios::Matchers::Description

    attr_reader :actual

    # Inverse of #matches? method.
    #
    # @param [Object] actual the object to test against the matcher
    #
    # @return [Boolean] false if the object matches, otherwise true
    #
    # @see #matches?
    def does_not_match? actual
      !matches?(actual)
    end # method does_not_match?

    # Tests the actual object to see if it matches the defined condition(s).
    # Invoked by RSpec expectations.
    #
    # @param [Object] actual the object to test against the matcher
    #
    # @return [Boolean] true if the object matches, otherwise false
    def matches? actual
      @actual = actual

      true
    end # method matches?

    # Message for when the object does not match, but was expected to. Make
    # sure to always call #matches? first to set up the matcher state.
    def failure_message
      "expected #{@actual.inspect} to #{description}"
    end # method failure_message

    # Message for when the object matches, but was expected not to. Make sure
    # to always call #matches? first to set up the matcher state.
    def failure_message_when_negated
      "expected #{@actual.inspect} not to #{description}"
    end # method failure_message_when_negated
  end # class
end # module
