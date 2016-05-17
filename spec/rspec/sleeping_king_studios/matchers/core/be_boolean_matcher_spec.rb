# spec/rspec/sleeping_king_studios/matchers/core/be_boolean_matcher_spec.rb

require 'spec_helper'
require 'rspec/sleeping_king_studios/examples/rspec_matcher_examples'

require 'rspec/sleeping_king_studios/matchers/core/be_boolean_matcher'

RSpec.describe RSpec::SleepingKingStudios::Matchers::Core::BeBooleanMatcher do
  include RSpec::SleepingKingStudios::Examples::RSpecMatcherExamples

  let(:instance) { described_class.new }

  describe '#description' do
    it { expect(instance).to respond_to(:description).with(0).arguments }

    it { expect(instance.description).to be == 'be true or false' }
  end # describe

  describe '#matches?' do
    describe 'with true' do
      let(:failure_message_when_negated) do
        "expected #{actual.inspect} not to be true or false"
      end # let
      let(:actual) { true }

      include_examples 'should pass with a positive expectation'

      include_examples 'should fail with a negative expectation'
    end # describe

    describe 'with false' do
      let(:failure_message_when_negated) do
        "expected #{actual.inspect} not to be true or false"
      end # let
      let(:actual) { false }

      include_examples 'should pass with a positive expectation'

      include_examples 'should fail with a negative expectation'
    end # describe

    describe 'with nil' do
      let(:failure_message) { "expected #{actual.inspect} to be true or false" }
      let(:actual) { nil }

      include_examples 'should fail with a positive expectation'

      include_examples 'should pass with a negative expectation'
    end # describe

    describe 'with a non Boolean object' do
      let(:failure_message) { "expected #{actual.inspect} to be true or false" }
      let(:actual) { Object.new }

      include_examples 'should fail with a positive expectation'

      include_examples 'should pass with a negative expectation'
    end # describe
  end # describe
end # describe
