# lib/rspec/sleeping_king_studios/matchers/core/have_property.rb

RSpec::Matchers.define :have_property do |property|
  match do actual
    @actual   = actual
    @property = property

    @match_reader = @actual.respond_to? @property
    @match_writer = @actual.respond_to? :"#{@property}="
    
    next false unless @match_reader && @match_writer

    if @value_set
      @actual.send :"#{@property}=", @value
      return false unless @actual.send(@property) == @value
    end # if
    
    true
  end # match
  
  def with value
    @value = value
    @value_set = true
    self
  end # method with

  failure_message_for_should do
    methods = []
    methods << ":#{@property}"  unless @match_reader
    methods << ":#{@property}=" unless @match_writer
    "expected #{@actual.inspect} to respond to #{methods.join " and "}"
  end # failure_message_for_should

  failure_message_for_should_not do
    message = "expected #{@actual.inspect} not to respond to :#{@property} or :#{@property}="
    message << " with value #{@value.inspect}" if @value_set
    message
  end # failure_message_for_should_not
end # define
