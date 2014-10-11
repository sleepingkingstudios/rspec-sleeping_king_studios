# lib/rspec/sleeping_king_studios/matchers/core/have_mutator.rb

require 'rspec/sleeping_king_studios/matchers/base_matcher'
require 'rspec/sleeping_king_studios/matchers/core'

module RSpec::SleepingKingStudios::Matchers::Core
  # Matcher for testing whether an object has a specific property writer, e.g.
  # responds to :property= and updates the state.
  # 
  # @since 1.0.0
  class HaveWriterMatcher < RSpec::SleepingKingStudios::Matchers::BaseMatcher
    # @param [String, Symbol] expected the property to check for on the actual
    #   object
    def initialize expected
      @expected = expected.to_s.gsub(/=$/,'').intern
    end # method initialize

    # Checks if the object responds to :expected=. Additionally, if a value
    # expectation is set, assigns the value via :expected= and compares the
    # subsequent value to the specified value using :expected or the block
    # provided to #with.
    # 
    # @param [Object] actual the object to check
    # 
    # @return [Boolean] true if the object responds to :expected= and matches
    #    the value expectation (if any); otherwise false
    def matches? actual
      super

      return false unless @match_writer = @actual.respond_to?(:"#{@expected}=")

      if @value_set
        @actual.send :"#{@expected}=", @value

        if @value_block.respond_to?(:call)
          return false unless @value == (@actual_value = @actual.instance_eval(&@value_block))
        elsif @actual.respond_to?(@expected)
          return false unless @value == (@actual_value = @actual.send(@expected))
        else
          return false
        end # if-elsif
      end # if
      
      true
    end # method matches?

    # Sets a value expectation. The matcher will set the object's value to the
    # specified value using :property=, then compare the value from :property
    # with the specified value. If a block is provided, the actual object
    # evaluates the block and the value is compared to the specified value
    # instead of using :property.
    # 
    # @param [Object] value the value to compare
    # 
    # @yield if a block is provided, the block is used to check the value after
    #   setting :property= instead of using :property.
    # 
    # @example Using :property to check the value
    #   expect(instance).to have_writer(:foo).with(42)
    # 
    # @example Using a block to check the valuye
    #   expect(instance).to have_writer(:bar).with(42) { self.getBar() }
    # 
    # @return [HaveWriterMatcher] self
    def with value, &block
      @value       = value
      @value_set   = true
      @value_block = block
      self
    end # method with

    # @see BaseMatcher#failure_message
    def failure_message
      return "expected #{@actual.inspect} to respond to #{@expected.inspect}=" unless @match_writer

      unless @actual.respond_to?(@expected) || @value_block.respond_to?(:call)
        return "unable to test #{@expected.inspect}= because #{@actual} does " +
          "not respond to #{@expected.inspect}; try adding a test block to #with"
      end # unless

      return "unexpected value for #{@actual.inspect}#foo=\n" +
        "  expected: #{@value.inspect}\n" +
        "       got: #{@actual_value.inspect}"
    end # method failure_message

    # @see BaseMatcher#failure_message_when_negated
    def failure_message_when_negated
      message = "expected #{@actual} not to respond to #{@expected.inspect}="
      message << " with value #{@value.inspect}" if @value_set && @match_writer
      message
    end # method failure_message
  end # class
end # module

module RSpec::SleepingKingStudios::Matchers
  # @see RSpec::SleepingKingStudios::Matchers::Core::HaveWriterMatcher#matches?
  def have_writer expected
    RSpec::SleepingKingStudios::Matchers::Core::HaveWriterMatcher.new expected
  end # method have_writer
end # module
