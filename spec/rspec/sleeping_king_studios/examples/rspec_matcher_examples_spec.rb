# spec/rspec/sleeping_king_studios/examples/rspec_matcher_examples_spec.rb

require 'spec_helper'

require 'rspec/sleeping_king_studios/examples/rspec_matcher_examples'

RSpec.describe RSpec::SleepingKingStudios::Examples::RSpecMatcherExamples do
  include described_class

  let(:instance) { be_truthy }

  describe 'with a passing matcher' do
    let(:actual) { true }

    include_examples 'passes with a positive expectation'

    include_examples 'should pass with a positive expectation'

    describe 'with an exact string match' do
      let(:failure_message_when_negated) do
        "expected: falsey value\n     got: true"
      end # let

      include_examples 'fails with a negative expectation'

      include_examples 'should fail with a negative expectation'
    end # describe

    describe 'with a partial string match' do
      let(:failure_message_when_negated) do
        'expected: falsey value'
      end # let

      before(:each) do
        config = RSpec.configuration.sleeping_king_studios.examples

        allow(config).to receive(:match_string_failure_message_as).and_return(:substring)
      end # each

      include_examples 'fails with a negative expectation'

      include_examples 'should fail with a negative expectation'
    end # describe

    describe 'with a regex match' do
      let(:failure_message_when_negated) do
        /falsey value/
      end # let

      include_examples 'fails with a negative expectation'

      include_examples 'should fail with a negative expectation'
    end # describe

    describe 'with an RSpec matcher' do
      let(:failure_message_when_negated) do
        match 'expected: falsey value'
      end # let

      include_examples 'fails with a negative expectation'

      include_examples 'should fail with a negative expectation'
    end # describe
  end # describe

  describe 'with a failing matcher' do
    let(:actual) { false }

    include_examples 'passes with a negative expectation'

    include_examples 'should pass with a negative expectation'

    describe 'with an exact string match' do
      let(:failure_message) do
        "expected: truthy value\n     got: false"
      end # let

      include_examples 'fails with a positive expectation'

      include_examples 'should fail with a positive expectation'
    end # describe

    describe 'with a partial string match' do
      let(:failure_message) do
        'expected: truthy value'
      end # let

      before(:each) do
        config = RSpec.configuration.sleeping_king_studios.examples

        allow(config).to receive(:match_string_failure_message_as).and_return(:substring)
      end # each

      include_examples 'fails with a positive expectation'

      include_examples 'should fail with a positive expectation'
    end # describe

    describe 'with a regex match' do
      let(:failure_message) do
        /truthy value/
      end # let

      include_examples 'fails with a positive expectation'

      include_examples 'should fail with a positive expectation'
    end # describe

    describe 'with an RSpec matcher' do
      let(:failure_message) do
        match 'expected: truthy value'
      end # let

      include_examples 'fails with a positive expectation'

      include_examples 'should fail with a positive expectation'
    end # describe
  end # describe
end # describe
