# lib/rspec/sleeping_king_studios/matchers/core/be_boolean.rb

require 'rspec/sleeping_king_studios/matchers/base_matcher'
require 'rspec/sleeping_king_studios/matchers/core/require'

module RSpec::SleepingKingStudios::Matchers::Core
  # Matcher for testing whether an object is true or false.
  # 
  # @since 1.0.0
  class BeBooleanMatcher < RSpec::SleepingKingStudios::Matchers::BaseMatcher
    # Checks if the object is true or false.
    # 
    # @param [Object] actual the object to check
    # 
    # @return [Boolean] true if the object is true or false, otherwise false
    def matches? actual
      super

      true === actual || false === actual
    end # method matches?

    # @see BaseMatcher#failure_message_for_should
    def failure_message_for_should
      "expected #{@actual.inspect} to be true or false"
    end # method failure_message_for_should

    # @see BaseMatcher#failure_message_for_should_not
    def failure_message_for_should_not
      "expected #{@actual.inspect} not to be true or false"
    end # method failure_message_for_should_not
  end # class
end # module

module RSpec::SleepingKingStudios::Matchers
  # @see RSpec::SleepingKingStudios::Matchers::Core::BeBooleanMatcher#matches?
  def be_boolean
    RSpec::SleepingKingStudios::Matchers::Core::BeBooleanMatcher.new
  end # method be_boolean
end # module
