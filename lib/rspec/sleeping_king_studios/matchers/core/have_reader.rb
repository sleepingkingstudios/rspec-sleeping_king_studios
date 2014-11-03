# lib/rspec/sleeping_king_studios/matchers/core/have_reader.rb

require 'rspec/sleeping_king_studios/matchers/base_matcher'
require 'rspec/sleeping_king_studios/matchers/core'
require 'rspec/sleeping_king_studios/matchers/shared/match_property'

module RSpec::SleepingKingStudios::Matchers::Core
  # Matcher for testing whether an object has a specific property reader, e.g.
  # responds to :property.
  #
  # @since 1.0.0
  class HaveReaderMatcher < RSpec::SleepingKingStudios::Matchers::BaseMatcher
    include RSpec::SleepingKingStudios::Matchers::Shared::MatchProperty

    # Generates a description of the matcher expectation.
    #
    # @return [String] The matcher description.
    def description
      value_message = value_to_string
      "have reader :#{@expected}#{@value_set ? " with value #{value_message}" : ''}"
    end # method description

    # @param [String, Symbol] expected the property to check for on the actual
    #   object
    def initialize expected
      @expected = expected.intern
    end # method initialize

    # Checks if the object responds to :expected. Additionally, if a value
    # expectation is set, compares the value of :expected to the specified
    # value.
    #
    # @param [Object] actual the object to check
    #
    # @return [Boolean] true if the object responds to :expected and matches
    #    the value expectation (if any); otherwise false
    def matches? actual
      super

      responds_to_reader? && matches_reader_value?
    end # method matches?

    # Sets a value expectation. The matcher will compare the value from
    # :property with the specified value.
    #
    # @param [Object] value the value to compare
    #
    # @return [HaveReaderMatcher] self
    def with value
      @value = value
      @value_set = true
      self
    end # method with
    alias_method :with_value, :with

    # @see BaseMatcher#failure_message
    def failure_message
      message = "expected #{@actual} to respond to :#{@expected}"
      message << " and return #{value_to_string}" if @value_set

      if !@matches_reader
        message << ", but did not respond to :#{@expected}"
      elsif !@matches_reader_value
        message << ", but returned #{@actual.send(@expected).inspect}"
      end # if

      message
    end # method failure_message

    # @see BaseMatcher#failure_message_when_negated
    def failure_message_when_negated
      message = "expected #{@actual} not to respond to :#{@expected}"
      message << " and return #{value_to_string}" if @value_set
      message
    end # method failure_message
  end # class
end # module

module RSpec::SleepingKingStudios::Matchers
  # @see RSpec::SleepingKingStudios::Matchers::Core::HaveReaderMatcher#matches?
  def have_reader expected
    RSpec::SleepingKingStudios::Matchers::Core::HaveReaderMatcher.new expected
  end # method have_reader
end # module
