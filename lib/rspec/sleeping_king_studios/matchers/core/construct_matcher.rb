# lib/rspec/sleeping_king_studios/matchers/core/construct_matcher.rb

require 'rspec/sleeping_king_studios/matchers/base_matcher'
require 'rspec/sleeping_king_studios/matchers/core'
require 'rspec/sleeping_king_studios/matchers/shared/match_parameters'
require 'sleeping_king_studios/tools/enumerable_tools'
require 'sleeping_king_studios/tools/string_tools'

module RSpec::SleepingKingStudios::Matchers::Core
  # Matcher for checking whether an object can be constructed via #new and
  # #initialize, and the parameters accepted by #initialize.
  #
  # @since 1.0.0
  class ConstructMatcher < RSpec::SleepingKingStudios::Matchers::BaseMatcher
    include RSpec::SleepingKingStudios::Matchers::Shared::MatchParameters
    include SleepingKingStudios::Tools::EnumerableTools
    include SleepingKingStudios::Tools::StringTools

    # (see BaseMatcher#description)
    def description
      message = 'construct'

      if method_signature_expectation?
        message << ' ' << method_signature_expectation.description
      end # if

      message
    end # method description

    # Checks if the object responds to :new. If so, allocates an instance and
    # checks the parameters expected by #initialize against the expected
    # parameters, if any.
    #
    # @param [Object] actual The object to check.
    #
    # @return [Boolean] True if the object responds to :new and accepts the
    #   specified parameters for #initialize; otherwise false.
    def matches? actual
      @actual = actual
      @failing_method_reasons = {}

      unless @actual.respond_to?(:new, @include_all)
        @failing_method_reasons = {
          :does_not_respond_to_new => true
        } # end hash

        return false
      end # unless

      instance =
        begin; actual.allocate; rescue NoMethodError; nil; end ||
        begin; actual.new;      rescue StandardError; nil; end

      if instance.nil?
        @failing_method_reasons = {
          :unable_to_create_instance => true
        } # end hash

        return false
      end # unless

      constructor =
        begin
          instance.method(:initialize)
        rescue NameError
          nil
        end # unless

      unless constructor.is_a?(Method)
        @failing_method_reasons = {
          :is_not_a_method => true
        } # end hash

        return false
      end # unless

      return true unless method_signature_expectation?

      unless check_method_signature(constructor)
        @failing_method_reasons = method_signature_expectation.errors

        return false
      end # unless

      true
    end # method matches?

    # (see BaseMatcher#failure_message)
    def failure_message
      message = "expected #{@actual.inspect} to be constructible"

      if method_signature_expectation?
        message << " with arguments:\n"

        message << format_errors(@failing_method_reasons)
      end # if

      message
    end # method failure_message

    # (see BaseMatcher#failure_message_when_negated)
    def failure_message_when_negated
      message = "expected #{@actual.inspect} not to be constructible"

      if method_signature_expectation?
        message << ' ' << method_signature_expectation.description
      end # if

      message
    end # method failure_message_when_negated
  end # class
end # module
