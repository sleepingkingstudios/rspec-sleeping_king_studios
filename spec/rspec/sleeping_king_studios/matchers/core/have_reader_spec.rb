# spec/rspec/sleeping_king_studios/matchers/core/have_reader_spec.rb

require 'rspec/sleeping_king_studios/spec_helper'
require 'rspec/sleeping_king_studios/examples/rspec_matcher_examples'

require 'rspec/sleeping_king_studios/matchers/core/have_reader'

describe RSpec::SleepingKingStudios::Matchers::Core::HaveReaderMatcher do
  include RSpec::SleepingKingStudios::Examples::RSpecMatcherExamples

  let(:example_group) { self }
  let(:property)      { :foo }
  
  it { expect(example_group).to respond_to(:have_reader).with(1).arguments }
  it { expect(example_group.have_reader property).to be_a described_class }

  let(:instance) { described_class.new property }

  describe '#with' do
    it { expect(instance).to respond_to(:with).with(1).arguments }
    it { expect(instance.with 5).to be instance }
  end # describe with

  describe '#with_value' do
    it { expect(instance).to respond_to(:with_value).with(1).arguments }
    it { expect(instance.with_value 5).to be instance }
  end # describe with

  <<-SCENARIOS
    When the object responds to :property,
      And there is no expected value set,
        Evaluates to true with should_not message "expected not to respond to".
      And there is an expected value set,
        And the expected value matches the actual value,
          Evaluates to true with should_not message "expected not to respond to with value".
        And the expected value does not match the actual value,
          Evaluates to false with should message "unexpected value for, expected, received".
    When the object does not respond to :property,
      Evaluates to false with should message "expected to respond to".
  SCENARIOS

  describe 'with an object responding to :property' do
    let(:value)  { 42 }
    let(:actual) { Struct.new(property).new(value) }

    describe 'with no value set' do
      let(:failure_message_when_negated) do
        "expected #{actual} not to respond to :#{property}"
      end # let

      include_examples 'passes with a positive expectation'

      include_examples 'fails with a negative expectation'
    end # describe

    describe 'with a correct value set' do
      let(:failure_message_when_negated) do
        "expected #{actual} not to respond to :#{property} and return #{value}"
      end # let
      let(:instance) { super().with(value) }

      include_examples 'passes with a positive expectation'

      include_examples 'fails with a negative expectation'
    end # describe

    describe 'with a matcher that matches the value' do
      let(:matcher) { an_instance_of(Fixnum) }
      let(:failure_message_when_negated) do
        "expected #{actual} not to respond to :#{property} and return #{matcher.description}"
      end # let
      let(:instance) { super().with(matcher) }

      include_examples 'passes with a positive expectation'

      include_examples 'fails with a negative expectation'
    end # describe

    describe 'with an incorrect value set' do
      let(:failure_message) do
        "expected #{actual} to respond to :#{property} and return nil, but returned #{value.inspect}"
      end # let
      let(:instance) { super().with(nil) }

      include_examples 'fails with a positive expectation'

      include_examples 'passes with a negative expectation'
    end # describe

    describe 'with a matcher that does not match the value' do
      let(:matcher) { an_instance_of(String) }
      let(:failure_message) do
        "expected #{actual} to respond to :#{property} and return #{matcher.description}, but returned #{value.inspect}"
      end # let
      let(:instance) { super().with(matcher) }

      include_examples 'fails with a positive expectation'

      include_examples 'passes with a negative expectation'
    end # describe
  end # describe

  describe 'with an object that does not respond to :property' do
    let(:failure_message) { "expected #{actual} to respond to :#{property}, but did not respond to :#{property}" }
    let(:actual) { Object.new }

    include_examples 'fails with a positive expectation'

    include_examples 'passes with a negative expectation'

    describe 'with a value set' do
      let(:failure_message) do
        "expected #{actual} to respond to :#{property} and return #{value.inspect}, but did not respond to :#{property}"
      end # let
      let(:value)    { 42 }
      let(:instance) { super().with(value) }

      include_examples 'fails with a positive expectation'

      include_examples 'passes with a negative expectation'
    end # describe
  end # describe
end # describe
