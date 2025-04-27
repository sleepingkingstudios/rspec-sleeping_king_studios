# spec/rspec/sleeping_king_studios/matchers/built_in/be_kind_of_matcher_spec.rb

require 'rspec/sleeping_king_studios/examples/rspec_matcher_examples'

require 'rspec/sleeping_king_studios/matchers/built_in/be_kind_of_matcher'

RSpec.describe RSpec::SleepingKingStudios::Matchers::BuiltIn::BeAKindOfMatcher do
  include RSpec::SleepingKingStudios::Examples::RSpecMatcherExamples

  it { expect(described_class).to be < RSpec::Matchers::Composable }

  let(:instance) { described_class.new type }

  describe '#description' do
    let(:type) { nil }

    it { expect(instance).to respond_to(:description).with(0).arguments }

    context 'with nil' do
      let(:expected) { 'be nil' }

      it { expect(instance.description).to be == expected }
    end # context

    context 'with a class' do
      let(:type)     { String }
      let(:expected) { "be a #{type.name}" }

      it { expect(instance.description).to be == expected }
    end # context

    context 'with an array of types' do
      let(:type)     { [String, Symbol, nil] }
      let(:expected) { "be a String, Symbol, or nil" }

      it { expect(instance.description).to be == expected }
    end # context
  end # describe

  describe '#matches?' do
    describe 'with nil' do
      let(:type) { nil }

      describe 'with a nil actual' do
        let(:failure_message_when_negated) do
          "expected #{actual.inspect} not to be nil"
        end # let
        let(:actual) { nil }

        include_examples 'should pass with a positive expectation'

        include_examples 'should fail with a negative expectation'
      end # it

      describe 'with a non-nil actual' do
        let(:failure_message) do
          "expected #{actual.inspect} to be nil"
        end # let
        let(:actual) { Object.new }

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end # it
    end # describe

    describe 'with a class' do
      let(:type) { Class.new }

      describe 'with an instance of the class' do
        let(:failure_message_when_negated) do
          "expected #{actual.inspect} not to be a #{type}"
        end # let
        let(:actual) { type.new }

        include_examples 'should pass with a positive expectation'

        include_examples 'should fail with a negative expectation'
      end # describe

      describe 'with a non-instance object' do
        let(:failure_message) do
          "expected #{actual.inspect} to be a #{type}"
        end # let
        let(:actual) { Object.new }

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
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

        include_examples 'should pass with a positive expectation'

        include_examples 'should fail with a negative expectation'
      end # describe

      describe 'with a object that is not an instance of an array member' do
        let(:failure_message) do
          "expected #{actual.inspect} to be a #{types_string}"
        end # let
        let(:actual) { Object.new }

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end # describe
    end # describe
  end # describe
end # describe
