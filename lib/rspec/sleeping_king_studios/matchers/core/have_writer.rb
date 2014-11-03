# lib/rspec/sleeping_king_studios/matchers/core/have_mutator.rb

require 'rspec/sleeping_king_studios/matchers/base_matcher'
require 'rspec/sleeping_king_studios/matchers/core'
require 'rspec/sleeping_king_studios/matchers/shared/match_property'

module RSpec::SleepingKingStudios::Matchers::Core
  # Matcher for testing whether an object has a specific property writer, e.g.
  # responds to :property= and updates the state.
  #
  # @since 1.0.0
  class HaveWriterMatcher < RSpec::SleepingKingStudios::Matchers::BaseMatcher
    include RSpec::SleepingKingStudios::Matchers::Shared::MatchProperty

    # Generates a description of the matcher expectation.
    #
    # @return [String] The matcher description.
    def description
      "have writer :#{@expected}"
    end # method description

    # @param [String, Symbol] expected the property to check for on the actual
    #   object
    def initialize expected
      @expected = expected.to_s.gsub(/=$/,'').intern
    end # method initialize

    # Checks if the object responds to :expected=. Additionally, if a value
    # expectation is set, assigns the value via :expected= and compares the
    # subsequent value to the specified value using :expected or the block
    # provided to #with.
    #
    # @param [Object] actual the object to check
    #
    # @return [Boolean] true if the object responds to :expected= and matches
    #    the value expectation (if any); otherwise false
    def matches? actual
      super

      responds_to_writer?
    end # method matches?

    # @see BaseMatcher#failure_message
    def failure_message
      message = "expected #{@actual.inspect} to respond to :#{@expected}="

      if !@matches_writer
        message << ", but did not respond to :#{@expected}="
      end # if

      message
    end # method failure_message

    # @see BaseMatcher#failure_message_when_negated
    def failure_message_when_negated
      "expected #{@actual} not to respond to :#{@expected}="
    end # method failure_message
  end # class
end # module

module RSpec::SleepingKingStudios::Matchers
  # @see RSpec::SleepingKingStudios::Matchers::Core::HaveWriterMatcher#matches?
  def have_writer expected
    RSpec::SleepingKingStudios::Matchers::Core::HaveWriterMatcher.new expected
  end # method have_writer
end # module
