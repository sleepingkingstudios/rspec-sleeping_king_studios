# lib/rspec/sleeping_king_studios/matchers/core/have_property.rb

require 'rspec/sleeping_king_studios/matchers/base_matcher'
require 'rspec/sleeping_king_studios/matchers/core'
require 'rspec/sleeping_king_studios/matchers/shared/match_property'

module RSpec::SleepingKingStudios::Matchers::Core
  # Matcher for testing whether an object has a specific property, e.g.
  # responds to :property and :property= and :property= updates the value of
  # :property.
  # 
  # @since 1.0.0
  class HavePropertyMatcher < RSpec::SleepingKingStudios::Matchers::BaseMatcher
    include RSpec::SleepingKingStudios::Matchers::Shared::MatchProperty

    # @param [String, Symbol] expected the property to check for on the actual
    #   object
    def initialize expected
      @expected = expected.intern
    end # method initialize

    def does_not_match? actual
      super

      matches_property?(:none?)
    end # method does_not_match?

    # Checks if the object responds to :expected and :expected=. Additionally,
    # if a value expectation is set, assigns the value via :expected= and
    # compares the subsequent value of :expected to the specified value.
    # 
    # @param [Object] actual the object to check
    # 
    # @return [Boolean] true if the object responds to :expected and
    #   :expected= and matches the value expectation (if any); otherwise false
    def matches? actual
      super

      matches_property?(:all?)
    end # method matches?

    # Sets a value expectation. The matcher will set the object's value to the
    # specified value using :property=, then compare the value from :property
    # with the specified value.
    # 
    # @param [Object] value the value to set and then compare
    # 
    # @return [HavePropertyMatcher] self
    def with value
      @value = value
      @value_set = true
      self
    end # method with
    alias_method :with_value, :with

    # @see BaseMatcher#failure_message
    def failure_message
      methods = []
      methods << ":#{@expected}"  unless @matches_reader
      methods << ":#{@expected}=" unless @matches_writer

      message = "expected #{@actual.inspect} to respond to :#{@expected} and :#{@expected}="
      message << " and return #{value_to_string}" if @value_set

      errors = []
      errors << "did not respond to #{methods.join " or "}" unless methods.empty?
      errors << "returned #{@actual.send(@expected).inspect}" unless @matches_reader_value || !@value_set

      message << ", but #{errors.join(" and ")}"
      message
    end # failure_message

    # @see BaseMatcher#failure_message_when_negated
    def failure_message_when_negated
      methods = []
      methods << ":#{@expected}"  if @matches_reader
      methods << ":#{@expected}=" if @matches_writer

      message = "expected #{@actual.inspect} not to respond to :#{@expected} or :#{@expected}="
      message << " and return #{value_to_string}" if @value_set

      errors = []
      errors << "responded to #{methods.join " and "}" unless methods.empty?
      errors << "returned #{@actual.send(@expected).inspect}" if @matches_reader_value

      message << ", but #{errors.join(" and ")}"
      message
    end # failure_message_when_negated

    private

    def matches_property? filter
      [ responds_to_reader?,
        responds_to_writer?,
        matches_reader_value?
      ].send(filter) { |bool| bool }
    end # method matches_property?
  end # class
end # module

module RSpec::SleepingKingStudios::Matchers
  # @see RSpec::SleepingKingStudios::Matchers::Core::HavePropertyMatcher#matches?
  def have_property expected
    RSpec::SleepingKingStudios::Matchers::Core::HavePropertyMatcher.new expected
  end # method have_property
end # module
