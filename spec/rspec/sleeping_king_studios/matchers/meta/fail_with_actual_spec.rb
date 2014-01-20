# spec/rspec/sleeping_king_studios/matchers/meta/fail_with_actual_spec.rb

require 'rspec/sleeping_king_studios/spec_helper'
require 'rspec/sleeping_king_studios/matchers/base_matcher_helpers'

require 'rspec/sleeping_king_studios/matchers/meta/fail_with_actual'

describe RSpec::SleepingKingStudios::Matchers::Meta::FailWithActualMatcher do
  include RSpec::SleepingKingStudios::Matchers::BaseMatcherHelpers

  let(:example_group) { self }
  let(:actual)        { nil }
  
  specify { expect(example_group).to respond_to(:fail_with_actual).with(1).arguments }
  specify { expect(example_group.fail_with_actual actual).to be_a described_class }

  let(:instance) { described_class.new actual }

  it_behaves_like RSpec::SleepingKingStudios::Matchers::BaseMatcher do
    let(:actual) { example_group.be_false }
  end # shared behavior

  describe '#message' do
    specify { expect(instance).to respond_to(:message).with(0).arguments }
  end # describe

  describe "#with_message" do
    let(:expected_message) { "my hovercraft is full of eels" }

    specify { expect(instance).to respond_to(:with_message).with(1).arguments }
    specify { expect(instance.with_message expected_message).to be instance }
    specify { expect(instance.with_message(expected_message).message).to be == expected_message }
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
  SCENARIOS

  let(:matcher) { example_group.be_true }

  describe 'error message for should not' do
    let(:invalid_message) { "failure: testing positive condition with negative matcher\n~>  use the :pass_with_actual matcher instead" }

    specify { expect(instance.failure_message_for_should_not).to be == invalid_message }
  end # context

  context 'with a passing matcher' do
    let(:actual)          { true }
    let(:failure_message) { "expected #{matcher} not to match #{actual}" }

    specify { expect(instance.matches? matcher).to be false }
    specify 'failure message' do
      instance.matches? matcher
      expect(instance.failure_message_for_should).to eq failure_message
    end # specify
  end # context

  context 'with a failing matcher' do
    let(:actual) { false }

    context 'with no message' do
      specify { expect(instance.matches? matcher).to be true }
    end # context

    context 'with a correct should message' do
      let(:correct_message)  { "expected: true value\n     got: false" }
      let(:instance) { super().with_message correct_message }

      specify { expect(instance.matches? matcher).to be true }
    end # context

    context 'with an incorrect should message' do
      let(:incorrect_message) { "my hovercraft is full of eels" }
      let(:correct_message)   { "expected: true value\n     got: false" }
      let(:failure_message) do
        "expected message:\n#{
          incorrect_message.lines.map { |line| "#{" " * 2}#{line}" }.join
        }\nreceived message:\n#{
          correct_message.lines.map { |line| "#{" " * 2}#{line}" }.join
        }"
      end # let
      let(:instance) { super().with_message incorrect_message }

      specify { expect(instance.matches? matcher).to be false }
      specify 'failure message' do
        instance.matches? matcher
        expect(instance.failure_message_for_should).to eq failure_message
      end # specify
    end # context

    context 'with a matching should pattern' do
      let(:correct_message)  { /got\: false/ }
      let(:instance) { super().with_message correct_message }

      specify { expect(instance.matches? matcher).to be true }
    end # context

    context 'with a non-matching should message' do
      let(:incorrect_message) { /hovercraft is full of eels/ }
      let(:correct_message)   { "expected: true value\n     got: false" }
      let(:failure_message) do
        "expected message matching:\n#{
          incorrect_message.inspect.lines.map { |line| "#{" " * 2}#{line}" }.join
        }\nreceived message:\n#{
          correct_message.lines.map { |line| "#{" " * 2}#{line}" }.join
        }"
      end # let
      let(:instance) { super().with_message incorrect_message }

      specify { expect(instance.matches? matcher).to be false }
      specify 'failure message' do
        instance.matches? matcher
        expect(instance.failure_message_for_should).to eq failure_message
      end # specify
    end # context
  end # context
end # describe
