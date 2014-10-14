# spec/rspec/sleeping_king_studios/matchers/core/have_writer_spec.rb

require 'rspec/sleeping_king_studios/spec_helper'
require 'rspec/sleeping_king_studios/examples/rspec_matcher_examples'

require 'rspec/sleeping_king_studios/matchers/core/have_writer'

describe RSpec::SleepingKingStudios::Matchers::Core::HaveWriterMatcher do
  include RSpec::SleepingKingStudios::Examples::RSpecMatcherExamples

  let(:example_group) { self }
  let(:property)      { :foo }
  
  it { expect(example_group).to respond_to(:have_writer).with(1).arguments }
  it { expect(example_group.have_writer property).to be_a described_class }

  let(:instance) { described_class.new property }

  <<-SCENARIOS
    When the object responds to :property=,
      Evaluates to true with should_not message "expected not to respond to".
    When the object does not respond to :property=,
      Evaluates to false with should message "expected to respond to".
  SCENARIOS

  describe 'with an object that responds to :property=' do
    let(:failure_message_when_negated) do
      "expected #{actual} not to respond to :#{property}="
    end # let
    let(:value)  { 42 }
    let(:actual) { Struct.new(property).new }

    include_examples 'passes with a positive expectation'

    include_examples 'fails with a negative expectation'
  end # describe

  describe 'with an object that does not respond to :property=' do
    let(:failure_message) do
      "expected #{actual} to respond to :#{property}=, but did not respond to :#{property}="
    end # let
    let(:actual) { Object.new }

    include_examples 'fails with a positive expectation'

    include_examples 'passes with a negative expectation'
  end # describe
end # describe
