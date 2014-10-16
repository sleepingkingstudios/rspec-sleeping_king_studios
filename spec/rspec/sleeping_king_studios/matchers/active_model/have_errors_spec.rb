# spec/rspec/sleeping_king_studios/matchers/active_model/have_errors_spec.rb

require 'active_model'

require 'rspec/sleeping_king_studios/spec_helper'
require 'rspec/sleeping_king_studios/examples/rspec_matcher_examples'
require 'rspec/sleeping_king_studios/matchers/built_in/respond_to'

require 'rspec/sleeping_king_studios/matchers/active_model/have_errors'

describe RSpec::SleepingKingStudios::Matchers::ActiveModel::HaveErrorsMatcher do
  include RSpec::SleepingKingStudios::Examples::RSpecMatcherExamples

  let(:example_group) { self }

  it { expect(example_group).to respond_to(:have_errors).with(0).arguments }

  it { expect(example_group.have_errors).to be_a described_class }

  let(:instance) { described_class.new }

  describe "#on" do
    it { expect(instance).to respond_to(:on).with(1).arguments }

    it { expect(instance.on :foo).to be instance }
  end # describe

  describe '#with' do
    it { expect(instance).to respond_to(:with).with(1..9001).arguments }

    it { expect { instance.with 'bar', /baz/ }.to raise_error ArgumentError,
      /no attribute specified for error message/i }

    it { expect(instance.on(:foo).with 'bar', /baz/).to be instance }
  end # describe

  describe "#with_message" do
    it { expect(instance).to respond_to(:with_message).with(1).arguments }

    it { expect { instance.with_message 'xyzzy' }.to raise_error ArgumentError,
      /no attribute specified for error message/i }

    it { expect(instance.on(:foo).with_message 'xyzzy').to be instance }
  end # describe

  describe '#with_messages' do
    it { expect(instance).to respond_to(:with_messages).with(1..9001).arguments }

    it { expect { instance.with_messages 'bar', /baz/ }.to raise_error ArgumentError,
      /no attribute specified for error message/i }

    it { expect(instance.on(:foo).with_messages 'bar', /baz/).to be instance }
  end # describe

  <<-SCENARIOS
    When given a non-record object,
      Evaluates to false with should message "expected to respond to valid".
    When given a valid record,
      Evaluates to false with should message "expected to have errors".
    When given an invalid record,
      And when not given an attribute,
        Evaluates to true with should_not message "expected not to have errors, but had errors hash"
      And when given an attribute with no errors,
        Evaluates to false with should message "expected to have errors on".
      And when given an attribute with errors,
        And when not given a message,
          Evaluates to true with should_not message "expected not to have errors on, but had errors on with messages")
        And when given a correct message,
          Evaluates to true with should_not message "expected not to have errors on with message"
        And when given an incorrect message,
          Evaluates to false with should message "expected to have errors on with message".
  SCENARIOS

  describe 'with a non-record object' do
    let(:failure_message) do
      'to respond to :valid?'
    end # let
    let(:failure_message_when_negated) do
      'to respond to :valid?'
    end # let
    let(:actual) { Object.new }

    expect_behavior 'fails with a positive expectation'

    expect_behavior 'fails with a negative expectation'
  end # describe

  describe 'with a valid record' do
    let(:failure_message) do
      'to have errors'
    end # let
    let(:actual) { FactoryGirl.build :active_model, :foo => '10010011101', :bar => 'bar' }

    expect_behavior 'fails with a positive expectation'

    expect_behavior 'passes with a negative expectation'
  end # describe

  describe 'with an invalid record' do
    let(:actual) { FactoryGirl.build :active_model }
    let(:errors) { actual.tap(&:valid?).errors.messages }
    let(:received_errors_message) do
      "\n  received errors:" + errors.map do |attr, ary|
        "\n    #{attr}: " + ary.map(&:inspect).join(", ")
      end.join # map
    end # let
    let(:failure_message_when_negated) do
      "expected #{actual.inspect} not to have errors#{received_errors_message}"
    end # let

    expect_behavior 'passes with a positive expectation'

    expect_behavior 'fails with a negative expectation'

    describe 'with an attribute with no errors' do
      let(:attribute) { :baz }
      let(:instance)  { super().on(attribute) }
      let(:expected_errors_message) do
        "\n  expected errors:\n    #{attribute}: (any)"
      end # let
      let(:failure_message) do
        "expected #{actual.inspect} to have errors#{expected_errors_message}#{received_errors_message}"
      end # let

      expect_behavior 'fails with a positive expectation'

      expect_behavior 'passes with a negative expectation'
    end # context

    context 'with an attribute with errors' do
      let(:attribute) { :bar }
      let(:instance)  { super().on(attribute) }
      let(:expected_errors_message) do
        "\n  expected errors:\n    #{attribute}: (none)"
      end # let
      let(:failure_message_when_negated) do
        "expected #{actual.inspect} not to have errors#{expected_errors_message}#{received_errors_message}"
      end # let

      expect_behavior 'passes with a positive expectation'

      expect_behavior 'fails with a negative expectation'

      context 'with a correct message' do
        let(:expected_error) { "not to be nil" }
        let(:instance)       { super().with_message(expected_error) }
        let(:expected_errors_message) do
          "\n  expected errors:\n    #{attribute}: #{expected_error.inspect}"
        end # let

        expect_behavior 'passes with a positive expectation'

        expect_behavior 'fails with a negative expectation'
      end # context

      context 'with an incorrect message' do
        let(:expected_error) { "to be 1s and 0s" }
        let(:instance)       { super().with_message(expected_error) }
        let(:expected_errors_message) do
          "\n  expected errors:\n    #{attribute}: #{expected_error.inspect}"
        end # let
        let(:failure_message) do
          "expected #{actual.inspect} to have errors#{expected_errors_message}#{received_errors_message}"
        end # let

        expect_behavior 'fails with a positive expectation'

        expect_behavior 'passes with a negative expectation'
      end # context
    end # context
  end # context
end # describe
