# lib/rspec/sleeping_king_studios/matchers/built_in/respond_to.rb

module RSpec::Matchers::BuiltIn
  class RespondTo
    def find_failing_method_names(actual, filter_method)
      @actual = actual
      @failing_method_reasons = {}
      @failing_method_names   = @names.__send__(filter_method) do |name|
        @actual.respond_to?(name) &&
          matches_arity?(actual, name) &&
          matches_keywords?(actual, name) &&
          matches_block?(actual, name)
      end # send
    end # method find_failing_method_names
    
    def matches_arity?(actual, name)
      return true unless @expected_arity
      
      parameters = actual.method(name).parameters
      required   = parameters.count { |type, | :req  == type }
      optional   = parameters.count { |type, | :opt  == type }
      variadic   = parameters.count { |type, | :rest == type }

      min, max = @expected_arity.is_a?(Range) ?
        [@expected_arity.begin, @expected_arity.end] :
        [@expected_arity,       @expected_arity]

      if min < required
        (failing_method_reasons[name] ||= [])[:not_enough_args] = true
        false
      elsif 0 == variadic && max > required + optional
        (failing_method_reasons[name] ||= [])[:too_many_args]   = true
        false
      end # if

      true
    end # method matches_arity?

    def matches_keywords?(actual, name)
      return true unless @expected_keywords

      true
    end # method matches_keywords?
    
    def matches_block?(actual, name)
      return true unless @expected_block
      
      parameters = actual.method(name).parameters
      0 < parameters.count { |type, | :block == type }
    end # method matches_block?

    def failure_message_for_should
      @find_failing_method_names.map do |method|
        if !@actual.respond_to?(method)
          "expected #{@actual.inspect} to respond to #{method.inspect}"
        else

        end # if-else
      end # method



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
