# lib/rspec/sleeping_king_studios/matchers/core/have_mutator.rb

RSpec::Matchers.define :have_mutator do |property|
  match do actual
    @actual   = actual
    @property = property.to_s.gsub(/=$/,'').intern
    
    next false unless @actual.respond_to? :"#{@property}="
    
    if @value_set
      @actual.send :"#{@property}=", @value
      next false unless @value == @actual.send(@property)
    end # if
    
    true
  end # match
  
  def with value
    @value = value
    @value_set = true
    self
  end # with
  
  def failure_message_for_should
    unless @actual.respond_to?(@property)
      return "expected #{@actual} to have mutator #{@property}="
    end # unless

    "expected #{@actual}.#{@property} = #{@value.inspect} to set #{@actual}.#{@property}"
  end # method failure_message_for_should

  def failure_message_for_should_not
    if @value_set and @actual.respond_to? @property
      return "expected #{@actual}.#{@property} = #{@value.inspect} not to" +
        " set #{@actual}.#{@property}"
    end # if
    
    return "expected #{@actual} not to have mutator #{@property}="
  end # method failure_message_for_should
end # matcher have_mutator
