# spec/rspec/sleeping_king_studios/matchers/core/have_writer_matcher_spec.rb

require 'spec_helper'
require 'rspec/sleeping_king_studios/examples/rspec_matcher_examples'

require 'rspec/sleeping_king_studios/matchers/core/have_writer_matcher'

RSpec.describe RSpec::SleepingKingStudios::Matchers::Core::HaveWriterMatcher do
  include RSpec::SleepingKingStudios::Examples::RSpecMatcherExamples

  let(:property) { :foo }
  let(:instance) { described_class.new property }

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

    describe 'with an object responding to :property' do
      let(:value) { 42 }
      let(:actual) do
        Struct.new(property).new(value).tap do |struct|
          allow(struct).to receive(:inspect).and_return("<struct>")
        end # tap
      end # let

      let(:failure_message_when_negated) do
        super() << ", but responded to :#{property}="
      end # let

      include_examples 'should pass with a positive expectation'

      include_examples 'should fail with a negative expectation'
    end # describe
  end # describe
end # describe
