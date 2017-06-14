# spec/rspec/sleeping_king_studios/matchers/core/have_writer_matcher_spec.rb

require 'spec_helper'
require 'rspec/sleeping_king_studios/examples/rspec_matcher_examples'
require 'rspec/sleeping_king_studios/matchers/built_in/respond_to'
require 'rspec/sleeping_king_studios/matchers/core/construct'
require 'rspec/sleeping_king_studios/matchers/core/have_predicate'
require 'rspec/sleeping_king_studios/matchers/core/have_writer_matcher'

RSpec.describe RSpec::SleepingKingStudios::Matchers::Core::HaveWriterMatcher do
  include RSpec::SleepingKingStudios::Examples::RSpecMatcherExamples

  let(:property) { :foo }
  let(:instance) { described_class.new property }

  describe '::new' do
    it 'should define the constructor' do
      expect(described_class).
        to be_constructible.
        with(1).arguments.
        and_keywords(:allow_private)
    end # it
  end # describe

  describe '#allow_private?' do
    it { expect(instance).to have_predicate(:allow_private?).with_value(false) }

    context 'when the matcher matches private readers' do
      let(:instance) { described_class.new(property, :allow_private => true) }

      it { expect(instance.allow_private?).to be true }
    end # context
  end # describe

  describe '#description' do
    let(:expected) { "have writer #{property.inspect}" }

    it { expect(instance).to respond_to(:description).with(0).arguments }

    it { expect(instance.description).to be == expected }
  end # describe

  describe '#matches?' do
    let(:failure_message) do
      "expected #{actual.inspect} to respond to #{property.inspect}="
    end # let
    let(:failure_message_when_negated) do
      "expected #{actual.inspect} not to respond to #{property.inspect}="
    end # let

    describe 'with an object that does not respond to :property=' do
      let(:failure_message) do
        super() <<
          ", but did not respond to :#{property}="
      end # let
      let(:actual) { Object.new }

      include_examples 'should fail with a positive expectation'

      include_examples 'should pass with a negative expectation'
    end # describe

    describe 'with an object responding to :property=' do
      let(:value) { 42 }
      let(:actual) do
        Struct.new(property) do
          def inspect
            '<struct>'
          end # method inspect
        end.
          new(value)
      end # let

      let(:failure_message_when_negated) do
        super() << ", but responded to :#{property}="
      end # let

      include_examples 'should pass with a positive expectation'

      include_examples 'should fail with a negative expectation'
    end # describe

    describe 'with an object with a private #property= writer' do
      let(:value) { 42 }
      let(:actual) do
        Struct.new(property) do
          def inspect
            '<struct>'
          end # method inspect
        end.
          tap { |klass| klass.send(:private, :"#{property}=") }.
          new(value)
      end # let
      let(:failure_message) do
        super() <<
          ", but did not respond to :#{property}="
      end # let
      let(:failure_message_when_negated) do
        super() << ", but responded to :#{property}="
      end # let

      include_examples 'should fail with a positive expectation'

      include_examples 'should pass with a negative expectation'

      context 'when the matcher matches private readers' do
        let(:instance) { described_class.new(property, :allow_private => true) }

        include_examples 'should pass with a positive expectation'

        include_examples 'should fail with a negative expectation'
      end # context
    end # describe
  end # describe
end # describe
