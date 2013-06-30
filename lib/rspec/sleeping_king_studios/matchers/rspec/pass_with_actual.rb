# lib/rspec/sleeping_king_studios/matchers/rspec/pass_with_actual.rb

RSpec::Matchers.define :pass_with_actual do |actual|
  match do |matcher|
    @matcher = matcher
    @actual  = actual
    
    next false unless @matches = @matcher.matches?(@actual)
    
    text = @matcher.failure_message_for_should_not
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
      message_text = @message.is_a?(Regexp) ? @message.inspect : @message.to_s

      "expected message#{@message.is_a?(Regexp) ? " matching" : ""}:\n#{
        message_text.lines.map { |line| "#{" " * 2}#{line}" }.join
      }\nreceived message:\n#{
        @matcher.failure_message_for_should_not.lines.map { |line| "#{" " * 2}#{line}" }.join
      }"
    else
      failure_message = @matcher.failure_message_for_should
      failure_message = failure_message.lines.map { |line| "#{" " * 4}#{line}" }.join("\n")
      "expected #{@matcher} to match #{@actual}\n  message:\n#{failure_message}"
    end # if-else
  end # method failure_message_for_should
  
  failure_message_for_should_not do
    "failure: testing negative condition with positive matcher\n~>  use the :fail_with_actual matcher instead"
  end # method failure_message_for_should_not

  def message
    @message
  end # reader message

  # The text of the tested matcher's :failure_message_for_should_not, when the
  # tested matcher incorrectly matches the actual object.
  def with_message message
    @message = message
    self
  end # method with_message
end # matcher pass
