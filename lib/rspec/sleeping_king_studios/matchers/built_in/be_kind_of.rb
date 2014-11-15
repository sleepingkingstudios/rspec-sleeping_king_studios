# lib/rspec/sleeping_king_studios/matchers/built_in/be_kind_of.rb

require 'rspec/sleeping_king_studios/matchers/built_in'
require 'sleeping_king_studios/tools/enumerable_tools'

module RSpec::SleepingKingStudios::Matchers::BuiltIn
  # Extensions to the built-in RSpec #be_kind_of matcher.
  class BeAKindOfMatcher < RSpec::Matchers::BuiltIn::BeAKindOf
    include SleepingKingStudios::Tools::EnumerableTools

    # (see BaseMatcher#description)
    def description
      message = "be #{type_string}"
    end # method description

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
    end # method match

    # (see BaseMatcher#failure_message)
    def failure_message
      "expected #{@actual.inspect} to be #{type_string}"
    end # method failure_message

    # (see BaseMatcher#failure_message_when_negated)
    def failure_message_when_negated
      "expected #{@actual.inspect} not to be #{type_string}"
    end # method failure_message_when_negated

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
        "a #{humanize_list @expected.map { |value| value.nil? ? 'nil' : value }, :last_separator => ' or '}"
      else
        "a #{expected}"
      end # case
    end # method type_string
  end # class
end # module

module RSpec::SleepingKingStudios::Matchers
  # @see RSpec::SleepingKingStudios::Matchers::BuiltIn::BeAKindOfMatcher#match
  def be_kind_of expected
    RSpec::SleepingKingStudios::Matchers::BuiltIn::BeAKindOfMatcher.new expected
  end # method be_kind_of

  alias_method :be_a, :be_kind_of
end # module
