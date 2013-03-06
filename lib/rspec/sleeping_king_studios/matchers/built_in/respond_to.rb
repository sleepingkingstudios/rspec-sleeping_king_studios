# lib/rspec/sleeping_king_studios/matchers/built_in/respond_to.rb

module RSpec::Matchers::BuiltIn
  class RespondTo
    def find_failing_method_names(actual, filter_method)
      @actual = actual
      @failing_method_names = @names.__send__(filter_method) do |name|
        @actual.respond_to?(name) &&
          matches_arity?(actual, name) &&
          matches_block?(actual, name)
      end # send
    end # method find_failing_method_names
    
    def matches_arity?(actual, name)
      return true unless @expected_arity
      
      parameters = actual.method(name).parameters
      required   = parameters.count { |type, | :req  == type }
      optional   = parameters.count { |type, | :opt  == type }
      variadic   = parameters.count { |type, | :rest == type }
      
      if @expected_arity.is_a? Range
        @expected_arity.min >= required && (0 < variadic || @expected_arity.max <= required + optional)
      else
        @expected_arity >= required && (0 < variadic || @expected_arity <= required + optional)
      end # if-else
    end # method matches_arity?
    
    def matches_block?(actual, name)
      return true unless @expected_block
      
      parameters = actual.method(name).parameters
      0 < parameters.count { |type, | :block == type }
    end # method matches_block?

    def failure_message_for_should
      str = "expected #{@actual.inspect} to respond to" + @failing_method_names.map { |name|
        s = " #{name.inspect}"
        if @actual.respond_to?(name)
          s << " with #{@expected_arity} argument#{@expected_arity == 1 ? '' : 's'}" if @expected_arity && !matches_arity?(@actual, name)
          s << " with a block" if @expected_block && !matches_block?(@actual, name)
        end # if
        next s
      }.compact.join(', ')
    end # method failure_message_for_should_not
    
    def failure_message_for_should_not
      str = "expected #{@actual.inspect} not to respond to" + @names.map { |name|
        if @actual.respond_to?(name)
          s = " #{name.inspect}"
          s << " with #{@expected_arity} argument#{@expected_arity == 1 ? '' : 's'}" if @expected_arity && matches_arity?(@actual, name)
          s << " with a block" if @expected_block && matches_block?(@actual, name)
          next s
        end # if
      }.compact.join(', ')
    end # method failure_message_for_should_not
    
    def with(n = nil)
      @expected_arity = n unless n.nil?
      self
    end # method with
    
    def and
      self
    end # method and
    
    def a_block
      @expected_block = true
      self
    end # method a_block
  end # class RespondTo
end # module
