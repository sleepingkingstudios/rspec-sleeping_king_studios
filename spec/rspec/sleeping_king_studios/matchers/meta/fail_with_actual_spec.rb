# spec/rspec/sleeping_king_studios/matchers/meta/fail_with_actual_spec.rb

require 'rspec/sleeping_king_studios/spec_helper'

require 'rspec/sleeping_king_studios/matchers/meta/fail_with_actual'

describe RSpec::SleepingKingStudios::Matchers::Meta::FailWithActualMatcher do
  let(:example_group) { self }
  let(:actual)        { nil }
  
  it { expect(example_group).to respond_to(:fail_with_actual).with(1).arguments }
  it { expect(example_group.fail_with_actual actual).to be_a described_class }

  let(:instance) { described_class.new actual }

  describe '#message' do
    it { expect(instance).to respond_to(:message).with(0).arguments }
  end # describe

  describe "#with_message" do
    let(:expected_message) { "my hovercraft is full of eels" }

    it { expect(instance).to respond_to(:with_message).with(1).arguments }
    it { expect(instance.with_message expected_message).to be instance }
    it { expect(instance.with_message(expected_message).message).to be == expected_message }
  end # describe
  
  <<-SCENARIOS
    When given a matcher that evaluates to true,
      Evaluates to false with message "expected not to match"
    When given a matcher that evaluates to false,
      And not given a should message,
        Evaluates to true.
      And given a correct should message,
        Evaluates to true.
      And given an incorrect should message,
        Evaluates to false with message "expected message:, got message:"
      And given a matching should_not pattern,
        Evaluates to true.
      And given a non-matching should_not pattern,
        Evaluates to false with message "expected message matching, got message:"
    When given a matcher that responds to #does_not_match?,
      And #does_not_match? evaluates to true,
        Evaluates to true
      And #does_not_match? evaluates to false,
        Evaluates to false with message "expected not to match"
  SCENARIOS

  let(:matcher) { example_group.be_truthy }

  describe 'error message for should not' do
    let(:invalid_message) { "failure: testing positive condition with negative matcher\n~>  use the :pass_with_actual matcher instead" }

    it { expect(instance.failure_message_when_negated).to be == invalid_message }
  end # describe

  describe 'with a passing matcher' do
    let(:actual)          { true }
    let(:failure_message) { "expected #{matcher} not to match #{actual}" }

    it { expect(instance.matches? matcher).to be false }
    it 'has the expected failure message' do
      instance.matches? matcher
      expect(instance.failure_message).to eq failure_message
    end # it
  end # describe

  describe 'with a failing matcher' do
    let(:actual) { false }

    describe 'with no message' do
      it { expect(instance.matches? matcher).to be true }
    end # context

    describe 'with a correct should message' do
      let(:correct_message)  { "expected: truthy value\n     got: false" }
      let(:instance) { super().with_message correct_message }

      it { expect(instance.matches? matcher).to be true }
    end # context

    describe 'with an incorrect should message' do
      let(:incorrect_message) { "my hovercraft is full of eels" }
      let(:correct_message)   { "expected: truthy value\n     got: false" }
      let(:failure_message) do
        "expected message:\n#{
          incorrect_message.lines.map { |line| "#{" " * 2}#{line}" }.join
        }\nreceived message:\n#{
          correct_message.lines.map { |line| "#{" " * 2}#{line}" }.join
        }"
      end # let
      let(:instance) { super().with_message incorrect_message }

      it { expect(instance.matches? matcher).to be false }
      it 'has the expected failure message' do
        instance.matches? matcher
        expect(instance.failure_message).to eq failure_message
      end # it
    end # context

    describe 'with a matching should pattern' do
      let(:correct_message)  { /got\: false/ }
      let(:instance) { super().with_message correct_message }

      it { expect(instance.matches? matcher).to be true }
    end # context 

    describe 'with a non-matching should message' do
      let(:incorrect_message) { /hovercraft is full of eels/ }
      let(:correct_message)   { "expected: truthy value\n     got: false" }
      let(:failure_message) do
        "expected message matching:\n#{
          incorrect_message.inspect.lines.map { |line| "#{" " * 2}#{line}" }.join
        }\nreceived message:\n#{
          correct_message.lines.map { |line| "#{" " * 2}#{line}" }.join
        }"
      end # let
      let(:instance) { super().with_message incorrect_message }

      it { expect(instance.matches? matcher).to be false }
      it 'has the expected failure message' do
        instance.matches? matcher
        expect(instance.failure_message).to eq failure_message
      end # it
    end # context
  end # describe

  describe 'with a matcher that responds to #does_not_match?' do
    let(:expected) { %w(Tron Clu) }
    let(:matcher)  { example_group.include(*expected) }

    describe 'with a mixed actual' do
      let(:actual)          { %w(Clu Sark MCP) }
      let(:failure_message) { "expected #{matcher} not to match #{actual}" }

      it { expect(matcher.matches?(actual)).to be false }
      it { expect(matcher.does_not_match?(actual)).to be false }

      it { expect(instance.matches? matcher).to be false }
      it 'has the expected failure message' do
        instance.matches? matcher
        expect(instance.failure_message).to eq failure_message
      end # it
    end # describe
  end # describe
end # describe
