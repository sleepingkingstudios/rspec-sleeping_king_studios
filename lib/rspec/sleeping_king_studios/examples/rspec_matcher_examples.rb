# lib/rspec/sleeping_king_studios/examples/rspec_matcher_examples.rb

require 'rspec/sleeping_king_studios/concerns/shared_example_group'
require 'rspec/sleeping_king_studios/examples'
require 'rspec/sleeping_king_studios/matchers/base_matcher'

module RSpec::SleepingKingStudios::Examples::RSpecMatcherExamples
  extend RSpec::SleepingKingStudios::Concerns::SharedExampleGroup

  shared_examples 'passes with a positive expectation' do
    let(:matcher_being_examined) { defined?(instance) ? instance : subject }

    it 'passes with a positive expectation' do
      expect(matcher_being_examined.matches? actual).to be true
    end # it
  end # shared_examples
  alias_shared_examples 'should pass with a positive expectation', 'passes with a positive expectation'

  shared_examples 'fails with a positive expectation' do
    let(:matcher_being_examined) { defined?(instance) ? instance : subject }

    it 'fails with a positive expectation' do
      expect(matcher_being_examined.matches? actual).to be false
    end # it

    it 'has a failure message with a positive expectation' do
      if defined?(failure_message)
        matcher_being_examined.matches?(actual)

        expected = failure_message.is_a?(String) ?
          Regexp.new(Regexp.escape(failure_message)) :
          failure_message

        expect(matcher_being_examined.failure_message).to match expected
      else
        message = <<-MESSAGE
          expected to match #{matcher_being_examined.class}#failure_message, but the expected
          value was undefined. Define a failure message using
          let(:failure_message) or set
          config.handle_missing_failure_message_with to :ignore or :pending.
        MESSAGE
        message = message.split("\n").map(&:strip).join(' ')
        case RSpec.configuration.sleeping_king_studios.examples.handle_missing_failure_message_with
        when :pending
          skip message
        when :exception
          raise StandardError.new message
        end # case
      end # if
    end # it
  end # shared_examples
  alias_shared_examples 'should fail with a positive expectation', 'fails with a positive expectation'

  shared_examples 'passes with a negative expectation' do
    let(:matcher_being_examined) { defined?(instance) ? instance : subject }

    it 'passes with a negative expectation' do
      if matcher_being_examined.respond_to?(:does_not_match?)
        expect(matcher_being_examined.does_not_match? actual).to be true
      else
        expect(matcher_being_examined.matches? actual).to be false
      end # if-else
    end # it
  end # shared_examples
  alias_shared_examples 'should pass with a negative expectation', 'passes with a negative expectation'

  shared_examples 'fails with a negative expectation' do
    let(:matcher_being_examined) { defined?(instance) ? instance : subject }

    it 'fails with a negative expectation' do
      if matcher_being_examined.respond_to?(:does_not_match?)
        expect(matcher_being_examined.does_not_match? actual).to be false
      else
        expect(matcher_being_examined.matches? actual).to be true
      end # if-else
    end # it

    it 'has a failure message with a negative expectation' do
      if defined?(failure_message_when_negated)
        matcher_being_examined.respond_to?(:does_not_match?) ? matcher_being_examined.does_not_match?(actual) : matcher_being_examined.matches?(actual)

        expected = failure_message_when_negated.is_a?(String) ?
          Regexp.new(Regexp.escape(failure_message_when_negated)) :
          failure_message_when_negated

        expect(matcher_being_examined.failure_message_when_negated).to match expected
      else
        message = <<-MESSAGE
          expected to match #{matcher_being_examined.class}#failure_message_when_negated, but
          the expected value was undefined. Define a failure message using
          let(:failure_message_when_negated) or set
          config.handle_missing_failure_message_with to :ignore or :pending.
        MESSAGE
        message = message.split("\n").map(&:strip).join(' ')
        case RSpec.configuration.sleeping_king_studios.examples.handle_missing_failure_message_with
        when :pending
          skip message
        when :exception
          raise StandardError.new message
        end # case
      end # if
    end # it
  end # shared_examples
  alias_shared_examples 'should fail with a negative expectation', 'fails with a negative expectation'
end # module
