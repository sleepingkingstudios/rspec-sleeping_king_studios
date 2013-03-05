# spec/rspec/sleeping_king_studios/matchers/core/construct.rb

RSpec::Matchers.define :construct do
  def matches?(actual)
    @actual = actual
    return false unless actual.respond_to? :new
    return false unless self.matches_arity?(actual)
    true
  end # method matches?
  
  def failure_message_for_should
    "expected #{@actual.inspect} to initialize#{with_arity}"
  end # method failure_message_for_should

  def failure_message_for_should_not
    "expected #{@actual.inspect} not to initialize#{with_arity}"
  end # method failure_message_for_should_not
  
  def matches_arity?(actual)
    return true unless @expected_arity
    
    parameters = actual.allocate.method(:initialize).parameters
    required   = parameters.count { |type, | :req == type }
    optional   = parameters.count { |type, | :opt == type }
    variadic   = parameters.count { |type, | :rest == type }
    
    if @expected_arity.is_a? Range
      @expected_arity.min >= required && (0 < variadic || @expected_arity.max <= required + optional)
    else
      @expected_arity >= required && (0 < variadic || @expected_arity <= required + optional)
    end # if-else
  end # method matches_arity?
  
  def with(n)
    @expected_arity = n
    self
  end # method with
  
  def arguments
    self
  end # method arguments
  
  def with_arity
    @expected_arity.nil?? "" :
      " with #{@expected_arity} argument#{@expected_arity == 1 ? '' : 's'}"
  end # method with_arity
end # matcher
