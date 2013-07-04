# lib/rspec/sleeping_king_studios/matchers/built_in/respond_to.rb

require 'rspec/sleeping_king_studios/matchers/shared/match_parameters'

module RSpec::Matchers::BuiltIn
  class RespondTo
    include RSpec::SleepingKingStudios::Matchers::Shared::MatchParameters

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
      return true unless @expected_keywords

      if result = check_method_keywords(actual.method(name), @expected_keywords)
        (@failing_method_reasons[name] ||= {}).update result
        return false
      end # if

      true
    end # method matches_keywords?
    
    def matches_block? actual, name
      return true unless @expected_block

      if result = check_method_block(@actual.method(name))
        (@failing_method_reasons[name] ||= {}).update result
        return false
      end # if

      true
    end # method matches_block?

    def failure_message_for_should
      messages = []
      @failing_method_names.map do |method|
        message = "expected #{@actual.inspect} to respond to #{method.inspect}"
        if @actual.respond_to?(method)
          message << " with arguments:\n#{format_errors_for_method method}"
        end # if-else
        messages << message
      end # method
      messages.join "\n"
    end # method failure_message_for_should_not
    
    def failure_message_for_should_not
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
    
    def with n = nil, *keywords
      @expected_arity    = n unless n.nil?
      @expected_keywords = keywords
      self
    end # method with
    
    def and
      self
    end # method and
    
    def a_block
      @expected_block = true
      self
    end # method a_block

  private
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

      if ary = reasons.fetch(:unexpected_keywords, false)
        messages << "  unexpected keywords #{ary.map(&:inspect).join(", ")}"
      end # if

      if reasons.fetch(:expected_block, false)
        messages << "  unexpected block"
      end # if

      messages.join "\n"
    end # method format_errors_for_method      
  end # class RespondTo
end # module
