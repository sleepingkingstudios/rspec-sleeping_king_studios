require 'spec_helper'
require 'rspec/sleeping_king_studios/examples/rspec_matcher_examples'

require 'rspec/sleeping_king_studios/matchers/core/have_changed_matcher'

RSpec.describe RSpec::SleepingKingStudios::Matchers::Core::HaveChangedMatcher do
  include RSpec::SleepingKingStudios::Examples::RSpecMatcherExamples

  subject(:instance) { described_class.new }

  describe '#description' do
    let(:expected) { 'have changed' }

    it { expect(instance).to respond_to(:description).with(0).arguments }

    it { expect(instance.description).to be == expected }
  end

  describe '#matches?' do
    shared_context 'when the value has changed' do
      let(:changed_value) { 'changed value'.freeze }

      before(:example) do
        actual # Force evaluation of the memoized helper.

        object.value = changed_value
      end
    end

    let(:failure_message) do
      "expected #{actual.description} to have changed"
    end
    let(:failure_message_when_negated) do
      "expected #{actual.description} not to have changed"
    end
    let(:initial_value) { 'initial value'.freeze }
    let(:object)        { Struct.new(:value).new(initial_value) }
    let(:actual) do
      RSpec::SleepingKingStudios::Support::ValueObservation.new(object, :value)
    end

    describe 'with nil' do
      it 'should raise an error' do
        expect { instance.matches? nil }
          .to raise_error(
            ArgumentError,
            'You must pass a value observation to `expect`.'
          )
      end
    end

    describe 'with an object' do
      it 'should raise an error' do
        expect { instance.matches? Object.new }
          .to raise_error(
            ArgumentError,
            'You must pass a value observation to `expect`.'
          )
      end
    end

    describe 'with a value observation with an unchanged value' do
      let(:failure_message) do
        super() << ", but is still #{object.value.inspect}"
      end

      include_examples 'should fail with a positive expectation'

      include_examples 'should pass with a negative expectation'
    end

    describe 'with a value observation with a changed value' do
      include_context 'when the value has changed'

      let(:failure_message_when_negated) do
        super() <<
          ", but did change from #{initial_value.inspect} to " <<
          changed_value.inspect
      end

      include_examples 'should pass with a positive expectation'

      include_examples 'should fail with a negative expectation'
    end
  end
end
