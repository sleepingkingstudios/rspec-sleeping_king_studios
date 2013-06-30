# spec/rspec/sleeping_king_studios/matchers/active_model/have_errors.rb

require 'active_support'

RSpec::Matchers.define :have_errors do
  def matches? actual
    @actual = actual
    
    return false unless @validates = actual.respond_to?(:valid?)
    
    actual.invalid? && attributes_have_errors
  end # method matches?
  
  def on attribute
    expected_errors.update(attribute => []) unless
      expected_errors.has_key?(attribute)
    
    self
  end # method on
  
  def with_message message
    raise ArgumentError.new "no attribute specified for error message" if
      expected_errors.empty?
      
    key = expected_errors.keys.last
    expected_errors[key] << message
    
    self
  end # method with_message
  
  def with_messages *messages
    messages.each do |message| self.with_message(message); end
    
    self
  end # method with_message
  
  def expected_errors
    @expected_errors ||= Hash.new
  end # method expected_errors
  
  def unexpected_errors
    @unexpected_errors ||= Hash.new
  end # method unexpected_errors
  
  def attributes_have_errors
    expected_errors.each do |attribute, patterns|
      unexpected_errors[attribute] ||= []
      
      next unless @actual.errors.include?(attribute)
      
      messages = @actual.errors.messages[attribute]
      patterns.each do |pattern|
        messages.each do |message|
          if (pattern.is_a?(Regexp) && message =~ pattern) || message == pattern
            unexpected_errors[attribute] << pattern
            patterns.delete pattern and next
          end # if
        end # each
      end # each
      
      expected_errors.delete attribute if patterns.empty?
    end # each
    
    expected_errors.empty?
  end # method attributes_have_errors

  failure_message_for_should do
    if @validates
      "expected #{@actual} to have errors" + expected_errors.map { |attribute, messages|
        " on #{attribute.inspect}" +
          (messages.empty? ? '' : ' with message ' + messages.map(&:inspect).compact.join(" and"))
      }.compact.join(" and")
    else
      "expected #{@actual} to respond to :valid?"
    end # if-else
  end # method failure_message_for_should

  failure_message_for_should_not do
    if expected_errors.empty?
      "expected #{@actual} not to have errors"
    else
      "expected #{@actual} not to have errors" + unexpected_errors.map { |attribute, messages|
        " on #{attribute.inspect}" +
          (messages.empty? ? '' : ' with message ' + messages.map(&:inspect).compact.join(" and"))
      }.compact.join(" and") + " but received messages #{@actual.errors.messages[attribute]}"
    end # if-else
  end # method failure_message_for_should_not
  
  def failure_message_for_should_not
    "expected #{@actual} not to have errors" + unexpected_errors.map { |attribute, messages|
      " on #{attribute.inspect}" +
        (messages.empty? ? '' : ' with message ' + messages.map(&:inspect).compact.join(" and"))
    }.compact.join(" and") + "\n#{" " * 2}errors: #{@actual.errors.messages}"
  end # method failure_message_for_should_not
  
  def failure_message_for_attribute(attribute)
    return nil unless expected_errors.has_key? attribute
    
    str = " on #{attribute.inspect}"
  end # method failure_message_for_attribute
  
  def failure_message_for_attributes
    expected_errors.keys.map { |attribute|
      failure_message_for_attribute(attribute)
    }.compact.join(" and")
  end # method failure_message_for_attributes
end # matcher have_errors
