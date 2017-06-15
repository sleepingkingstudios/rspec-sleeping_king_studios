# lib/rspec/sleeping_king_studios/matchers/core/have_writer_matcher.rb

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

    # @param [String, Symbol] expected the property to check for on the actual
    #   object
    def initialize expected, allow_private: false
      @expected      = expected.to_s.gsub(/=$/,'').intern
      @allow_private = allow_private
    end # method initialize

    # @return [Boolean] True if the matcher matches private reader methods,
    #   otherwise false.
    def allow_private?
      !!@allow_private
    end # method allow_private?

    # Generates a description of the matcher expectation.
    #
    # @return [String] The matcher description.
    def description
      "have writer :#{@expected}"
    end # method description

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

      responds_to_writer?(:allow_private => allow_private?)
    end # method matches?

    # @see BaseMatcher#failure_message
    def failure_message
      "expected #{@actual.inspect} to respond to :#{@expected}="\
      ", but did not respond to :#{@expected}="
    end # method failure_message

    # @see BaseMatcher#failure_message_when_negated
    def failure_message_when_negated
      "expected #{@actual.inspect} not to respond to :#{@expected}="\
      ", but responded to :#{@expected}="
    end # method failure_message
  end # class
end # module
