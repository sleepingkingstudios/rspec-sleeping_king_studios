# lib/rspec/sleeping_king_studios/matchers/built_in/be_kind_of_matcher.rb

require 'rspec/sleeping_king_studios/matchers/built_in'
require 'sleeping_king_studios/tools/array_tools'

module RSpec::SleepingKingStudios::Matchers::BuiltIn
  # Extensions to the built-in RSpec #be_kind_of matcher.
  class BeAKindOfMatcher < RSpec::Matchers::BuiltIn::BeAKindOf
    # (see BaseMatcher#description)
    def description
      message = "be #{type_string}"
    end

    # Checks if the object matches one of the specified types. Allows an
    # expected value of nil as a shortcut for expecting an instance of
    # NilClass.
    #
    # @param [Module, nil, Array<Module, nil>] expected The type or types to
    #   check the object against.
    # @param [Object] actual The object to check.
    #
    # @return [Boolean] True if the object matches one of the specified types,
    #   otherwise false.
    def match expected, actual
      match_type? expected
    end

    # (see BaseMatcher#failure_message)
    def failure_message
      "expected #{@actual.inspect} to be #{type_string}"
    end

    # (see BaseMatcher#failure_message_when_negated)
    def failure_message_when_negated
      "expected #{@actual.inspect} not to be #{type_string}"
    end

    private

    def match_type? expected
      case
      when expected.nil?
        @actual.nil?
      when expected.is_a?(Enumerable)
        expected.reduce(false) { |memo, obj| memo || match_type?(obj) }
      else
        @actual.kind_of? expected
      end
    end

    def type_string
      case
      when @expected.nil?
        @expected.inspect
      when @expected.is_a?(Enumerable) && 1 < @expected.count
        tools = SleepingKingStudios::Tools::Toolbelt.instance
        items = @expected.map { |value| value.nil? ? 'nil' : value }

        "a #{tools.array_tools.humanize_list items, :last_separator => ' or '}"
      else
        "a #{expected}"
      end
    end
  end
end
