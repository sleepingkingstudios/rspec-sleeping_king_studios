# spec/rspec/sleeping_king_studios/examples/rspec_matcher_examples_spec.rb

require 'rspec/sleeping_king_studios/spec_helper'

require 'rspec/sleeping_king_studios/examples/rspec_matcher_examples'

RSpec.describe RSpec::SleepingKingStudios::Examples::RSpecMatcherExamples do
  include described_class

  let(:instance) { be_truthy }

  describe 'with a passing matcher' do
    let(:failure_message_when_negated) do
      'expected: falsey value'
    end # let
    let(:actual) { true }

    include_examples 'passes with a positive expectation'

    include_examples 'fails with a negative expectation'
  end # describe

  describe 'with a failing matcher' do
    let(:failure_message) do
      'expected: truthy value'
    end # let
    let(:actual) { false }

    include_examples 'fails with a positive expectation'

    include_examples 'passes with a negative expectation'
  end # describe
end # describe
