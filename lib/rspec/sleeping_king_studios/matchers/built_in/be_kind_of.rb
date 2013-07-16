# lib/rspec/sleeping_king_studios/matchers/built_in/be_kind_of.rb

require 'rspec/sleeping_king_studios/matchers/built_in/require'

module RSpec::SleepingKingStudios::Matchers::BuiltIn
  class BeAKindOfMatcher < RSpec::Matchers::BuiltIn::BeAKindOf
    # Checks if the object matches one of the specified types. Allows an
    # expected value of nil as a shortcut for expecting an instance of
    # NilClass.
    # 
    # @param [Module, nil, Array<Module, nil>] expected the type or types to
    #   check the object against
    # @param [Object] actual the object to check
    # 
    # @return [Boolean] true if the object matches one of the specified types,
    #   otherwise false
    def match expected, actual
      match_type? expected
    end # method match

    # @see BaseMatcher#failure_message_for_should
    def failure_message_for_should
      "expected #{@actual.inspect} to be #{type_string}"
    end # method failure_message_for_should
    
    # @see BaseMatcher#failure_message_for_should_not
    def failure_message_for_should_not
      "expected #{@actual.inspect} not to be #{type_string}"
    end # method failure_message_for_should_not

    private
    
    def match_type? expected
      case
      when expected.nil?
        @actual.nil?
      when expected.is_a?(Enumerable)
        expected.reduce(false) { |memo, obj| memo || match_type?(obj) }
      else
        @actual.kind_of? expected
      end # case
    end # method match_type?

    def type_string
      case
      when @expected.nil?
        @expected.inspect
      when @expected.is_a?(Enumerable) && 1 < @expected.count
        if 2 == expected.count
          "a #{expected.first.inspect} or #{expected.last.inspect}"
        else
          "a #{expected[0..-2].map(&:inspect).join(", ")}, or #{expected.last.inspect}"
        end # if-else
      else
        "a #{expected}"
      end # case
    end # method type_string
  end # class

  module RSpec::SleepingKingStudios::Matchers
    # @see RSpec::SleepingKingStudios::Matchers::BuiltIn::BeAKindOfMatcher#match
    def be_kind_of expected
      RSpec::SleepingKingStudios::Matchers::BuiltIn::BeAKindOfMatcher.new expected
    end # method be_kind_of

    alias_method :be_a, :be_kind_of
  end # module
end # module
