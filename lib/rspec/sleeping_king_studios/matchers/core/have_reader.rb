# spec/rspec/sleeping_king_studios/matchers/core/have_reader.rb

RSpec::Matchers.define :have_reader do |property|
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
      return "expected #{@actual} to respond to #{@property.inspect}"
    end # unless
    
    "unexpected value for #{@actual}\##{@property}\n" +
        "  expected: #{@value.inspect}\n" +
        "       got: #{@actual.send(@property).inspect}"
  end # method failure_message_for_should
  
  def failure_message_for_should_not
    message = "expected #{@actual} not to respond to #{@property.inspect}"
    message << " with value #{@value.inspect}" if @value_set
    message
  end # method failure_message_for_should
end # matcher have_accessor
