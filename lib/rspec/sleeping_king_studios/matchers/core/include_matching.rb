# lib/rspec/sleeping_king_studios/matchers/core/include_matching.rb

RSpec::Matchers.define :include_matching do |pattern|
  match do |actual|
    @actual  = actual
    @pattern = pattern
    
    next false unless @enumerable = @actual.respond_to?(:each)
    
    @actual.reduce(false) do |memo, item| memo || item =~ pattern; end
  end # match
  
  def failure_message_for_should
    return "expected #{@actual} to be enumerable" unless @enumerable
    
    "expected #{@actual} to include an item matching #{@pattern.inspect}"
  end # method failure_message_for_should
  
  def failure_message_for_should_not
    "expected #{@actual} not to include an item matching #{@pattern.inspect}"
  end # method failure_message_for_should_not
end # matcher
