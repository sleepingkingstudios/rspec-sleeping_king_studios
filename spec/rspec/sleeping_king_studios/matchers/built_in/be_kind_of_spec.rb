# spec/rspec/sleeping_king_studios/matchers/built_in/be_kind_of_spec.rb

require 'rspec/sleeping_king_studios/spec_helper'
require 'rspec/sleeping_king_studios/examples/rspec_matcher_examples'

require 'rspec/sleeping_king_studios/matchers/built_in/be_kind_of'

describe RSpec::SleepingKingStudios::Matchers::BuiltIn::BeAKindOfMatcher do
  include RSpec::SleepingKingStudios::Examples::RSpecMatcherExamples

  let(:example_group) { self }
  let(:type)          { Object }

  it { expect(example_group).to respond_to(:be_kind_of).with(1).arguments }

  it { expect(example_group.be_kind_of type).to be_a described_class }

  it { expect(example_group).to respond_to(:be_a).with(1).arguments }

  it { expect(example_group.be_a type).to be_a described_class }

  let(:instance) { described_class.new type }

  <<-SCENARIOS
    When given nil,
      And actual is nil,
        Evaluates to true with should_not message "not to be nil".
      And actual is not nil,
        Evaluates to false with should message "to be nil".
    When given a Class,
      And actual is an instance of that class,
        Evaluates to true with should_not message "not to be a (type)".
      And actual is not an instance of that class,
        Evaluates to false with should message "to be a (type)".
    When given an array of types,
      And actual is an instance of one of the types,
        Evaluates to true with should_not message "not to be a type, type or type".
      And actual is not an instance of one of the types,
        Evalutes to false with should message "to be a type, type or type".
  SCENARIOS

  describe 'with nil' do
    let(:type) { nil }

    describe 'with a nil actual' do
      let(:failure_message_when_negated) do
        "expected #{actual.inspect} not to be nil"
      end # let
      let(:actual) { nil }

      expect_behavior 'passes with a positive expectation'

      expect_behavior 'fails with a negative expectation'
    end # it

    describe 'with a non-nil actual' do
      let(:failure_message) do
        "expected #{actual.inspect} to be nil"
      end # let
      let(:actual) { Object.new }

      expect_behavior 'fails with a positive expectation'

      expect_behavior 'passes with a negative expectation'
    end # it
  end # describe

  describe 'with a class' do
    let(:type) { Class.new }

    describe 'with an instance of the class' do
      let(:failure_message_when_negated) do
        "expected #{actual.inspect} not to be a #{type}"
      end # let
      let(:actual) { type.new }

      expect_behavior 'passes with a positive expectation'

      expect_behavior 'fails with a negative expectation'
    end # describe

    describe 'with a non-instance object' do
      let(:failure_message) do
        "expected #{actual.inspect} to be a #{type}"
      end # let
      let(:actual) { Object.new }

      expect_behavior 'fails with a positive expectation'

      expect_behavior 'passes with a negative expectation'
    end # describe
  end # describe

  describe 'with an array of types' do
    let(:type)         { [String, Symbol, nil] }
    let(:types_string) { "#{type[0..-2].map(&:inspect).join(", ")}, or #{type.last.inspect}" }

    describe 'with an instance of an array member' do
      let(:failure_message_when_negated) do
        "expected #{actual.inspect} not to be a #{types_string}"
      end # let
      let(:actual) { 'Greetings, programs!' }

      expect_behavior 'passes with a positive expectation'

      expect_behavior 'fails with a negative expectation'
    end # describe

    describe 'with a object that is not an instance of an array member' do
      let(:failure_message) do
        "expected #{actual.inspect} to be a #{types_string}"
      end # let
      let(:actual) { Object.new }

      expect_behavior 'fails with a positive expectation'

      expect_behavior 'passes with a negative expectation'
    end # describe
  end # describe
end # describe
