# lib/rspec/sleeping_king_studios/matchers/core/be_boolean.rb

require 'rspec/sleeping_king_studios/spec_helper'
require 'rspec/sleeping_king_studios/matchers/base_matcher_helpers'

require 'rspec/sleeping_king_studios/matchers/core/be_boolean'

describe RSpec::SleepingKingStudios::Matchers::Core::BeBooleanMatcher do
  let(:example_group) { self }
  
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

  describe 'with true' do
    let(:actual) { true }

    it 'passes' do
      expect(instance).to pass_with_actual(actual).
        with_message "expected #{actual.inspect} not to be true or false"
    end # it
  end # describe

  describe 'with false' do
    let(:actual) { false }

    it 'passes' do
      expect(instance).to pass_with_actual(actual).
        with_message "expected #{actual.inspect} not to be true or false"
    end # it
  end # describe

  describe 'with nil' do
    let(:actual) { nil }

    it 'fails' do
      expect(instance).to fail_with_actual(actual).
        with_message "expected #{actual.inspect} to be true or false"
    end # it
  end # describe

  describe 'with a non Boolean object' do
    let(:actual) { Object.new }

    it 'fails' do
      expect(instance).to fail_with_actual(actual).
        with_message "expected #{actual.inspect} to be true or false"
    end # it
  end # describe
end # describe
