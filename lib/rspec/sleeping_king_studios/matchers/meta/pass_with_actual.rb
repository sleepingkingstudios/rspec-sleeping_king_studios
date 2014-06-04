# lib/rspec/sleeping_king_studios/matchers/meta/pass_with_actual.rb

require 'rspec/sleeping_king_studios/matchers/base_matcher'
require 'rspec/sleeping_king_studios/matchers/meta/require'

module RSpec::SleepingKingStudios::Matchers::Meta
  # Matcher for testing whether an RSpec matcher will pass with a given actual
  # object, and return the specified failure message if the matcher is called
  # via expect#not_to.
  # 
  # @note Do not use this matcher with expect#not_to to verify that a matcher
  #   will fail with a given actual object; use the #fail_with_actual matcher
  #   instead.
  # 
  # @see RSpec::SleepingKingStudios::Matchers::Meta::FailWithActualMatcher
  # 
  # @since 1.0.0
  class PassWithActualMatcher < RSpec::SleepingKingStudios::Matchers::BaseMatcher
    # @param [Object] expected the actual object to check the matcher against
    def initialize expected
      @expected = expected
    end # method initialize

    # Checks if the matcher evaluates to true with the expected object. If a
    # message expectation is set, checks the value of
    # #failure_message_when_negated against the expected message.
    # 
    # @param [Object] actual the RSpec matcher to check; should respond to
    #   :matches? and :failure_message_when_negated, as a minimum
    # 
    # @return [Boolean] true if the matcher evaluates to true and the matcher's
    #   #failure_message_when_negated matches the expected message (if any);
    #   otherwise false
    def matches? actual
      super
      return false unless @matches = @actual.matches?(@expected)

      if @message.is_a? Regexp
        !!(@actual.failure_message_when_negated =~ @message)
      elsif @message
        @actual.failure_message_when_negated == @message.to_s
      else
        true
      end # if-elsif-else
    end # method matches?

    # @see BaseMatcher#failure_message_when_negated
    def failure_message
      if @matches
        message_text = @message.is_a?(Regexp) ? @message.inspect : @message.to_s

        "expected message#{@message.is_a?(Regexp) ? " matching" : ""}:\n#{
          message_text.lines.map { |line| "#{" " * 2}#{line}" }.join
        }\nreceived message:\n#{
          @actual.failure_message_when_negated.lines.map { |line| "#{" " * 2}#{line}" }.join
        }"
      else
        failure_message = @actual.failure_message
        failure_message = failure_message.lines.map { |line| "#{" " * 4}#{line}" }.join("\n")
        "expected #{@actual} to match #{@expected}\n  message:\n#{failure_message}"
      end # if-else
    end # method failure_message
    
    # @see BaseMatcher#failure_message_when_negated
    def failure_message_when_negated
      "failure: testing negative condition with positive matcher\n~>  use the :fail_with_actual matcher instead"
    end # method failure_message_when_negated

    # The expected failure message for should_not when the matcher is called
    # via expect#not_to.
    # 
    # @return [String, nil] the expected message if one has been defined;
    #   otherwise nil
    attr_reader :message

    # Sets up a message expectation. When the matcher is called with the
    # provided actual object, the matcher's failure_message_when_negated
    # message is compared to the provided message.
    # 
    # @param [String, Regexp] message the message to compare
    # 
    # @return [PassWithActualMatcher] self
    def with_message message
      @message = message
      self
    end # method with_message
  end # class
end # module

module RSpec::SleepingKingStudios::Matchers
  # @see RSpec::SleepingKingStudios::Matchers::Meta::PassWithActualMatcher#matches?
  def pass_with_actual expected
    Meta::PassWithActualMatcher.new expected
  end # method pass_with_actual
end # module
