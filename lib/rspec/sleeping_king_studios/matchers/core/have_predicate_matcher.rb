# lib/rspec/sleeping_king_studios/matchers/core/have_predicate_matcher.rb

require 'rspec/sleeping_king_studios/matchers/base_matcher'
require 'rspec/sleeping_king_studios/matchers/core'
require 'rspec/sleeping_king_studios/matchers/core/be_boolean_matcher'
require 'rspec/sleeping_king_studios/matchers/shared/match_property'

module RSpec::SleepingKingStudios::Matchers::Core
  # Matcher for testing whether an object has a specific predicate, e.g.
  # responds to :property?.
  #
  # @since 2.2.0
  class HavePredicateMatcher < RSpec::SleepingKingStudios::Matchers::BaseMatcher
    include RSpec::Matchers::Composable
    include RSpec::SleepingKingStudios::Matchers::Shared::MatchProperty

    # Generates a description of the matcher expectation.
    #
    # @return [String] The matcher description.
    def description
      "have predicate :#{@expected}?"
    end # method description

    # @param [String, Symbol] expected The predicate to check for on the actual
    #   object.
    def initialize expected
      @expected = expected.to_s.gsub(/\?$/, '').intern

      apply_boolean_expectation if strict_matching?
    end # method initialize

    # Checks if the object responds to #expected?. Additionally, if a value
    # expectation is set, compares the value of #expected to the specified
    # value.
    #
    # @param [Object] actual The object to check.
    #
    # @return [Boolean] true If the object responds to #expected and matches
    #    the value expectation (if any); otherwise false.
    def matches? actual
      super

      responds_to_predicate? && matches_predicate_value?
    end # method matches?

    # Sets a value expectation. The matcher will compare the value from
    # #property? with the specified value.
    #
    # @param [Object] value The value to compare.
    #
    # @return [HaveReaderMatcher] self
    def with_value value
      if strict_matching? && !(value === true || value === false)
        raise ArgumentError.new 'predicate must return true or false'
      end # if

      @value = value
      @value_set = true
      self
    end # method with
    alias_method :with, :with_value

    # (see BaseMatcher#failure_message)
    def failure_message
      message = "expected #{@actual.inspect} to respond to :#{@expected}?"
      message << " and return #{value_to_string}" if @value_set

      if !@matches_predicate
        message << ", but did not respond to :#{@expected}?"
      elsif !@matches_predicate_value
        message << ", but returned #{@actual.send(:"#{@expected}?").inspect}"
      end # if-elsif

      message
    end # method failure_message

    # (see BaseMatcher#failure_message_when_negated)
    def failure_message_when_negated
      message = "expected #{@actual.inspect} not to respond to :#{@expected}?"
      message << " and return #{value_to_string}" if @value_set
      message
    end # method failure_message

    private

    def apply_boolean_expectation
      matcher = BeBooleanMatcher.new
      aliased = RSpec::Matchers::AliasedMatcher.new matcher, ->(str) { 'true or false' }

      @value     = aliased
      @value_set = true
    end # method apply_boolean_expectation

    def strict_matching?
      RSpec.configure { |config| config.sleeping_king_studios.matchers }.strict_predicate_matching
    end # method strict_matching?
  end # class
end # module
