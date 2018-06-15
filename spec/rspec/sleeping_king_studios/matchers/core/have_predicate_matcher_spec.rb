# spec/rspec/sleeping_king_studios/matchers/core/have_predicate_matcher_spec.rb

require 'spec_helper'
require 'rspec/sleeping_king_studios/concerns/wrap_examples'
require 'rspec/sleeping_king_studios/examples/rspec_matcher_examples'
require 'rspec/sleeping_king_studios/matchers/core/alias_method'
require 'rspec/sleeping_king_studios/matchers/core/be_boolean'

require 'rspec/sleeping_king_studios/matchers/core/have_predicate_matcher'

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

  let(:property) { :foo }
  let(:instance) { described_class.new property }

  describe '#description' do
    it { expect(instance).to respond_to(:description).with(0).arguments }

    it { expect(instance.description).to be == "have predicate #{property.inspect}?" }

    context 'when the given property name has a question mark' do
      let(:property) { :foo? }

      it { expect(instance.description).to be == "have predicate #{property.inspect}" }
    end
  end # describe

  describe '#matches?' do
    let(:failure_message) do
      message = "expected #{actual.inspect} to respond to #{property.inspect}?"

      message << expected_string

      message
    end # let
    let(:failure_message_when_negated) do
      message = "expected #{actual.inspect} not to respond to #{property.inspect}?"

      message << expected_string

      message
    end # let
    let(:expected_string) do
      return '' unless defined?(expected_value)

      message = ' and return '

      if expected_value.respond_to?(:matches?) && expected_value.respond_to?(:description)
        message << expected_value.description
      else
        message << expected_value.inspect
      end # if-else

      message
    end # let

    describe 'with an object that does not respond to :property?' do
      let(:failure_message) do
          super() << ", but did not respond to :#{property}?"
        end # let
      let(:actual) { Object.new }

      include_examples 'should fail with a positive expectation'

      include_examples 'should pass with a negative expectation'

      describe 'with a property name with question mark' do
        let(:instance) { described_class.new :"#{property}?" }

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end # describe

      describe 'with a value expectation' do
        let(:expected_value) { false }
        let(:instance)       { super().with_value(expected_value) }

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end # describe
    end # describe

    describe 'with an object that responds to :property? with a non-boolean value' do
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
          super() << ", but returned #{value.inspect}"
        end # let
        let(:expected_value) { a_boolean }

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end # wrap_context
    end # describe

    describe 'with an object that responds to :property? with a boolean value' do
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
          super() << ", but returned #{!!value}"
        end # let
        let(:expected_value) { true }
        let(:instance)       { super().with_value(expected_value) }

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end # describe

      describe 'with a matching value as a value expectation' do
        let(:expected_value) { false }
        let(:instance)       { super().with_value(expected_value) }

        include_examples 'should pass with a positive expectation'

        include_examples 'should fail with a negative expectation'
      end # describe

      describe 'with a failing matcher as a value expectation' do
        let(:failure_message) do
          super() << ", but returned #{!!value}"
        end # let
        let(:expected_value) { an_instance_of(String) }
        let(:instance)       { super().with_value(expected_value) }

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end # describe

      describe 'with a passing matcher as a value expectation' do
        let(:expected_value)  { be_boolean }
        let(:instance)        { super().with_value(expected_value) }

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
  end # describe

  describe '#with_value' do
    it { expect(instance).to respond_to(:with_value).with(1).arguments }

    it { expect(instance).to alias_method(:with_value).as(:with) }

    it { expect(instance.with_value false).to be instance }
  end # describe with
end # describe
