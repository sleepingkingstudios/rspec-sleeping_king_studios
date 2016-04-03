# spec/rspec/sleeping_king_studios/matchers/base_matcher_spec.rb

require 'rspec/sleeping_king_studios/spec_helper'
require 'rspec/sleeping_king_studios/examples/rspec_matcher_examples'

require 'rspec/sleeping_king_studios/matchers/base_matcher'

describe RSpec::SleepingKingStudios::Matchers::BaseMatcher do
  include RSpec::SleepingKingStudios::Examples::RSpecMatcherExamples

  let(:instance) { described_class.new }
  let(:actual)   { Object.new }

  describe '#actual' do
    it { expect(instance).to respond_to(:actual).with(0).arguments }
  end # describe

  describe '#description' do
    it { expect(instance).to respond_to(:description).with(0).arguments }

    it { expect(instance.description).to be_a String }
  end # describe

  describe '#does_not_match?' do
    it { expect(instance).to respond_to(:matches?).with(1).arguments }

    context 'with a successful match' do
      let(:failure_message_when_negated) { 'expected nil not to match' }

      before(:each) { allow(instance).to receive(:does_not_match?).and_return(false) }

      expect_behavior 'fails with a negative expectation'
    end # context

    context 'with a failing match' do
      before(:each) { allow(instance).to receive(:does_not_match?).and_return(true) }

      expect_behavior 'passes with a negative expectation'
    end # context
  end # describe

  describe '#failure_message' do
    it { expect(instance).to respond_to(:failure_message).with(0).arguments }

    it 'returns a String' do
      instance.matches? actual

      expect(instance.failure_message).to be_a String
    end # it
  end # describe

  describe '#failure_message_when_negated' do
    it { expect(instance).to respond_to(:failure_message_when_negated).with(0).arguments }

    it 'returns a String' do
      instance.matches? actual

      expect(instance.failure_message_when_negated).to be_a String
    end # it
  end # describe

  describe '#matches?' do
    it { expect(instance).to respond_to(:matches?).with(1).arguments }

    context 'with a successful match' do
      let(:failure_message_when_negated) { 'expected nil not to match' }

      before(:each) { allow(instance).to receive(:matches?).and_return(true) }

      expect_behavior 'passes with a positive expectation'

      expect_behavior 'fails with a negative expectation'
    end # context

    context 'with a failing match' do
      let(:failure_message) { 'expected nil to match' }

      before(:each) { allow(instance).to receive(:matches?).and_return(false) }

      expect_behavior 'fails with a positive expectation'

      expect_behavior 'passes with a negative expectation'
    end # context
  end # describe
end # describe
