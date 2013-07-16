# lib/rspec/sleeping_king_studios/matchers/core/have_reader.rb

require 'rspec/sleeping_king_studios/matchers/base_matcher'
require 'rspec/sleeping_king_studios/matchers/core/require'

module RSpec::SleepingKingStudios::Matchers::Core
  # Matcher for testing whether an object has a specific property reader, e.g.
  # responds to :property.
  # 
  # @since 1.0.0
  class HaveReaderMatcher < RSpec::SleepingKingStudios::Matchers::BaseMatcher
    # @param [String, Symbol] expected the property to check for on the actual
    #   object
    def initialize expected
      super
      @expected = expected.intern
    end # method initialize

    # Checks if the object responds to :expected. Additionally, if a value
    # expectation is set, compares the value of :expected to the specified
    # value.
    # 
    # @param [Object] actual the object to check
    # 
    # @return [Boolean] true if the object responds to :expected and matches
    #    the value expectation (if any); otherwise failure_message_for_should
    def matches? actual
      super

      return false unless @match_reader = @actual.respond_to?(@expected)

      if @value_set
        return false unless @match_value = @actual.send(@expected) == @value
      end # if
      
      true
    end # method matches?

    # Sets a value expectation. The matcher will compare the value from
    # :property with the specified value.
    # 
    # @params [Object] value the value to compare
    # 
    # @return [HaveReaderMatcher] self
    def with value
      @value = value
      @value_set = true
      self
    end # method with

    # @see BaseMatcher#failure_message_for_should
    def failure_message_for_should
      unless @match_reader
        return "expected #{@actual} to respond to #{@expected.inspect}"
      end # unless
      
      "unexpected value for #{@actual}\##{@expected}\n" +
          "  expected: #{@value.inspect}\n" +
          "       got: #{@actual.send(@expected).inspect}"
    end # method failure_message_for_should

    # @see BaseMatcher#failure_message_for_should_not
    def failure_message_for_should_not
      message = "expected #{@actual} not to respond to #{@expected.inspect}"
      message << " with value #{@value.inspect}" if @value_set
      message
    end # method failure_message_for_should
  end # class
end # module

module RSpec::SleepingKingStudios::Matchers
  # @see RSpec::SleepingKingStudios::Matchers::Core::HaveReaderMatcher#matches?
  def have_reader expected
    RSpec::SleepingKingStudios::Matchers::Core::HaveReaderMatcher.new expected
  end # method have_reader
end # module
