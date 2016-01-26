# lib/rspec/sleeping_king_studios/matchers/core/construct_matcher.rb

require 'rspec/sleeping_king_studios/matchers/base_matcher'
require 'rspec/sleeping_king_studios/matchers/core'
require 'rspec/sleeping_king_studios/matchers/shared/match_parameters'
require 'sleeping_king_studios/tools/enumerable_tools'
require 'sleeping_king_studios/tools/string_tools'

module RSpec::SleepingKingStudios::Matchers::Core
  # Matcher for checking whether an object can be constructed via #new and
  # #initialize, and the parameters accepted by #initialize.
  #
  # @since 1.0.0
  class ConstructMatcher < RSpec::SleepingKingStudios::Matchers::BaseMatcher
    include RSpec::SleepingKingStudios::Matchers::Shared::MatchParameters
    include SleepingKingStudios::Tools::EnumerableTools
    include SleepingKingStudios::Tools::StringTools

    # (see BaseMatcher#description)
    def description
      expected_message = format_expected_arguments
      "construct#{expected_message.empty? ? '' : " with #{expected_message}"}"
    end # method description

    # Checks if the object responds to :new. If so, allocates an instance and
    # checks the parameters expected by #initialize against the expected
    # parameters, if any.
    #
    # @param [Object] actual The object to check.
    #
    # @return [Boolean] True if the object responds to :new and accepts the
    #   specified parameters for #initialize; otherwise false.
    def matches? actual
      @actual = actual
      @failing_method_reasons = {}
      @actual.respond_to?(:new) &&
        matches_arity?(actual) &&
        matches_keywords?(actual)
    end # method matches?

    # Adds a parameter count expectation and/or one or more keyword
    # expectations.
    #
    # @overload with(count)
    #   Adds a parameter count expectation and removes any keyword
    #   expectations.
    #
    #   @param [Integer, Range] count The number of expected parameters.
    #
    #   @return [ConstructMatcher] self
    #
    # @overload with(count, *keywords)
    #   Adds a parameter count expectation and one or more keyword
    #   expectations.
    #
    #   @param [Integer, Range] count The number of expected parameters.
    #   @param [Array<String, Symbol>] keywords List of keyword arguments
    #     accepted by the method.
    #
    #   @return [ConstructMatcher] self
    #
    # @overload with(*keywords)
    #   Removes a parameter count expectation (if any) and adds one or more
    #   keyword expectations.
    #
    #   @param [Array<String, Symbol>] keywords List of keyword arguments
    #     accepted by the method.
    #
    #   @return [ConstructMatcher] self
    def with *keywords
      @expected_arity    = keywords.shift if Integer === keywords.first || Range === keywords.first
      @expected_keywords = keywords
      self
    end # method with

    # Adds an unlimited parameter count expectation, e.g. that the method
    # supports splatted array arguments of the form *args.
    #
    # @return [RespondToMatcher] self
    def with_unlimited_arguments
      @expect_unlimited_arguments = true

      self
    end # method with_unlimited_arguments
    alias_method :and_unlimited_arguments, :with_unlimited_arguments

    # Adds one or more keyword expectations.
    #
    # @param [Array<String, Symbol>] keywords List of keyword arguments
    #   accepted by the method.
    #
    # @return [RespondToMatcher] self
    def with_keywords *keywords
      (@expected_keywords ||= []).concat(keywords)

      self
    end # method with_keywords
    alias_method :and_keywords, :with_keywords

    # Adds an arbitrary keyword expectation, e.g. that the method supports
    # any keywords with splatted hash arguments of the form **kwargs.
    def with_arbitrary_keywords
      @expect_arbitrary_keywords = true

      self
    end # method with_arbitrary_keywords
    alias_method :and_arbitrary_keywords, :with_arbitrary_keywords

    # Convenience method for more fluent specs. Does nothing and returns self.
    #
    # @return [ConstructMatcher] self
    #
    # @since 2.0.0
    def argument
      self
    end # method argument
    alias_method :arguments, :argument

    # (see BaseMatcher#failure_message)
    def failure_message
      message = "expected #{@actual.inspect} to be constructible"
      message << " with arguments:\n#{format_errors}" if @actual.respond_to?(:new)
      message
    end # method failure_message

    # (see BaseMatcher#failure_message_when_negated)
    def failure_message_when_negated
      message = "expected #{@actual.inspect} not to be constructible"
      unless (formatted = format_expected_arguments).empty?
        message << " with #{formatted}"
      end # unless
      message
    end # method failure_message_when_negated

    private

    def matches_arity? actual
      return true unless @expected_arity || @expect_unlimited_arguments

      if result = check_method_arity(actual.allocate.method(:initialize), @expected_arity, expect_unlimited_arguments: @expect_unlimited_arguments)
        @failing_method_reasons.update result
        return false
      end # if

      true
    end # method matches_arity?

    def matches_keywords? actual
      return true unless @expected_keywords ||
        @expect_arbitrary_keywords ||
        (@expected_arity && RUBY_VERSION >= "2.1.0")

      if result = check_method_keywords(actual.allocate.method(:initialize), @expected_keywords, expect_arbitrary_keywords: @expect_arbitrary_keywords)
        @failing_method_reasons.update result
        return false
      end # if

      true
    end # method matches_keywords?

    def format_expected_arguments
      messages = []

      if !@expected_arity.nil?
        messages << "#{@expected_arity.inspect} argument#{1 == @expected_arity ? "" : "s"}"
      end # if

      if @expect_unlimited_arguments
        messages << 'unlimited arguments'
      end # if

      if !(@expected_keywords.nil? || @expected_keywords.empty?)
        messages << "#{pluralize @expected_keywords.count, 'keyword', 'keywords'} #{humanize_list @expected_keywords.map(&:inspect)}"
      end # if

      if @expect_arbitrary_keywords
        messages << 'arbitrary keywords'
      end # if

      humanize_list messages
    end # method format_expected_arguments

    def format_errors
      reasons, messages = @failing_method_reasons, []

      if hsh = reasons.fetch(:not_enough_args, false)
        messages << "  expected at least #{hsh[:count]} arguments, but received #{hsh[:arity]}"
      elsif hsh = reasons.fetch(:too_many_args, false)
        messages << "  expected at most #{hsh[:count]} arguments, but received #{hsh[:arity]}"
      end # if-elsif

      if hsh = reasons.fetch(:expected_unlimited_arguments, false)
        messages << "  expected at most #{hsh[:count]} arguments, but received unlimited arguments"
      end # if

      if ary = reasons.fetch(:missing_keywords, false)
        messages << "  missing #{pluralize ary.count, 'keyword', 'keywords'} #{humanize_list ary.map(&:inspect)}"
      end # if

      if ary = reasons.fetch(:unexpected_keywords, false)
        messages << "  unexpected #{pluralize ary.count, 'keyword', 'keywords'} #{humanize_list ary.map(&:inspect)}"
      end # if

      if reasons.fetch(:expected_arbitrary_keywords, false)
        messages << "  expected arbitrary keywords"
      end # if

      messages.join "\n"
    end # method format_errors
  end # class
end # module