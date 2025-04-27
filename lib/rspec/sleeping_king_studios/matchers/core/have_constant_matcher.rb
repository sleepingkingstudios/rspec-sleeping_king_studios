# lib/rspec/sleeping_king_studios/matchers/core/have_constant_matcher.rb

require 'rspec/sleeping_king_studios/matchers/base_matcher'
require 'rspec/sleeping_king_studios/matchers/core'
require 'sleeping_king_studios/tools/array_tools'

module RSpec::SleepingKingStudios::Matchers::Core
  # Matcher for testing whether an object has a specific constant. Includes
  # functionality for testing the value of the constant and whether the
  # constant is immutable.
  #
  # @since 2.2.0
  class HaveConstantMatcher < RSpec::SleepingKingStudios::Matchers::BaseMatcher
    include RSpec::Matchers::Composable

    # @param [String, Symbol] expected The name of the constant to check for on
    #   the actual object.
    def initialize expected
      @expected = expected.intern
    end # method initialize

    # (see BaseMatcher#description)
    def description
      message =
        "have #{@immutable ? 'immutable ' : ''}constant #{@expected.inspect}"

      message << ' with value ' << value_to_string if @value_set

      message
    end # method description

    # (see BaseMatcher#does_not_match?)
    def does_not_match? actual
      super

      @errors = {}

      !has_constant?
    end # method does_not_match?

    # (see BaseMatcher#failure_message)
    def failure_message
      message = super

      messages = []

      if @errors[:does_not_define_constants]
        message <<
          ", but #{@actual.inspect} does not respond to ::const_defined?"

        return message
      end # if

      if @errors[:constant_is_not_defined]
        message <<
          ", but #{@actual.inspect} does not define constant #{@expected.inspect}"

        return message
      end # if

      if hsh = @errors[:value_does_not_match]
        messages <<
          "constant #{@expected.inspect} has value #{hsh[:received].inspect}"
      end # if

      if hsh = @errors[:value_is_mutable]
        messages <<
          "the value of #{@expected.inspect} was mutable"
      end # if

      unless messages.empty?
        tools = ::SleepingKingStudios::Tools::ArrayTools

        message << ', but ' << tools.humanize_list(messages)
      end # unless

      message
    end # method failure_message

    # (see BaseMatcher#failure_message_when_negated)
    def failure_message_when_negated
      message = super

      message <<
        ", but #{@actual.inspect} defines constant #{@expected.inspect} with "\
        "value #{actual.const_get(@expected).inspect}"

      message
    end # method failure_message

    # Sets a mutability expectation. The matcher will determine whether the
    # value of the constant is mutable. Values of `nil`, `false`, `true` are
    # always immutable, as are `Numeric` and `Symbol` primitives. `Array`
    # values must be frozen and all array items must be immutable. `Hash`
    # values must be frozen and all hash keys and values must be immutable.
    #
    # @return [HaveConstantMatcher] self
    def immutable
      @immutable = true

      self
    end # method immutable
    alias_method :frozen, :immutable

    # @return [Boolean] True if a mutability expectation is set, otherwise
    #   false.
    def immutable?
      !!@immutable
    end # method immutable
    alias_method :frozen?, :immutable?

    # Checks if the object has a constant :expected. Additionally, if a
    # value expectation is set, compares the value of #expected to the
    # specified value and checks the mutability of the constant.
    #
    # @param [Object] actual The object to check.
    #
    # @return [Boolean] true If the object has a constant :expected and matches
    #    the value and mutability expectations (if any); otherwise false.
    def matches? actual
      super

      @errors = {}

      return false unless has_constant?

      matches_constant? :all?
    end # method matches?

    # Sets a value expectation. The matcher will compare the value of the
    # constant with the specified value.
    #
    # @param [Object] value The value to compare.
    #
    # @return [HaveConstantMatcher] self
    def with value
      @value     = value
      @value_set = true
      self
    end # method with
    alias_method :with_value, :with

    private

    def has_constant?
      unless actual.respond_to?(:const_defined?)
        @errors[:does_not_define_constants] = true

        return false
      end # unless

      unless actual.const_defined?(@expected)
        @errors[:constant_is_not_defined] = true

        return false
      end # unless

      true
    end # method has_constant?

    def immutable_value?
      return true unless @immutable

      actual_value = actual.const_get(@expected)

      if mutable?(actual_value)
        @errors[:value_is_mutable] = true

        return false
      end # if

      true
    end # method immutable_value

    def matches_constant? filter
      [ matches_constant_value?,
        immutable_value?
      ].send(filter) { |bool| bool }
    end # method matches_constant?

    def matches_constant_value?
      return true unless @value_set

      actual_value = actual.const_get(@expected)
      match        = (@value.respond_to?(:matches?) && @value.respond_to?(:description)) ?
        @value.matches?(actual_value) :
        @value == actual_value

      unless match
        @errors[:value_does_not_match] = {
          :expected => @value,
          :received => actual_value
        } # end hash

        return false
      end # unless

      true
    end # method matches_constant_value?

    def mutable? value
      case value
      when nil, false, true, Numeric, Symbol
        false
      when Array
        return true unless value.frozen?

        value.reduce(false) { |memo, item| memo || mutable?(item) }
      when Hash
        return true unless value.frozen?

        (value.keys + value.values).reduce(false) { |memo, item| memo || mutable?(item) }
      else
        !value.frozen?
      end # case
    end # method mutable?

    # Formats the expected value as a human-readable string. If the value looks
    # like an RSpec matcher (it responds to :matches? and :description), calls
    # value#description; otherwise calls value#inspect.
    #
    # @return [String] the value as a human-readable string.
    def value_to_string
      return @value.description if @value.respond_to?(:matches?) && @value.respond_to?(:description)

      @value.inspect
    end # method value_to_string
  end # class
end # module
