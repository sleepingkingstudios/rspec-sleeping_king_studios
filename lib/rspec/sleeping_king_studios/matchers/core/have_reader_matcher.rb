# subl lib/rspec/sleeping_king_studios/matchers/core/have_reader_matcher.rb

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

    # @param [String, Symbol] expected The property to check for on the actual
    #   object.
    # @param [Boolean] allow_private If true, then the matcher will match a
    #   protected or private reader method. Defaults to false.
    def initialize expected, allow_private: false
      @expected      = expected.intern
      @allow_private = allow_private
    end # method initialize

    # @return [Boolean] True if the matcher matches private reader methods,
    #   otherwise false.
    def allow_private?
      !!@allow_private
    end # method allow_private?

    # (see BaseMatcher#description)
    def description
      value_message = value_to_string
      "have reader :#{@expected}#{@value_set ? " with value #{value_message}" : ''}"
    end # method description

    # (see BaseMatcher#does_not_match?)
    def does_not_match? actual
      super

      matches_reader?(:none?)
    end # method does_not_match?

    # Checks if the object responds to #expected. Additionally, if a value
    # expectation is set, compares the value of #expected to the specified
    # value.
    #
    # @param [Object] actual The object to check.
    #
    # @return [Boolean] true If the object responds to #expected and matches
    #    the value expectation (if any); otherwise false.
    def matches? actual
      super

      matches_reader?(:all?)
    end # method matches?

    # Sets a value expectation. The matcher will compare the value from
    # #property with the specified value.
    #
    # @param [Object] value The value to compare.
    #
    # @return [HaveReaderMatcher] self
    def with value
      @value = value
      @value_set = true
      self
    end # method with
    alias_method :with_value, :with

    # (see BaseMatcher#failure_message)
    def failure_message
      message = "expected #{@actual.inspect} to respond to :#{@expected}"
      message << " and return #{value_to_string}" if @value_set

      if !@matches_reader
        message << ", but did not respond to :#{@expected}"
      elsif !@matches_reader_value
        message << ", but returned #{@actual.send(@expected).inspect}"
      end # if

      message
    end # method failure_message

    # (see BaseMatcher#failure_message_when_negated)
    def failure_message_when_negated
      message = "expected #{@actual.inspect} not to respond to :#{@expected}"
      message << " and return #{value_to_string}" if @value_set

      errors = []
      errors << "responded to :#{@expected}" if @matches_reader
      errors << "returned #{@actual.send(@expected).inspect}" if @matches_reader_value

      message << ", but #{errors.join(" and ")}"
      message
    end # method failure_message

    private

    def matches_reader? filter
      [ responds_to_reader?(:allow_private => allow_private?),
        matches_reader_value?(:allow_private => allow_private?)
      ].send(filter) { |bool| bool }
    end # method matches_property?
  end # class
end # module
