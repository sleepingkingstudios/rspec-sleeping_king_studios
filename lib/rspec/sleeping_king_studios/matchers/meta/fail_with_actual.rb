# lib/rspec/sleeping_king_studios/matchers/rspec/fail_with_actual.rb

RSpec::Matchers.define :fail_with_actual do |actual|
  match do |matcher|
    @matcher = matcher
    @actual  = actual
    
    next false if @matches = @matcher.matches?(@actual)
    
    text = @matcher.failure_message_for_should
    if @message.is_a? Regexp
      !!(text =~ @message)
    elsif @message
      text == @message.to_s
    else
      true
    end # if-elsif-else
  end # match
  
  failure_message_for_should do
    if @matches = @matcher.matches?(@actual)
      "expected #{@matcher} not to match #{@actual}"
    else
      message_text = @message.is_a?(Regexp) ? @message.inspect : @message.to_s

      "expected message#{@message.is_a?(Regexp) ? " matching" : ""}:\n#{
        message_text.lines.map { |line| "#{" " * 2}#{line}" }.join
      }\nreceived message:\n#{
        @matcher.failure_message_for_should.lines.map { |line| "#{" " * 2}#{line}" }.join
      }"
    end # if-else
  end # method failure_message_for_should
  
  failure_message_for_should_not do
    "failure: testing positive condition with negative matcher\n~>  use the :pass_with_actual matcher instead"
  end # method failure_message_for_should_not

  def message
    @message
  end # reader message

  # The text of the tested matcher's :failure_message_for_should, when the
  # tested matcher correctly fails to match the actual object.
  def with_message message
    @message = message
    self
  end # method with_message
end # matcher pass
