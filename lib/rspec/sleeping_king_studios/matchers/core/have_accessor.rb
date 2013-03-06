# spec/rspec/sleeping_king_studios/matchers/core/have_accessor.rb

RSpec::Matchers.define :have_accessor do |property|
  match do actual
    @actual   = actual
    @property = property
    
    next false unless @actual.respond_to? @property
    
    next false if @value_set and @value != @actual.send(@property)
    
    true
  end # match
  
  def with value
    @value = value
    @value_set = true
    self
  end # method with
  
  def failure_message_for_should
    unless @actual.respond_to?(@property)
      return "expected #{@actual} to have accessor #{@property}"
    end # unless
    
    "expected #{@actual}.#{@property} to be #{@value.inspect}"
  end # method failure_message_for_should
  
  def failure_message_for_should_not
    if @value_set and @actual.respond_to? @property
      return "expected #{@actual}.#{@property} not to be #{@value.inspect}"
    end # if
    
    return "expected #{@actual} not to have accessor #{@property}"
  end # method failure_message_for_should
end # matcher have_accessor
