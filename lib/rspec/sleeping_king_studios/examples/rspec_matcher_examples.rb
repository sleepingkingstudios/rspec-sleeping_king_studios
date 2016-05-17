# lib/rspec/sleeping_king_studios/examples/rspec_matcher_examples.rb

require 'rspec/sleeping_king_studios/concerns/shared_example_group'
require 'rspec/sleeping_king_studios/examples'
require 'rspec/sleeping_king_studios/matchers/base_matcher'

# Pregenerated example groups for testing RSpec matchers.
module RSpec::SleepingKingStudios::Examples::RSpecMatcherExamples
  extend RSpec::SleepingKingStudios::Concerns::SharedExampleGroup

  private def config
    RSpec.configuration.sleeping_king_studios
  end # method config

  private def compare_message actual, expected
    case expected
    when String
      if config.examples.match_string_failure_message_as == :exact
        expect(actual).to be == expected
      else
        expect(actual).to include expected
      end # if-else
    when Regexp
      expect(actual).to be =~ expected
    when ->(obj) { obj.respond_to?(:matches?) && obj.respond_to?(:failure_message) }
      expect(actual).to expected
    else
      expect(actual).to match expected
    end # when
  end # method compare_message

  private def handle_missing_failure_message message
    case config.examples.handle_missing_failure_message_with
    when :pending
      skip message
    when :exception
      raise StandardError.new message
    end # case
  end # method handle_missing_failure_message

  shared_examples 'should pass with a positive expectation' do
    let(:matcher_being_examined) { defined?(instance) ? instance : subject }

    it 'should pass with positive expectation' do
      expect(matcher_being_examined.matches? actual).to be true
    end # it
  end # shared_examples
  alias_shared_examples 'passes with a positive expectation', 'should pass with a positive expectation'

  shared_examples 'should fail with a positive expectation' do
    let(:matcher_being_examined) { defined?(instance) ? instance : subject }

    it 'should fail with a positive expectation' do
      expect(matcher_being_examined.matches? actual).to be false
    end # it

    it 'should have a failure message with a positive expectation' do
      if defined?(failure_message)
        matcher_being_examined.matches?(actual)

        compare_message(matcher_being_examined.failure_message, failure_message)
      else
        message =
          "expected to match #{matcher_being_examined.class}#failure_message, "\
          "but the expected value was undefined. Define a failure message "\
          "using let(:failure_message) or set "\
          "config.handle_missing_failure_message_with to :ignore or :pending."

        handle_missing_failure_message(message)
      end # if
    end # it
  end # shared_examples
  alias_shared_examples 'fails with a positive expectation', 'should fail with a positive expectation'

  shared_examples 'should pass with a negative expectation' do
    let(:matcher_being_examined) { defined?(instance) ? instance : subject }

    it 'should pass with a negative expectation' do
      if matcher_being_examined.respond_to?(:does_not_match?)
        expect(matcher_being_examined.does_not_match? actual).to be true
      else
        expect(matcher_being_examined.matches? actual).to be false
      end # if-else
    end # it
  end # shared_examples
  alias_shared_examples 'passes with a negative expectation', 'should pass with a negative expectation'

  shared_examples 'should fail with a negative expectation' do
    let(:matcher_being_examined) { defined?(instance) ? instance : subject }

    it 'should fail with a negative expectation' do
      if matcher_being_examined.respond_to?(:does_not_match?)
        expect(matcher_being_examined.does_not_match? actual).to be false
      else
        expect(matcher_being_examined.matches? actual).to be true
      end # if-else
    end # it

    it 'should have a failure message with a negative expectation' do
      if defined?(failure_message_when_negated)
        if matcher_being_examined.respond_to?(:does_not_match?)
          matcher_being_examined.does_not_match?(actual)
        else
          matcher_being_examined.matches?(actual)
        end # if-else

        compare_message(matcher_being_examined.failure_message_when_negated, failure_message_when_negated)
      else
        message =
          "expected to match #{matcher_being_examined.class}#"\
          "failure_message_when_negated, but the expected value was undefined."\
          " Define a failure message using let(:failure_message_when_negated) "\
          "or set config.handle_missing_failure_message_with to :ignore or "\
          ":pending."

        handle_missing_failure_message(message)
      end # if
    end # it
  end # shared_examples
  alias_shared_examples 'fails with a negative expectation', 'should fail with a negative expectation'
end # module
