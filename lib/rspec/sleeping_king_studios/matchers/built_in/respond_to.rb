# lib/rspec/sleeping_king_studios/matchers/built_in/respond_to.rb

require 'rspec/sleeping_king_studios/matchers/base_matcher'
require 'rspec/sleeping_king_studios/matchers/built_in/require'
require 'rspec/sleeping_king_studios/matchers/shared/match_parameters'

module RSpec::SleepingKingStudios::Matchers::BuiltIn
  class RespondToMatcher < RSpec::Matchers::BuiltIn::RespondTo
    include RSpec::SleepingKingStudios::Matchers::Shared::MatchParameters

    # Checks if the object responds to the specified message. If so, checks the
    # parameters against the expected parameters, if any.
    # 
    # @param [Object] actual the object to check
    # 
    # @return [Boolean] true if the object responds to the message and accepts
    #   the specified parameters; otherwise false
    def matches? actual
      super
    end # method matches?

    # @overload with count
    #   Adds a parameter count expectation.
    # 
    #   @param [Integer, Range, nil] count (optional) The number of expected
    #     parameters.
    # 
    #   @return [RespondToMatcher] self
    # @overload with *keywords
    #   Adds one or more keyword expectations (Ruby 2.0 only).
    # 
    #   @param [Array<String, Symbol>] keywords List of keyword arguments
    #     accepted by the method.
    # 
    #   @return [RespondToMatcher] self
    # @overload with count, *keywords
    #   Adds a parameter count expectation and one or more keyword
    #   expectations (Ruby 2.0 only).
    # 
    #   @param [Integer, Range, nil] count (optional) The number of expected
    #     parameters.
    #   @param [Array<String, Symbol>] keywords List of keyword arguments
    #     accepted by the method.
    # 
    #   @return [RespondToMatcher] self
    def with *keywords
      @expected_arity    = keywords.shift if Integer === keywords.first || Range === keywords.first
      @expected_keywords = keywords
      self
    end # method with

    # Adds a block expectation. The actual object will only match a block
    # expectation if it expects a parameter of the form &block.
    #
    # @deprecated Use #with_a_block instead.
    #
    # @raise [RSpec::Core::DeprecationError]
    # 
    # @return [RespondToMatcher] self
    def a_block
      RSpec.deprecate 'RSpec::SleepingKingStudios::Matchers::BuiltIn::RespondToMatcher#a_block',
        :replacement => 'RSpec::SleepingKingStudios::Matchers::BuiltIn::RespondToMatcher#with_a_block'
      self.with_a_block
    end # method a_block

    # Adds a block expectation. The actual object will only match a block
    # expectation if it expects a parameter of the form &block.
    # 
    # @return [RespondToMatcher] self
    def with_a_block
      @expected_block = true
      self
    end # method with_a_block

    # Convenience method for more fluent specs. Does nothing and returns self.
    # 
    # @return [RespondToMatcher] self
    def arguments
      self
    end # method arguments

    # Convenience method for more fluent specs. Does nothing and returns self.
    #
    # @deprecated Conflicts with RSpec 3 chained matchers.
    #
    # @raise [RSpec::Core::DeprecationError]
    # 
    # @return [RespondToMatcher] self
    def and
      RSpec.deprecate 'RSpec::SleepingKingStudios::Matchers::BuiltIn::RespondToMatcher#and', {}
      self
    end # method arguments

    # @see BaseMatcher#failure_message_for_should
    def failure_message_for_should
      messages = []
      @failing_method_names ||= []
      @failing_method_names.map do |method|
        message = "expected #{@actual.inspect} to respond to #{method.inspect}"
        if @actual.respond_to?(method)
          message << " with arguments:\n#{format_errors_for_method method}"
        end # if-else
        messages << message
      end # method
      messages.join "\n"
    end # method failure_message_for_should

    # @see BaseMatcher#failure_message_for_should_not
    def failure_message_for_should_not
      @failing_method_names ||= []
      methods, messages = @names - @failing_method_names, []

      @names.map do |method|
        message   = "expected #{@actual.inspect} not to respond to #{method.inspect}"
        unless (formatted = format_expected_arguments).empty?
          message << " with #{formatted}"
        end # unless
        messages << message
      end # method
      messages.join "\n"
    end # method failure_message_for_should_not

    private

    def find_failing_method_names actual, filter_method
      @actual = actual
      @failing_method_reasons = {}
      @failing_method_names   = @names.__send__(filter_method) do |name|
        @actual.respond_to?(name) &&
          matches_arity?(actual, name) &&
          matches_keywords?(actual, name) &&
          matches_block?(actual, name)
      end # send
    end # method find_failing_method_names

    def matches_arity? actual, name
      return true unless @expected_arity

      if result = check_method_arity(actual.method(name), @expected_arity)
        (@failing_method_reasons[name] ||= {}).update result
        return false
      end # if

      true
    end # method matches_arity?

    def matches_keywords? actual, name
      return true unless @expected_keywords ||
        (@expected_arity && RUBY_VERSION >= "2.1.0")

      if result = check_method_keywords(actual.method(name), @expected_keywords)
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
        messages << "#{@expected_arity.inspect} argument#{1 == @expected_arity ? "" : "s"}"
      end # if

      if !(@expected_keywords.nil? || @expected_keywords.empty?)
        messages << "keywords #{@expected_keywords.map(&:inspect).join(", ")}"
      end # if

      if @expected_block
        messages << "a block"
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

    def format_errors_for_method method
      reasons, messages = @failing_method_reasons[method], []
      
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

      if reasons.fetch(:expected_block, false)
        messages << "  unexpected block"
      end # if

      messages.join "\n"
    end # method format_errors_for_method  
  end # class
end # module

module RSpec::SleepingKingStudios::Matchers
  # @see RSpec::SleepingKingStudios::Matchers::BuiltIn::RespondToMatcher#matches?
  def respond_to expected
    RSpec::SleepingKingStudios::Matchers::BuiltIn::RespondToMatcher.new expected
  end # method respond_to
end # module
