# spec/rspec/sleeping_king_studios/matchers/core/have_predicate_spec.rb

require 'rspec/sleeping_king_studios/spec_helper'
require 'rspec/sleeping_king_studios/examples/rspec_matcher_examples'

require 'rspec/sleeping_king_studios/matchers/core/be_boolean'
require 'rspec/sleeping_king_studios/matchers/core/have_predicate'
require 'rspec/sleeping_king_studios/concerns/wrap_examples'

RSpec.describe RSpec::SleepingKingStudios::Matchers::Core::HavePredicateMatcher do
  extend  RSpec::SleepingKingStudios::Concerns::WrapExamples
  include RSpec::SleepingKingStudios::Examples::RSpecMatcherExamples

  shared_context 'with loose predicate matching' do
    around(:each) do |example|
      begin
        config      = RSpec.configure { |config| config.sleeping_king_studios.matchers }
        prior_value = config.strict_predicate_matching

        config.strict_predicate_matching = false

        example.call
      ensure
        config.strict_predicate_matching = prior_value
      end # begin-ensure
    end # around each
  end # shared_context

  shared_context 'with strict predicate matching' do
    around(:each) do |example|
      begin
        config      = RSpec.configure { |config| config.sleeping_king_studios.matchers }
        prior_value = config.strict_predicate_matching

        config.strict_predicate_matching = true

        example.call
      ensure
        config.strict_predicate_matching = prior_value
      end # begin-ensure
    end # around each
  end # shared_context

  let(:example_group) { self }
  let(:property)      { :foo }

  it { expect(example_group).to respond_to(:have_predicate).with(1).arguments }
  it { expect(example_group.have_predicate property).to be_a described_class }

  let(:instance) { described_class.new property }

  describe '#with' do
    it { expect(instance).to respond_to(:with).with(1).arguments }
    it { expect(instance.with false).to be instance }
  end # describe with

  describe '#with_value' do
    it { expect(instance).to respond_to(:with_value).with(1).arguments }
    it { expect(instance.with_value false).to be instance }
  end # describe with

  describe 'with an object that responds to :property? with a non-boolean value' do
    let(:failure_message_when_negated) do
      "expected #{actual} not to respond to :#{property}?"
    end # let
    let(:actual) do
      pname  = property
      struct = Struct.new(property)

      struct.send :define_method, :"#{pname}?", ->() { send(pname) }

      struct.new(value)
    end # let
    let(:value) { nil }

    wrap_context 'with loose predicate matching' do
      include_examples 'should pass with a positive expectation'

      include_examples 'should fail with a negative expectation'
    end # wrap_context

    wrap_context 'with strict predicate matching' do
      let(:failure_message) do
        "expected #{actual} to respond to :#{property}? and return true or false, but returned #{value.inspect}"
      end # let

      include_examples 'should fail with a positive expectation'

      include_examples 'should pass with a negative expectation'
    end # wrap_context
  end # describe

  describe 'with an object that responds to :property? with a boolean value' do
    let(:failure_message_when_negated) do
      "expected #{actual} not to respond to :#{property}?"
    end # let
    let(:actual) do
      pname  = property
      struct = Struct.new(property)

      struct.send :define_method, :"#{pname}?", ->() { !!send(pname) }

      struct.new(value)
    end # let
    let(:value) { nil }

    include_examples 'should pass with a positive expectation'

    include_examples 'should fail with a negative expectation'

    describe 'with a property name with question mark' do
      let(:instance) { described_class.new :"#{property}?" }

      include_examples 'should pass with a positive expectation'

      include_examples 'should fail with a negative expectation'
    end # describe

    describe 'with a non-matching value as a value expectation' do
      let(:failure_message) do
        "expected #{actual} to respond to :#{property}? and return true, but returned #{!!value}"
      end # let
      let(:instance) { super().with_value(true) }

      include_examples 'should fail with a positive expectation'

      include_examples 'should pass with a negative expectation'
    end # describe

    describe 'with a matching value as a value expectation' do
      let(:failure_message_when_negated) do
        "expected #{actual} not to respond to :#{property}? and return #{value}"
      end # let
      let(:instance) { super().with_value(false) }

      include_examples 'should pass with a positive expectation'

      include_examples 'should fail with a negative expectation'
    end # describe

    describe 'with a failing matcher as a value expectation' do
      let(:matcher) { an_instance_of(String) }
      let(:failure_message) do
        "expected #{actual} to respond to :#{property}? and return #{matcher.description}, but returned #{!!value}"
      end # let
      let(:instance) { super().with_value(matcher) }

      include_examples 'should fail with a positive expectation'

      include_examples 'should pass with a negative expectation'
    end # describe

    describe 'with a passing matcher as a value expectation' do
      let(:matcher) { be_boolean }
      let(:failure_message_when_negated) do
        "expected #{actual} not to respond to :#{property}? and return #{matcher.description}"
      end # let
      let(:instance) { super().with_value(matcher) }

      include_examples 'should pass with a positive expectation'

      include_examples 'should fail with a negative expectation'
    end # describe

    describe 'with a non-boolean value as a value expectation' do
      wrap_context 'with loose predicate matching' do
        include_examples 'should pass with a positive expectation'

        include_examples 'should fail with a negative expectation'
      end # describe

      wrap_context 'with strict predicate matching' do
        it 'should raise an error' do
          expect { instance.with_value(nil) }.to raise_error ArgumentError, 'predicate must return true or false'
        end # it
      end # describe
    end # describe
  end # describe

  describe 'with an object that does not respond to :property?' do
    let(:failure_message) { "expected #{actual} to respond to :#{property}?, but did not respond to :#{property}?" }
    let(:actual)          { Object.new }

    include_examples 'should fail with a positive expectation'

    include_examples 'should pass with a negative expectation'

    describe 'with a property name with question mark' do
      let(:instance) { described_class.new :"#{property}?" }

      include_examples 'should fail with a positive expectation'

      include_examples 'should pass with a negative expectation'
    end # describe

    describe 'with a value expectation' do
      let(:failure_message) do
        "expected #{actual} to respond to :#{property}? and return false, but did not respond to :#{property}?"
      end # let
      let(:instance) { super().with_value(false) }

      include_examples 'should fail with a positive expectation'

      include_examples 'should pass with a negative expectation'
    end # describe
  end # describe
end # describe
