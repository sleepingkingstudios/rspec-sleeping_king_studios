# lib/rspec/sleeping_king_studios/examples/rspec_matcher_examples.rb

require 'rspec/sleeping_king_studios/examples'
require 'rspec/sleeping_king_studios/matchers/base_matcher'

module RSpec::SleepingKingStudios::Examples::RSpecMatcherExamples
  shared_examples 'passes with a positive expectation' do
    it 'passes with a positive expectation' do
      expect(instance.matches? actual).to be true
    end # it
  end # shared_examples

  shared_examples 'fails with a positive expectation' do
    it 'fails with a positive expectation' do
      expect(instance.matches? actual).to be false

      if defined?(failure_message)
        expect(instance.failure_message).to match failure_message
      end # if
    end # it
  end # shared_examples

  shared_examples 'passes with a negative expectation' do
    it 'passes with a negative expectation' do
      if instance.respond_to?(:does_not_match?)
        expect(instance.does_not_match? actual).to be true
      else
        expect(instance.matches? actual).to be false
      end # if-else
    end # it
  end # shared_examples

  shared_examples 'fails with a negative expectation' do
    it 'fails with a negative expectation' do
      if instance.respond_to?(:does_not_match?)
        expect(instance.does_not_match? actual).to be false
      else
        expect(instance.matches? actual).to be true
      end # if-else

      if defined?(failure_message_when_negated)
        expect(instance.failure_message_when_negated).to match failure_message_when_negated
      end # if
    end # it
  end # shared_examples
end # module
