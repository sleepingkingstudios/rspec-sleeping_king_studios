# spec/rspec/sleeping_king_studios/matchers/rspec/pass_with_actual_spec.rb

require 'rspec/sleeping_king_studios/spec_helper'
require 'rspec/sleeping_king_studios/matchers/base_matcher_helpers'

require 'rspec/sleeping_king_studios/matchers/meta/pass_with_actual'

describe RSpec::SleepingKingStudios::Matchers::Meta::PassWithActualMatcher do
  include RSpec::SleepingKingStudios::Matchers::BaseMatcherHelpers

  let(:example_group) { self }
  let(:actual)        { nil }
  
  specify { expect(example_group).to respond_to(:pass_with_actual).with(1).arguments }
  specify { expect(example_group.pass_with_actual actual).to be_a described_class }

  let(:instance) { described_class.new actual }

  it_behaves_like RSpec::SleepingKingStudios::Matchers::BaseMatcher do
    let(:actual) { example_group.be_truthy }
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
      And not given a should_not message,
        Evaluates to true.
      And given a correct should_not message,
        Evaluates to true.
      And given an incorrect should_not message,
        Evaluates to false with message "expected message, received message"
      And given a matching should_not pattern,
        Evaluates to true.
      And given a non-matching should_not pattern,
        Evaluates to false with message "expected message matching, received message"
    When given a matcher that evaluates to false,
      Evaluates to false with message "expected to match".
  SCENARIOS

  let(:matcher) { example_group.be_truthy }

  describe 'error message for should not' do
    let(:invalid_message) { "failure: testing negative condition with positive matcher\n~>  use the :fail_with_actual matcher instead" }

    specify { expect(instance.failure_message_for_should_not).to be == invalid_message }
  end # context

  context 'with a passing matcher' do
    let(:actual) { true }

    specify { expect(instance.matches? matcher).to be true }

    context 'with a correct should_not message' do
      let(:correct_message) { "expected: falsey value\n     got: true" }
      let(:instance)        { super().with_message(correct_message) }

      specify { expect(instance.matches? matcher).to be true }
    end # context

    context 'with an incorrect should_not message' do
      let(:incorrect_message) { "my hovercraft is full of eels" }
      let(:correct_message)   { "expected: falsey value\n     got: true" }
      let(:failure_message) do
        "expected message:\n#{
          incorrect_message.lines.map { |line| "#{" " * 2}#{line}" }.join
        }\nreceived message:\n#{
          correct_message.lines.map   { |line| "#{" " * 2}#{line}" }.join
        }"
      end # let
      let(:instance) { super().with_message(incorrect_message) }

      specify { expect(instance.matches? matcher).to be false }
      specify 'failure message' do
        instance.matches? matcher
        expect(instance.failure_message_for_should).to eq failure_message
      end # specify
    end # context

    context 'with a matching should_not pattern' do
      let(:correct_message) { /falsey value/i }
      let(:instance)        { super().with_message(correct_message) }

      specify { expect(instance.matches? matcher).to be true }
    end # context

    context 'with a non-matching should_not pattern' do
      let(:incorrect_message) { /hovercraft is full of eels/ }
      let(:correct_message)   { "expected: falsey value\n     got: true" }
      let(:failure_message) do
        "expected message matching:\n#{
          incorrect_message.inspect.lines.map { |line| "#{" " * 2}#{line}" }.join
        }\nreceived message:\n#{
          correct_message.lines.map   { |line| "#{" " * 2}#{line}" }.join
        }"
      end # let
      let(:instance) { super().with_message(incorrect_message) }

      specify { expect(instance.matches? matcher).to be false }
      specify 'failure message' do
        instance.matches? matcher
        expect(instance.failure_message_for_should).to eq failure_message
      end # specify
    end # context
  end # context

  context 'with a failing matcher' do
    let(:actual) { false }
    let(:received_message) do
      "expected: truthy value\n     got: false".lines.map { |line| "#{" " * 4}#{line}" }.join("\n")
    end # let
    let(:expected_message) do
      "expected #{matcher} to match #{actual}\n  message:\n#{received_message}"      
    end # let

    specify { expect(instance.matches? matcher).to be false }
    specify 'failure message' do
      instance.matches? matcher
      expect(instance.failure_message_for_should).to eq expected_message
    end # specify
  end # context
end # describe
