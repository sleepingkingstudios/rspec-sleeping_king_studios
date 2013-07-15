# lib/rspec/sleeping_king_studios/matchers/base_matcher.rb

require 'rspec/sleeping_king_studios/matchers/require'

module RSpec::SleepingKingStudios::Matchers
  # Minimal implementation of the RSpec matcher interface.
  # 
  # @since 1.0.0
  class BaseMatcher
    def initialize *args
    end # constructor

    # A short string that describes the purpose of the matcher.
    # 
    # @return [String] the matcher description
    def description
      "match"
    end # method description

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
    def failure_message_for_should
      "expected #{@actual.inspect} to #{description}"
    end # method failure_message_for_should

    # Message for when the object matches, but was expected not to. Make sure
    # to always call #matches? first to set up the matcher state.
    def failure_message_for_should_not
      "expected #{@actual.inspect} not to #{description}"
    end # method failure_message_for_should_not
  end # class
end # module
