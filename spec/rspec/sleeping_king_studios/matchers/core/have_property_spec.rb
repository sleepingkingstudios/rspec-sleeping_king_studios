# spec/rspec/sleeping_king_studios/matchers/core/have_property_spec.rb

require 'spec_helper'
require 'rspec/sleeping_king_studios/examples/rspec_matcher_examples'

require 'rspec/sleeping_king_studios/matchers/core/have_property'

describe RSpec::SleepingKingStudios::Matchers::Core::HavePropertyMatcher do
  include RSpec::SleepingKingStudios::Examples::RSpecMatcherExamples

  let(:example_group) { self }
  let(:property)    { :foo }

  it { expect(example_group).to respond_to(:have_property).with(1).arguments }
  it { expect(example_group.have_property property).to be_a described_class }

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
    When the object responds to :property and :property=,
      And there is no expected value set,
        Evaluates to true with should_not message "expected not to respond to".
      And there is an expected value set,
        And the expected value matches the actual value,
          Evaluates to true with should_not message "expected not to respond to with value".
        And the expected value does not match the actual value,
          Evaluates to false with should message "unexpected value for, expected, received".
    When the object responds to :property xor property=,
      Evaluates to false with should message "expected to respond to".
    When the object does not respond to :property and :property=,
      Evaluates to false with should message "expected to respond to and".
  SCENARIOS

  describe 'with an object responding to :property and :property=' do
    let(:value) { 42 }
    let(:actual) do
      Struct.new(property).new(value).tap do |struct|
        allow(struct).to receive(:inspect).and_return("<struct>")
      end # tap
    end # let

    describe 'with no expected value' do
      let(:failure_message_when_negated) do
        "expected #{actual.inspect} not to respond to :#{property} or"\
        " :#{property}=, but responded to :#{property} and :#{property}="
      end # let

      include_examples 'passes with a positive expectation'

      include_examples 'fails with a negative expectation'
    end # describe

    describe 'with a correct expected value' do
      let(:failure_message_when_negated) do
        "expected #{actual.inspect} not to respond to :#{property} or"\
        " :#{property}= and return #{value.inspect}, but responded to"\
        " :#{property} and :#{property}= and returned #{value.inspect}"
      end # let
      let(:instance) { super().with(value) }

      include_examples 'passes with a positive expectation'

      include_examples 'fails with a negative expectation'
    end # describe

    describe 'with a matcher that matches the value' do
      let(:matcher) { an_instance_of(Fixnum) }
      let(:failure_message_when_negated) do
        "expected #{actual.inspect} not to respond to :#{property} or"\
        " :#{property}= and return #{matcher.description}, but responded to"\
        " :#{property} and :#{property}= and returned #{value.inspect}"
      end # let
      let(:instance) { super().with(matcher) }

      include_examples 'passes with a positive expectation'

      include_examples 'fails with a negative expectation'
    end # describe

    describe 'with an incorrect expected value' do
      let(:failure_message_when_negated) do
        "expected #{actual.inspect} not to respond to :#{property} or"\
        " :#{property}= and return #{15151}, but responded to"\
        " :#{property} and :#{property}="
      end # let
      let(:failure_message) do
        "expected #{actual.inspect} to respond to :#{property} and"\
        " :#{property}= and return #{15151}, but returned #{value.inspect}"
      end # let
      let(:instance) { super().with(15151) }

      include_examples 'fails with a positive expectation'

      include_examples 'fails with a negative expectation'
    end # describe

    describe 'with a matcher that does not match the value' do
      let(:matcher) { an_instance_of(String) }
      let(:failure_message_when_negated) do
        "expected #{actual.inspect} not to respond to :#{property} or"\
        " :#{property}= and return #{matcher.description}, but responded to"\
        " :#{property} and :#{property}="
      end # let
      let(:failure_message) do
        "expected #{actual.inspect} to respond to :#{property} and"\
        " :#{property}= and return #{matcher.description}, but returned"\
        " #{value.inspect}"
      end # let
      let(:instance) { super().with(matcher) }

      include_examples 'fails with a positive expectation'

      include_examples 'fails with a negative expectation'
    end # describe
  end # describe

  describe 'with an object responding only to :property' do
    let(:failure_message_when_negated) do
        "expected #{actual.inspect} not to respond to :#{property} or"\
        " :#{property}=, but responded to :#{property}"
      end # let
    let(:failure_message) do
      "expected #{actual.inspect} to respond to :#{property} and"\
        " :#{property}=, but did not respond to :#{property}="
    end # let
    let(:actual) { Class.new.tap { |klass| klass.send :attr_reader, property }.new }

    include_examples 'fails with a positive expectation'

    include_examples 'fails with a negative expectation'
  end # describe

  describe 'with an object responding only to :property=' do
    let(:failure_message_when_negated) do
        "expected #{actual.inspect} not to respond to :#{property} or"\
        " :#{property}=, but responded to :#{property}="
      end # let
    let(:failure_message) do
      "expected #{actual.inspect} to respond to :#{property} and"\
        " :#{property}=, but did not respond to :#{property}"
    end # let
    let(:actual) { Class.new.tap { |klass| klass.send :attr_writer, property }.new }

    include_examples 'fails with a positive expectation'

    include_examples 'fails with a negative expectation'
  end # describe

  describe 'with an object not responding to :property or :property=' do
    let(:failure_message) do
      "expected #{actual.inspect} to respond to :#{property} and"\
        " :#{property}=, but did not respond to :#{property} or"\
        " :#{property}="
    end # let
    let(:actual) { Object.new }

    include_examples 'fails with a positive expectation'

    include_examples 'passes with a negative expectation'
  end # describe
end # describe
