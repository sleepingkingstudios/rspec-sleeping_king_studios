# spec/rspec/sleeping_king_studios/matchers/core/construct.rb

require 'rspec/sleeping_king_studios/matchers/base_matcher'
require 'rspec/sleeping_king_studios/matchers/core/require'

require 'rspec/sleeping_king_studios/matchers/shared/match_parameters'

module RSpec::SleepingKingStudios::Matchers::Core
  # Matcher for checking whether an object can be constructed via #new and
  # #initialize, and the parameters accepted by #initialize.
  # 
  # @since 1.0.0
  class ConstructMatcher < RSpec::SleepingKingStudios::Matchers::BaseMatcher
    include RSpec::SleepingKingStudios::Matchers::Shared::MatchParameters

    # Checks if the object responds to :new. If so, allocates an instance and
    # checks the parameters expected by #initialize against the expected
    # parameters, if any.
    # 
    # @param [Object] actual the object to check
    # 
    # @return [Boolean] true if the object responds to :new and accepts the
    #   specified parameters for #initialize; otherwise false
    def matches? actual
      @actual = actual
      @failing_method_reasons = {}
      @actual.respond_to?(:new) &&
        matches_arity?(actual) &&
        matches_keywords?(actual)
    end # method matches?

    # @overload with(count)
    #   Adds a parameter count expectation and removes any keyword expectations
    #   (Ruby 2.0+ only).
    # 
    #   @param [Integer, Range] count the number of expected parameters
    # 
    #   @return [ConstructMatcher] self
    # 
    # @overload with(count, *keywords)
    #   Adds a parameter count expectation and one or more keyword expectations
    #   (Ruby 2.0 only).
    # 
    #   @param [Integer, Range] count the number of expected parameters
    #   @param [Array<String, Symbol>] keywords list of keyword arguments
    #     accepted by the method
    # 
    #   @return [ConstructMatcher] self
    # 
    # @overload with(*keywords)
    #   Removes a parameter count expectation (if any) and adds one or more
    #   keyword expectations (Ruby 2.0 only).
    # 
    #   @param [Array<String, Symbol>] keywords list of keyword arguments
    #     accepted by the method
    # 
    #   @return [ConstructMatcher] self
    def with *keywords
      @expected_arity    = keywords.shift if Integer === keywords.first || Range === keywords.first
      @expected_keywords = keywords
      self
    end # method with

    # Convenience method for more fluent specs. Does nothing and returns self.
    # 
    # @return [ConstructMatcher] self
    # 
    # @since 2.0.0
    def argument
      self
    end # method argument
    alias_method :arguments, :argument

    # @see BaseMatcher#failure_message
    def failure_message
      message = "expected #{@actual.inspect} to construct"
      message << " with arguments:\n#{format_errors}" if @actual.respond_to?(:new)
      message
    end # method failure_message

    # @see BaseMatcher#failure_message_when_negated
    def failure_message_when_negated
      message = "expected #{@actual.inspect} not to construct"
      unless (formatted = format_expected_arguments).empty?
        message << " with #{formatted}" 
      end # unless
      message
    end # method failure_message_when_negated

    private

    def matches_arity? actual
      return true unless @expected_arity
      
      if result = check_method_arity(actual.allocate.method(:initialize), @expected_arity)
        @failing_method_reasons.update result
        return false
      end # if

      true
    end # method matches_arity?

    def matches_keywords? actual
      return true unless @expected_keywords ||
        (@expected_arity && RUBY_VERSION >= "2.1.0")

      if result = check_method_keywords(actual.allocate.method(:initialize), @expected_keywords)
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

      if !(@expected_keywords.nil? || @expected_keywords.empty?)
        messages << "keywords #{@expected_keywords.map(&:inspect).join(", ")}"
      end # if

      case messages.count
      when 0..1
        messages.join(", ")
      when 2
        "#{messages[0]} and #{messages[1]}"
      else
        "#{messages[1..-1].join(", ")}, and #{messages[0]}"
      end # case
    end # method format_expected_arguments

    def format_errors
      reasons, messages = @failing_method_reasons, []
      
      if hsh = reasons.fetch(:not_enough_args, false)
        messages << "  expected at least #{hsh[:count]} arguments, but received #{hsh[:arity]}"
      elsif hsh = reasons.fetch(:too_many_args, false)
        messages << "  expected at most #{hsh[:count]} arguments, but received #{hsh[:arity]}"
      end # if-elsif

      if ary = reasons.fetch(:missing_keywords, false)
        messages << "  missing keywords #{ary.map(&:inspect).join(", ")}"
      end # if

      if ary = reasons.fetch(:unexpected_keywords, false)
        messages << "  unexpected keywords #{ary.map(&:inspect).join(", ")}"
      end # if

      messages.join "\n"
    end # method format_errors
  end # class
end # module

module RSpec::SleepingKingStudios::Matchers
  # @see RSpec::SleepingKingStudios::Matchers::Core::ConstructMatcher#matches?
  def construct
    RSpec::SleepingKingStudios::Matchers::Core::ConstructMatcher.new
  end # method construct
end # module
