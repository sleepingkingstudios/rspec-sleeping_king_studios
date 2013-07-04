# spec/rspec/sleeping_king_studios/matchers/core/construct.rb

require 'rspec/sleeping_king_studios/matchers/shared/match_parameters'

RSpec::Matchers.define :construct do
  include RSpec::SleepingKingStudios::Matchers::Shared::MatchParameters

  def matches? actual
    @actual = actual
    @failing_method_reasons = {}
    @actual.respond_to?(:new) &&
      matches_arity?(actual) &&
      matches_keywords?(actual)
  end # method matches?

  def matches_arity? actual
    return true unless @expected_arity
    
    if result = check_method_arity(actual.allocate.method(:initialize), @expected_arity)
      @failing_method_reasons.update result
      return false
    end # if

    true
  end # method matches_arity?

  def matches_keywords? actual
    return true unless @expected_keywords

    if result = check_method_keywords(actual.allocate.method(:initialize), @expected_keywords)
      @failing_method_reasons.update result
      return false
    end # if

    true
  end # method matches_keywords?
  
  def with n = nil, *keywords
    @expected_arity    = n unless n.nil?
    @expected_keywords = keywords
    self
  end # method with
  
  def arguments
    self
  end # method arguments
  
  def failure_message_for_should
    message = "expected #{@actual.inspect} to construct"
    message << " with arguments:\n#{format_errors}" if @actual.respond_to?(:new)
    message
  end # method failure_message_for_should

  def failure_message_for_should_not
    message = "expected #{@actual.inspect} not to construct"
    unless (formatted = format_expected_arguments).empty?
      message << " with #{formatted}" 
    end # unless
    message
  end # method failure_message_for_should_not
  
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

    puts "#format_errors, reasons = #{reasons}"
    
    if hsh = reasons.fetch(:not_enough_args, false)
      messages << "  expected at least #{hsh[:count]} arguments, but received #{hsh[:arity]}"
    elsif hsh = reasons.fetch(:too_many_args, false)
      messages << "  expected at most #{hsh[:count]} arguments, but received #{hsh[:arity]}"
    end # if-elsif

    if ary = reasons.fetch(:unexpected_keywords, false)
      messages << "  unexpected keywords #{ary.map(&:inspect).join(", ")}"
    end # if

    messages.join "\n"
  end # method format_errors
end # matcher
