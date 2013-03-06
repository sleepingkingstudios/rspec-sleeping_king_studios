# lib/rspec/sleeping_king_studios/matchers/rspec/pass_with_actual.rb

RSpec::Matchers.define :pass_with_actual do |actual|
  match do |matcher|
    @matcher = matcher
    @actual  = actual
    
    next false unless @matches = @matcher.matches?(@actual)
    
    text = @matcher.failure_message_for_should_not
    if @message.is_a? Regexp
      !!(text =~ @message)
    elsif @message.is_a? String
      text == @message
    else
      true
    end # if-elsif-else
  end # match
  
  failure_message_for_should do
    next "expected #{@matcher} to match #{@actual}" unless @matches
    
    "expected #{@matcher} to match #{@actual} with message:" +
      "\nexpected: #{@message.is_a?(Regexp) ? @message.inspect : "\"#{@message}\""}" +
      "\nreceived: \"#{@matcher.failure_message_for_should_not}\""
  end # method failure_message_for_should
  
  failure_message_for_should_not do
    next "expected #{@matcher} not to match #{@actual}" if @matches
    
    "expected #{@matcher} not to match #{@actual} with message:" +
      "\nexpected: #{@message.is_a?(Regexp) ? @message.inspect : "\"#{@message}\""}" +
      "\nreceived: \"#{@matcher.failure_message_for_should_not}\""
  end # method failure_message_for_should_not
  
  def with_message message
    @message = message
    self
  end # method with_message
end # matcher pass
