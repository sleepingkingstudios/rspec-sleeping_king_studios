# lib/rspec/sleeping_king_studios/matchers/core/have_mutator.rb

RSpec::Matchers.define :have_writer do |property|
  match do actual
    @actual   = actual
    @property = property.to_s.gsub(/=$/,'').intern
    
    next false unless @actual.respond_to?(:"#{@property}=")
    
    if @value_set
      @actual.send :"#{@property}=", @value

      if @value_block.respond_to?(:call)
        next false unless @value == (@actual_value = @actual.instance_eval(&@value_block))
      elsif @actual.respond_to?(@property)
        next false unless @value == (@actual_value = @actual.send(@property))
      else
        next false
      end # if-elsif
    end # if
    
    true
  end # match
  
  def with value, &block
    @value       = value
    @value_set   = true
    @value_block = block
    self
  end # method with
  
  def failure_message_for_should
    return "expected #{@actual.inspect} to respond to #{@property.inspect}=" unless @actual.respond_to?(:"#{@property}=")

    unless @actual.respond_to?(@property) || @value_block.respond_to?(:call)
      return "unable to test #{@property.inspect}= because #{actual} does " +
        "not respond to #{@property.inspect}; try adding a test block to #with"
    end # unless

    return "unexpected value for #{@actual.inspect}#foo=\n" +
      "  expected: #{@value.inspect}\n" +
      "       got: #{@actual_value.inspect}"
  end # method failure_message_for_should

  def failure_message_for_should_not
    message = "expected #{@actual} not to respond to #{@property.inspect}="
    message << " with value #{@value.inspect}" if @value_set && @actual.respond_to?(:"#{@property}=")
    message
  end # method failure_message_for_should
end # matcher have_mutator
