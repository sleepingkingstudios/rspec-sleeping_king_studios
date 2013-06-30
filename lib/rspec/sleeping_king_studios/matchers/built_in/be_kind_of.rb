# lib/rspec/sleeping_king_studios/matchers/built_in/be_kind_of.rb

module RSpec::Matchers::BuiltIn
  class BeAKindOf < BaseMatcher
    def match(expected, actual)
      @actual = actual
      
      self.match_type? expected
    end # method match
    
    def match_type?(expected)
      case
      when expected.nil?
        @actual.nil?
      when expected.is_a?(Enumerable)
        expected.reduce(false) { |memo, obj| memo || match_type?(obj) }
      else
        @actual.kind_of? expected
      end # case
    end # method match_type
    
    def failure_message_for_should
      "expected #{@actual.inspect} to be #{type_string}"
    end # method failure_message_for_should
    
    def failure_message_for_should_not
      "expected #{@actual.inspect} not to be #{type_string}"
    end # method failure_message_for_should_not
    
  private
    def type_string
      case
      when expected.nil?
        "nil"
      when expected.is_a?(Enumerable) && 1 < expected.count
        if 2 == expected.count
          "a #{expected.first.inspect} or #{expected.last.inspect}"
        else
          "a #{expected[0..-2].map(&:inspect).join(", ")}, or #{expected.last.inspect}"
        end # if-else
      else
        "a #{expected}"
      end # case
    end # method type_string
  end # class
end # module
