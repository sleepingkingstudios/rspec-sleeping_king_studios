# spec/rspec/sleeping_king_studios/matchers/active_model/have_errors_matcher_spec.rb

require 'active_model'

require 'rspec/sleeping_king_studios/examples/rspec_matcher_examples'
require 'rspec/sleeping_king_studios/matchers/built_in/respond_to'
require 'rspec/sleeping_king_studios/matchers/core/have_aliased_method'

require 'rspec/sleeping_king_studios/matchers/active_model/have_errors_matcher'

RSpec.describe RSpec::SleepingKingStudios::Matchers::ActiveModel::HaveErrorsMatcher do
  include RSpec::SleepingKingStudios::Examples::RSpecMatcherExamples

  let(:instance) { described_class.new }

  it { expect(described_class).to be < RSpec::Matchers::Composable }

  describe '#description' do
    let(:expected) { 'have errors' }

    it { expect(instance).to respond_to(:description).with(0).arguments }

    it { expect(instance.description).to be == expected }

    context 'with an attribute' do
      let(:attribute) { :title }
      let(:instance)  { super().on(attribute) }
      let(:expected)  { "#{super()} on #{attribute.inspect}" }

      it { expect(instance.description).to be == expected }

      context 'with one message' do
        let(:message)  { 'is invalid' }
        let(:instance) { super().with_message message }
        let(:expected) { "#{super()} with message #{message.inspect}" }

        it { expect(instance.description).to be == expected }
      end # context

      context 'with two messages' do
        let(:messages) { ['is invalid', "can't be blank"] }
        let(:instance) { super().with_messages *messages }
        let(:expected) do
          "#{super()} with messages #{messages.first.inspect} and "\
          "#{messages.last.inspect}"
        end # let

        it { expect(instance.description).to be == expected }
      end # context

      context 'with many messages' do
        let(:messages) do
          [
            'is not a number',
            'is not an integer',
            'must be odd',
            'must be greater than 0'
          ] # end array
        end # let
        let(:instance) { super().with_messages *messages }
        let(:expected) do
          "#{super()} with messages "\
          "#{messages[0...-1].map(&:inspect).join(', ')}, and "\
          "#{messages.last.inspect}"
        end # let

        it { expect(instance.description).to be == expected }
      end # context
    end # context
  end # describe

  describe '#matches?' do
    it { expect(instance).to respond_to(:matches?).with(1).arguments }

    describe 'with a non-record object' do
      let(:failure_message) do
        "expected #{actual.inspect} to respond to :valid?"
      end # let
      let(:failure_message_when_negated) do
        "expected #{actual.inspect} to respond to :valid?"
      end # let
      let(:actual) { Object.new }

      include_examples 'fails with a positive expectation'

      include_examples 'fails with a negative expectation'
    end # describe

    describe 'with a valid record' do
      let(:failure_message) do
        "expected #{actual.inspect} to have errors"
      end # let
      let(:attributes) { { foo: '10010011101', bar: 'bar' } }
      let(:actual)     { Spec::Models::ExampleModel.new(attributes) }

      include_examples 'should fail with a positive expectation'

      include_examples 'should pass with a negative expectation'
    end # describe

    describe 'with an invalid record' do
      let(:actual) { Spec::Models::ExampleModel.new }
      let(:errors) { actual.tap(&:valid?).errors.messages }
      let(:received_errors_message) do
        "\n  received errors:" + errors.map do |attr, ary|
          "\n    #{attr}: " + ary.map(&:inspect).join(", ")
        end.join # map
      end # let
      let(:failure_message_when_negated) do
        "expected #{actual.inspect} not to have errors#{received_errors_message}"
      end # let

      include_examples 'should pass with a positive expectation'

      include_examples 'should fail with a negative expectation'

      describe 'with an attribute with no errors' do
        let(:attribute) { :baz }
        let(:instance)  { super().on(attribute) }
        let(:expected_errors_message) do
          "\n  expected errors:\n    #{attribute}: (any)"
        end # let
        let(:failure_message) do
          "expected #{actual.inspect} to have errors#{expected_errors_message}#{received_errors_message}"
        end # let

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
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

        include_examples 'should pass with a positive expectation'

        include_examples 'should fail with a negative expectation'

        context 'with a correct message' do
          let(:expected_error) { "not to be nil" }
          let(:instance)       { super().with_message(expected_error) }
          let(:expected_errors_message) do
            "\n  expected errors:\n    #{attribute}: #{expected_error.inspect}"
          end # let

          include_examples 'should pass with a positive expectation'

          include_examples 'should fail with a negative expectation'
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

          include_examples 'should fail with a positive expectation'

          include_examples 'should pass with a negative expectation'
        end # context
      end # context
    end # let
  end # describe

  describe '#on' do
    it { expect(instance).to respond_to(:on).with(1).arguments }

    it { expect(instance.on :foo).to be instance }
  end # describe

  describe '#with_message' do
    it { expect(instance).to respond_to(:with_message).with(1).arguments }

    it { expect { instance.with_message 'xyzzy' }.to raise_error ArgumentError,
      /no attribute specified for error message/i }

    it { expect(instance.on(:foo).with_message 'xyzzy').to be instance }
  end # describe

  describe '#with_messages' do
    it { expect(instance).to respond_to(:with_messages).with_unlimited_arguments }

    it { expect(instance).to have_aliased_method(:with_messages).as(:with) }

    it { expect { instance.with_messages 'bar', /baz/ }.to raise_error ArgumentError,
      /no attribute specified for error message/i }

    it { expect(instance.on(:foo).with_messages 'bar', /baz/).to be instance }
  end # describe
end # describe
