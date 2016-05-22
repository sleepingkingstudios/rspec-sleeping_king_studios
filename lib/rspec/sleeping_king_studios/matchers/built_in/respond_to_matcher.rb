# lib/rspec/sleeping_king_studios/matchers/built_in/respond_to_matcher.rb

require 'rspec/sleeping_king_studios/matchers/base_matcher'
require 'rspec/sleeping_king_studios/matchers/built_in'
require 'rspec/sleeping_king_studios/matchers/shared/match_parameters'

module RSpec::SleepingKingStudios::Matchers::BuiltIn
  # Extensions to the built-in RSpec #respond_to matcher.
  class RespondToMatcher < RSpec::Matchers::BuiltIn::RespondTo
    include RSpec::SleepingKingStudios::Matchers::Shared::MatchParameters

    def initialize *expected
      @include_all = [true, false].include?(expected.last) ? expected.pop : false

      super(*expected)
    end # constructor

    # (see BaseMatcher#description)
    def description
      message = "respond to #{pp_names}"

      if method_signature_expectation?
        message << ' ' << method_signature_expectation.description
      end # if

      message
    end # method description

    # (see BaseMatcher#failure_message)
    def failure_message
      method_names = @failing_method_names || []
      messages     = []

      method_names.map do |method_name|
        message = "expected #{@actual.inspect} to respond to #{method_name.inspect}"
        reasons = @failing_method_reasons[method_name] || {}

        if reasons.key?(:does_not_respond_to_method)
          message << ", but #{@actual.inspect} does not respond to #{method_name.inspect}"
        elsif reasons.key?(:is_not_a_method)
          message << ", but #{@actual.inspect} does not define a method at #{method_name.inspect}"
        else
          errors = @failing_method_reasons[method_name]

          # TODO: Replace this with ", but received arguments did not match "\
          # " method signature:"
          message << " with arguments:\n" << format_errors(errors)
        end # if-elsif-else

        messages << message
      end # method

      messages.join "\n"
    end # method failure_message

    # (see BaseMatcher#failure_message_when_negated)
    def failure_message_when_negated
      @failing_method_names ||= []
      methods, messages = @failing_method_names, []

      methods.map do |method|
        message = "expected #{@actual.inspect} not to respond to #{method.inspect}"

        if method_signature_expectation?
          message << ' ' << method_signature_expectation.description
        end # if

        messages << message
      end # method

      messages.join "\n"
    end # method failure_message_when_negated

    private

    def find_failing_method_names actual, filter_method
      @actual = actual
      @failing_method_reasons = {}
      @failing_method_names   = @names.__send__(filter_method) do |method_name|
        unless @actual.respond_to?(method_name, @include_all)
          @failing_method_reasons[method_name] = {
            :does_not_respond_to_method => true
          } # end hash

          next false
        end # unless

        method =
          begin
            actual.method(method_name)
          rescue NameError
            nil
          end # unless

        unless method.is_a?(Method)
          @failing_method_reasons[method_name] = {
            :is_not_a_method => true
          } # end hash

          next false
        end # unless

        next true unless method_signature_expectation?

        unless check_method_signature(method)
          @failing_method_reasons[method_name] =
            method_signature_expectation.errors

          next false
        end # unless

        true
      end # send
    end # method find_failing_method_names
  end # class
end # module
