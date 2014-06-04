# lib/rspec/sleeping_king_studios/matchers/rspec/fail_with_actual.rb

require 'rspec/sleeping_king_studios/matchers/base_matcher'
require 'rspec/sleeping_king_studios/matchers/meta/require'

module RSpec::SleepingKingStudios::Matchers::Meta
  # Matcher for testing whether an RSpec matcher will fail with a given actual
  # object, and return the specified failure message if the matcher is called
  # via expect#to.
  # 
  # @note Do not use this matcher with expect#not_to to verify that a matcher
  #   will pass with a given actual object; use the #pass_with_actual matcher
  #   instead.
  # 
  # @see RSpec::SleepingKingStudios::Matchers::Meta::PassWithActualMatcher
  # 
  # @since 1.0.0
  class FailWithActualMatcher < RSpec::SleepingKingStudios::Matchers::BaseMatcher
    # @param [Object] expected the actual object to check the matcher against
    def initialize expected
      @expected = expected
    end # method initialize

    # Checks if the matcher evaluates to false with the expected object. If a
    # message expectation is set, checks the value of
    # #failure_message against the expected message.
    # 
    # @param [Object] actual the RSpec matcher to check; should respond to
    #   :matches? and :failure_message, as a minimum
    # 
    # @return [Boolean] true if the matcher evaluates to false and the
    #   matcher's #failure_message matches the expected message
    #   (if any); otherwise false
    def matches? actual
      super

      return false if matches_actual?

      if @message.is_a? Regexp
        !!(@actual.failure_message =~ @message)
      elsif @message
        @actual.failure_message == @message.to_s
      else
        true
      end # if-elsif-else
    end # method matches?

    def failure_message
      if @matches
        "expected #{@actual} not to match #{@expected}"
      else
        message_text = @message.is_a?(Regexp) ? @message.inspect : @message.to_s

        "expected message#{@message.is_a?(Regexp) ? " matching" : ""}:\n#{
          message_text.lines.map { |line| "#{" " * 2}#{line}" }.join
        }\nreceived message:\n#{
          @actual.failure_message.lines.map { |line| "#{" " * 2}#{line}" }.join
        }"
      end # if-else
    end # method failure_message

    # @see BaseMatcher#failure_message_when_negated
    def failure_message_when_negated
      "failure: testing positive condition with negative matcher\n~>  use the :pass_with_actual matcher instead"
    end # method failure_message_when_negated

    # The expected failure message for should when the matcher is called via
    # expect#to.
    # 
    # @return [String, nil] the expected message if one has been defined;
    #   otherwise nil
    attr_reader :message

    # Sets up a message expectation. When the matcher is called with the
    # provided actual object, the matcher's failure_message
    # message is compared to the provided message.
    # 
    # @param [String, Regexp] message the message to compare
    # 
    # @return [FailWithActualMatcher] self
    def with_message message
      @message = message
      self
    end # method with_message

    private

    # Handles the actual matching through #does_not_match? if the matcher
    # supports that method, otherwise falls back to @matches?.
    # 
    # @return [Boolean]
    def matches_actual?
      if @actual.respond_to?(:does_not_match?)
        @matches = !@actual.does_not_match?(@expected)
      else
        @matches = @actual.matches?(@expected)
      end # if-else
    end # method matches_actual?
  end # class
end # module

module RSpec::SleepingKingStudios::Matchers
  # @see RSpec::SleepingKingStudios::Matchers::Meta::FailWithActualMatcher#matches?
  def fail_with_actual expected
    Meta::FailWithActualMatcher.new expected
  end # method fail_with_actual
end # module
