# lib/rspec/sleeping_king_studios/matchers/built_in/be_kind_of.rb

require 'rspec/sleeping_king_studios/matchers/built_in/require'

module RSpec::SleepingKingStudios::Matchers::BuiltIn
  class IncludeMatcher < RSpec::Matchers::BuiltIn::Include
    # @param [Array<Hash, Proc, Object>] expected the items expected to be
    #   matched by the actual object
    # 
    # @yield if a block is provided, the block is converted to a proc and
    #   appended to the item expectations
    # @yieldparam [Object] item an item from the actual object; yield(item)
    #   should return true if and only if the item matches the desired
    #    predicate
    def initialize *expected, &block
      expected << block if block_given?
      super *expected
    end # constructor

    # Checks if the object includes the specified objects. Proc expectations
    # are evaluated by passing each item to proc#call.
    # 
    # @param [Object] actual the object to check
    # 
    # @return [Boolean] true if for each item expectation, the object contains
    #   an item matching that expectation; otherwise false
    def matches? actual
      super
    end # method matches?

    # @private
    def name
      "include"
    end # method name

    # @private
    def to_word item
      case
      when is_matcher_with_description?(item)
        item.description
      when Proc === item
        "matching block"
      else
        item.inspect
      end # case
    end # method to_word

    # @see BaseMatcher#failure_message_for_should
    def failure_message_for_should
      return "expected #{@actual.inspect} to respond to :include?" if false === @includes

      super
    end # method failure_message_for_should

    # @see BaseMatcher#failure_message_for_should_not
    def failure_message_for_should_not
      super
    end # method

    private

    def perform_match predicate, hash_predicate, actuals, expecteds
      expecteds.__send__(predicate) do |expected|
        if comparing_proc? actuals, expected
          !!actuals.detect { |actual| expected.call(actual) }
        elsif comparing_hash_values?(actuals, expected)
          expected.__send__(hash_predicate) { |k,v|
            actuals.has_key?(k) && actuals[k] == v
          }
        elsif comparing_hash_keys?(actuals, expected)
          actuals.has_key?(expected)
        elsif comparing_with_matcher?(actual, expected)
          actual.any? { |value| expected.matches?(value) }
        else
          @includes = actuals.respond_to?(:include?)
          @includes && actuals.include?(expected)
        end # if-elsif-end
      end # send
    end # method perform_match

    def comparing_proc? actual, expected
      expected.is_a?(Proc)
    end # method comparing_proc?
  end # class
end # module

module RSpec::SleepingKingStudios::Matchers
  # @see RSpec::SleepingKingStudios::Matchers::BuiltIn::IncludeMatcher#matches?
  def include *expected, &block
    RSpec::SleepingKingStudios::Matchers::BuiltIn::IncludeMatcher.new *expected, &block
  end # method include
end # module
