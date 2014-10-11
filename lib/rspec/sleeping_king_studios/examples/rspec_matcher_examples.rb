# lib/rspec/sleeping_king_studios/examples/rspec_matcher_examples.rb

require 'rspec/sleeping_king_studios/examples'
require 'rspec/sleeping_king_studios/matchers/base_matcher'

module RSpec::SleepingKingStudios::Examples::RSpecMatcherExamples
  shared_examples 'passes with a positive expectation' do
    let(:instance) { defined?(super) ? super() : subject }

    it 'passes with a positive expectation' do
      expect(instance.matches? actual).to be true
    end # it
  end # shared_examples

  shared_examples 'fails with a positive expectation' do
    let(:instance) { defined?(super) ? super() : subject }

    it 'fails with a positive expectation' do
      expect(instance.matches? actual).to be false
    end # it

    it 'has a failure message with a positive expectation' do
      if defined?(failure_message)
        instance.matches?(actual)

        expected = failure_message.is_a?(String) ?
          Regexp.escape(failure_message) :
          failure_message

        expect(instance.failure_message).to match expected
      else
        message = <<-MESSAGE
          expected to match #{instance.class}#failure_message, but the expected
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

  shared_examples 'passes with a negative expectation' do
    let(:instance) { defined?(super) ? super() : subject }

    it 'passes with a negative expectation' do
      if instance.respond_to?(:does_not_match?)
        expect(instance.does_not_match? actual).to be true
      else
        expect(instance.matches? actual).to be false
      end # if-else
    end # it
  end # shared_examples

  shared_examples 'fails with a negative expectation' do
    let(:instance) { defined?(super) ? super() : subject }

    it 'fails with a negative expectation' do
      if instance.respond_to?(:does_not_match?)
        expect(instance.does_not_match? actual).to be false
      else
        expect(instance.matches? actual).to be true
      end # if-else
    end # it

    it 'has a failure message with a negative expectation' do
      if defined?(failure_message_when_negated)
        instance.respond_to?(:does_not_match?) ? instance.does_not_match?(actual) : instance.matches?(actual)

        expected = failure_message_when_negated.is_a?(String) ?
          Regexp.escape(failure_message_when_negated) :
          failure_message_when_negated

        expect(instance.failure_message_when_negated).to match expected
      else
        message = <<-MESSAGE
          expected to match #{instance.class}#failure_message_when_negated, but
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
end # module
