# lib/rspec/sleeping_king_studios/matchers/built_in/respond_to_matcher.rb

require 'rspec/sleeping_king_studios/matchers/base_matcher'
require 'rspec/sleeping_king_studios/matchers/built_in'
require 'rspec/sleeping_king_studios/matchers/shared/match_parameters'
require 'sleeping_king_studios/tools/enumerable_tools'
require 'sleeping_king_studios/tools/string_tools'

module RSpec::SleepingKingStudios::Matchers::BuiltIn
  # Extensions to the built-in RSpec #respond_to matcher.
  class RespondToMatcher < RSpec::Matchers::BuiltIn::RespondTo
    include RSpec::SleepingKingStudios::Matchers::Shared::MatchParameters
    include SleepingKingStudios::Tools::EnumerableTools
    include SleepingKingStudios::Tools::StringTools

    def initialize *expected
      @include_all = [true, false].include?(expected.last) ? expected.pop : false

      super(*expected)
    end # constructor

    # (see BaseMatcher#description)
    def description
      expected_message = format_expected_arguments
      "respond to #{pp_names}#{expected_message.empty? ? '' : " with #{expected_message}"}"
    end # method description

    # Adds a parameter count expectation and/or one or more keyword
    # expectations.
    #
    # @overload with count
    #   Adds a parameter count expectation.
    #
    #   @param [Integer, Range, nil] count (optional) The number of expected
    #     parameters.
    #
    #   @return [RespondToMatcher] self
    # @overload with *keywords
    #   Adds one or more keyword expectations.
    #
    #   @param [Array<String, Symbol>] keywords List of keyword arguments
    #     accepted by the method.
    #
    #   @return [RespondToMatcher] self
    # @overload with count, *keywords
    #   Adds a parameter count expectation and one or more keyword
    #   expectations.
    #
    #   @param [Integer, Range, nil] count (optional) The number of expected
    #     parameters.
    #   @param [Array<String, Symbol>] keywords List of keyword arguments
    #     accepted by the method.
    #
    #   @return [RespondToMatcher] self
    def with *keywords
      @expected_arity = keywords.shift if Integer === keywords.first || Range === keywords.first

      # TODO: Deprecate this behavior (for version 3.0?) - use the
      # #with_keywords or #and_keywords methods instead.
      (@expected_keywords ||= []).concat(keywords)

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
    alias_method :with_any_keywords,      :with_arbitrary_keywords
    alias_method :and_any_keywords,       :with_any_keywords

    # Adds a block expectation. The actual object will only match a block
    # expectation if it expects a parameter of the form &block.
    #
    # @return [RespondToMatcher] self
    def with_a_block
      @expected_block = true
      self
    end # method with_a_block
    alias_method :and_a_block, :with_a_block

    # (see BaseMatcher#failure_message)
    def failure_message
      @failing_method_names ||= []
      methods, messages = @failing_method_names, []

      methods.map do |method|
        message = "expected #{@actual.inspect} to respond to #{method.inspect}"
        if @actual.respond_to?(method, @include_all)
          # TODO: Replace this with ", but received arguments did not match "\
          # " method signature:"
          message << " with arguments:\n#{format_errors_for_method method}"
        end # if-else
        messages << message
      end # method

      messages.join "\n"
    end # method failure_message

    # (see BaseMatcher#failure_message_when_negated)
    def failure_message_when_negated
      @failing_method_names ||= []
      methods, messages = @failing_method_names, []

      methods.map do |method|
        message = "expected #{@actual.inspect} not to respond to #{method.inspect}"
        unless (formatted = format_expected_arguments).empty?
          message << " with #{formatted}"
        end # unless
        messages << message
      end # method

      messages.join "\n"
    end # method failure_message_when_negated

    private

    def find_failing_method_names actual, filter_method
      @actual = actual
      @failing_method_reasons = {}
      @failing_method_names   = @names.__send__(filter_method) do |name|
        match = true
        match = false unless @actual.respond_to?(name, @include_all)
        match = false unless matches_arity?(actual, name)
        match = false unless matches_keywords?(actual, name)
        match = false unless matches_block?(actual, name)
        match
      end # send
    end # method find_failing_method_names

    def matches_arity? actual, name
      return true unless @expected_arity || @expect_unlimited_arguments

      if result = check_method_arity(actual.method(name), @expected_arity, expect_unlimited_arguments: @expect_unlimited_arguments)
        (@failing_method_reasons[name] ||= {}).update result
        return false
      end # if

      true
    end # method matches_arity?

    def matches_keywords? actual, name
      return true unless @expected_keywords ||
        @expect_arbitrary_keywords ||
        (@expected_arity && RUBY_VERSION >= "2.1.0")

      if result = check_method_keywords(actual.method(name), @expected_keywords, expect_arbitrary_keywords: @expect_arbitrary_keywords)
        (@failing_method_reasons[name] ||= {}).update result
        return false
      end # if

      true
    rescue NameError => error
      if error.name == name
        # Actual responds to name, but doesn't actually have a method defined
        # there. Possibly using #method_missing or a test double. We obviously
        # can't test that, so bail.
        true
      else
        raise error
      end # if-else
    end # method matches_keywords?

    def matches_block? actual, name
      return true unless @expected_block

      if result = check_method_block(@actual.method(name))
        (@failing_method_reasons[name] ||= {}).update result
        return false
      end # if

      true
    end # method matches_block?

    def format_expected_arguments
      messages = []

      if !@expected_arity.nil?
        messages << "#{@expected_arity.inspect} #{pluralize @expected_arity, 'argument', 'arguments'}"
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

      if @expected_block
        messages << "a block"
      end # if

      humanize_list messages
    end # method format_expected_arguments

    def format_errors_for_method method
      reasons, messages = @failing_method_reasons[method], []

      # TODO: Replace this with "  expected :arity arguments, but method can "\
      # "receive :count arguments", with :count being one of the following:
      # - an integer (for methods that do not have optional or variadic params)
      # - between :min and :max (for methods with optional but not variadic
      #   params)
      # - at least :min (for methods with variadic params)
      if hsh = reasons.fetch(:not_enough_args, false)
        messages << "  expected at least #{hsh[:count]} arguments, but received #{hsh[:arity]}"
      end # if

      if hsh = reasons.fetch(:too_many_args, false)
        messages << "  expected at most #{hsh[:count]} arguments, but received #{hsh[:arity]}"
      end # if

      # TODO: Replace this with "  expected method to receive unlimited "\
      # "arguments, but method can receive at most :max arguments"
      if hsh = reasons.fetch(:expected_unlimited_arguments, false)
        messages << "  expected at most #{hsh[:count]} arguments, but received unlimited arguments"
      end # if

      # TODO: Replace this with "  expected method to receive arbitrary "\
      # "keywords, but the method can receive :keyword_list", with
      # :keyword_list being a comma-separated list. If the method cannot
      # receive keywords, replace last fragment with ", but the method cannot"\
      # " receive keywords"
      if reasons.fetch(:expected_arbitrary_keywords, false)
        messages << "  expected arbitrary keywords"
      end # if

      # TODO: Replace this with "  expected method to receive keywords "\
      # ":received_list, but the method requires keywords :required_list"
      if ary = reasons.fetch(:missing_keywords, false)
        messages << "  missing #{pluralize ary.count, 'keyword', 'keywords'} #{humanize_list ary.map(&:inspect)}"
      end # if

      # TODO: Replace this with "  expected method to receive keywords "\
      # ":received_list, but the method can receive :keyword_list"
      if ary = reasons.fetch(:unexpected_keywords, false)
        messages << "  unexpected #{pluralize ary.count, 'keyword', 'keywords'} #{humanize_list ary.map(&:inspect)}"
      end # if

      # TODO: Replace this with "  expected method to receive a block "\
      # "argument, but the method signature does not specify a block argument"
      if reasons.fetch(:expected_block, false)
        messages << "  unexpected block"
      end # if

      messages.join "\n"
    end # method format_errors_for_method
  end # class
end # module
