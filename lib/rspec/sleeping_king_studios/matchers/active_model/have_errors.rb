# lib/rspec/sleeping_king_studios/matchers/active_model/have_errors.rb

require 'rspec/sleeping_king_studios/matchers/base_matcher'
require 'rspec/sleeping_king_studios/matchers/active_model'
require 'rspec/sleeping_king_studios/matchers/active_model/have_errors/error_expectation'

module RSpec::SleepingKingStudios::Matchers::ActiveModel
  # Matcher for testing ActiveModel object validations.
  # 
  # @since 1.0.0
  class HaveErrorsMatcher < RSpec::SleepingKingStudios::Matchers::BaseMatcher
    include RSpec::SleepingKingStudios::Matchers::ActiveModel::HaveErrors

    def initialize
      super

      # The error and message expectations set up through #on and
      # #with_message.
      @error_expectations = []
    end # constructor

    # Checks if the object can be validated, whether the object is valid, and
    # checks the errors on the object against the expected errors and messages
    # from #on and #with_message, if any.
    # 
    # @param [Object] actual the object to test against the matcher
    # 
    # @return [Boolean] true if the object responds to :valid? and is valid
    #   or object.errors does not match the specified errors and messages (if
    #   any); otherwise false
    # 
    # @see #matches?
    def does_not_match? actual
      super

      return false unless @validates = actual.respond_to?(:valid?)

      !matches?(actual)
    end # method does_not_match?

    # Checks if the object can be validated, whether the object is valid, and
    # checks the errors on the object against the expected errors and messages
    # from #on and #with_message, if any.
    # 
    # @param [Object] actual the object to test against the matcher
    # 
    # @return [Boolean] true if the object responds to :valid?, is not valid,
    #   and object.errors matches the specified errors and messages (if any);
    #   otherwise false
    # @see RSpec::SleepingKingStudios::Matchers::BaseMatcher#matches?
    def matches? actual
      super

      return false unless @validates = actual.respond_to?(:valid?)

      !@actual.valid? && attributes_have_errors?
    end # method matches?

    # Adds an error expectation. If the actual object does not have an error on
    # the specified attribute, #matches? will return false.
    # 
    # @param [String, Symbol] attribute
    # 
    # @return [HaveErrorsMatcher] self
    # 
    # @example Setting an error expectation
    #   expect(actual).to have_errors.on(:foo)
    def on attribute
      @error_expectations << ErrorExpectation.new(attribute)
      
      self
    end # method on

    # Adds a message expectation for the most recently added error attribute.
    # If the actual object does not have an error on the that attribute with
    # the specified message, #matches? will return false.
    # 
    # @param [String, Regexp] message the expected error message. If a string,
    #   matcher will check for an exact match; if a regular expression, matcher
    #   will check if the message matches the regexp
    # 
    # @raise [ArgumentError] if no error attribute has been added
    # 
    # @return [HaveErrorsMatcher] self
    # 
    # @example Setting an error and a message expectation
    #   expect(actual).to have_errors.on(:foo).with("can't be blank")
    # 
    # @see #on
    def with_message message
      raise ArgumentError.new "no attribute specified for error message" if
        @error_expectations.empty?
        
      @error_expectations.last.messages << MessageExpectation.new(message)
      
      self
    end # method with_message

    # Adds a set of message expectations for the most recently added error
    # attribute.
    # 
    # @param [Array<String, Regexp>] messages
    # 
    # @see #with_message
    def with_messages *messages
      messages.each do |message| self.with_message(message); end
      
      self
    end # method with_message
    alias_method :with, :with_messages

    # @see BaseMatcher#failure_message
    def failure_message
      # Failure cases:
      # * object is not a model ("to respond to valid")
      # * expected one or more errors, but received none ("to have errors")
      # * expected one or more messages on :attribute, but received none or a
      #   subset ("to have errors on")

      if !@validates
        "expected #{@actual.inspect} to respond to :valid?"
      elsif expected_errors.empty?
        "expected #{@actual.inspect} to have errors"
      else
        "expected #{@actual.inspect} to have errors#{expected_errors_message}#{received_errors_message}"
      end # if-elsif-else
    end # method failure_message

    # @see BaseMatcher#failure_message_when_negated
    def failure_message_when_negated
      # Failure cases:
      # * object is not a model ("to respond to valid")
      # * expected one or more errors, received one or more ("not to have
      #   errors")
      # * expected one or more messages on attribute, received one or more
      #   ("not to have errors on")
      # * expected specific messages on attribute, received all ("not to have
      #   errors on")
      
      if !@validates
        "expected #{@actual.inspect} to respond to :valid?"
      elsif expected_errors.empty?
        return "expected #{@actual.inspect} not to have errors#{received_errors_message}"
      else
        return "expected #{@actual.inspect} not to have errors#{expected_errors_message}#{received_errors_message}"
      end # if-else
    end # method failure_message_when_negated

    private
    
    def attributes_have_errors?
      # Iterate through the received errors and match them against the expected
      # errors and messages.
      @actual.errors.messages.each do |attribute, messages|
        # Find the matching error expectation, if any.
        error_expectation = @error_expectations.detect do |error_expectation|
          error_expectation.attribute == attribute
        end # detect

        if error_expectation
          error_expectation.received = true

          # If the error includes message expectations, iterate through the
          # received messages.
          unless error_expectation.messages.empty?
            messages.each do |message|
              # Find the matching message expectation, if any.
              message_expectation = error_expectation.messages.detect do |message_expectation|
                if Regexp === message_expectation.message
                  message =~ message_expectation.message
                else
                  message == message_expectation.message
                end # if-else
              end # detect

              if message_expectation
                message_expectation.received = true
              else
                error_expectation.messages << MessageExpectation.new(message, false, true)
              end # if-else
            end # each  
          end # unless
        else
          error_expectation = ErrorExpectation.new attribute, false, true
          messages.each do |message|
            error_expectation.messages << MessageExpectation.new(message, false, true)
          end # each

          @error_expectations << error_expectation
        end # if-else
      end # each

      missing_errors.empty? && missing_messages.empty?
    end # method attributes_have_errors

    def expected_errors
      @error_expectations.select do |error_expectation|
        error_expectation.expected
      end # select
    end # method expected_errors
    
    def missing_errors
      @error_expectations.select do |error_expectation|
        error_expectation.expected && !error_expectation.received
      end # select
    end # method missing_errors

    def missing_messages
      @error_expectations.select do |error_expectation|
        !error_expectation.messages.missing.empty?
      end # select
    end # method missing_messages

    def unexpected_errors
      @error_expectations.select do |error_expectation|
        !error_expectation.expected && error_expectation.received
      end # select
    end # method unexpected_errors

    def expected_errors_message
      "\n  expected errors:" + expected_errors.map do |error_expectation|
        "\n    #{error_expectation.attribute}: " + (error_expectation.messages.empty? ?
          "(any)" :
          error_expectation.messages.expected.map(&:message).map(&:inspect).join(", "))
      end.join # map
    end # method expected_errors_message

    def received_errors_message
      return "" unless @validates
      "\n  received errors:" + @actual.errors.messages.map do |attr, ary|
        "\n    #{attr}: " + ary.map(&:inspect).join(", ")
      end.join # map
    end # method received_errors_message
  end # class

  module RSpec::SleepingKingStudios::Matchers
    # @see RSpec::SleepingKingStudios::Matchers::ActiveModel::HaveErrorsMatcher#matches?
    def have_errors
      RSpec::SleepingKingStudios::Matchers::ActiveModel::HaveErrorsMatcher.new
    end # method have_errors
  end # module
end # module
