# lib/rspec/sleeping_king_studios/matchers/core/be_boolean.rb

require 'rspec/sleeping_king_studios/spec_helper'
require 'rspec/sleeping_king_studios/examples/rspec_matcher_examples'

require 'rspec/sleeping_king_studios/matchers/core/be_boolean'

describe RSpec::SleepingKingStudios::Matchers::Core::BeBooleanMatcher do
  include RSpec::SleepingKingStudios::Examples::RSpecMatcherExamples

  let(:example_group) { self }

  it { expect(example_group).to respond_to(:a_boolean).with(0).arguments }
  it { expect(example_group.a_boolean.base_matcher).to be_a described_class }

  it { expect(example_group).to respond_to(:be_boolean).with(0).arguments }
  it { expect(example_group.be_boolean).to be_a described_class }

  it { expect(example_group).to respond_to(:be_bool).with(0).arguments }
  it { expect(example_group.be_bool).to be_a described_class }

  let(:instance) { described_class.new }

  <<-SCENARIOS
    When the object is true,
      Evaluates to true with should_not message "not to be true or false".
    When the object is false,
      Evaluates to true with should_not message "not to be true or false".
    When the object is neither true nor false,
      Evaluates to false with should message "to be true or false".
  SCENARIOS

  describe '#description' do
    context 'with a matcher from #a_boolean' do
      let(:instance) { example_group.a_boolean }

      it { expect(instance.description).to be == 'true or false' }
    end # context

    context 'with a matcher from #be_boolean' do
      let(:instance) { example_group.be_boolean }

      it { expect(instance.description).to be == 'be true or false' }
    end # context
  end # describe

  describe '#matches?' do
    describe 'with true' do
      let(:failure_message_when_negated) do
        "expected #{actual.inspect} not to be true or false"
      end # let
      let(:actual) { true }

      include_examples 'passes with a positive expectation'

      include_examples 'fails with a negative expectation'
    end # describe

    describe 'with false' do
      let(:failure_message_when_negated) do
        "expected #{actual.inspect} not to be true or false"
      end # let
      let(:actual) { false }

      include_examples 'passes with a positive expectation'

      include_examples 'fails with a negative expectation'
    end # describe

    describe 'with nil' do
      let(:failure_message) { "expected #{actual.inspect} to be true or false" }
      let(:actual) { nil }

      include_examples 'fails with a positive expectation'

      include_examples 'passes with a negative expectation'
    end # describe

    describe 'with a non Boolean object' do
      let(:failure_message) { "expected #{actual.inspect} to be true or false" }
      let(:actual) { Object.new }

      include_examples 'fails with a positive expectation'

      include_examples 'passes with a negative expectation'
    end # describe
  end # describe
end # describe
