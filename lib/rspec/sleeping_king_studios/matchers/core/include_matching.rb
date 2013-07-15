# lib/rspec/sleeping_king_studios/matchers/core/include_matching.rb

require 'rspec/sleeping_king_studios/matchers/core/require'

RSpec::Matchers.define :include_matching do |&block|
  match do |actual|
    @actual = actual
    @block  = block

    puts "#include_matching, actual = #{@actual}, block = #{@block.inspect}"
    
    next false unless @enumerable = @actual.respond_to?(:each)

    next false unless @block
    
    @actual.reduce(false) do |memo, item| memo || item =~ pattern; end
  end # match
  
  def failure_message_for_should
    return "expected #{@actual.inspect} to be enumerable" unless @enumerable

    return "must provide a block" unless @block
    
    "expected #{@actual} to include an item matching #{@pattern.inspect}"
  end # method failure_message_for_should
  
  def failure_message_for_should_not
    "expected #{@actual} not to include an item matching #{@pattern.inspect}"
  end # method failure_message_for_should_not
end # matcher
