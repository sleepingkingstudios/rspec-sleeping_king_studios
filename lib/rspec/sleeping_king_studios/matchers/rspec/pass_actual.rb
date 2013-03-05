# lib/rspec/sleeping_king_studios/matchers/rspec/pass_actual.rb

RSpec::Matchers.define :pass_actual do |actual|
  match do |matcher|
    @matcher = matcher
    @actual  = actual
    
    next false unless @matcher.matches?(@actual)
    
    text = @matcher.failure_message_for_should
    if @message.is_a? Regexp
      !!(text =~ @message)
    elsif @message.is_a? String
      text == @message
    else
      true
    end # if-elsif-else
  end # match
  
  failure_message_for_should do
    "expected matcher to match #{@actual}" + message_string
  end # method failure_message_for_should
  
  failure_message_for_should_not do
    "expected matcher not to match #{@actual}" + message_string
  end # method failure_message_for_should_not
  
  def message_string
    return "" if @message.nil?
    
    " with message #{@message.is_a?(Regexp) ? @message.inspect : @message}"
  end # method message_string
  
  def with_message message
    @message = message
    self
  end # method with_message
end # matcher pass
