# spec/rspec/sleeping_king_studios/matchers/built_in/include_spec.rb

require 'rspec/sleeping_king_studios/spec_helper'
require 'rspec/sleeping_king_studios/examples/rspec_matcher_examples'
require 'rspec/sleeping_king_studios/matchers/built_in/respond_to'

require 'rspec/sleeping_king_studios/matchers/built_in/include'

describe RSpec::SleepingKingStudios::Matchers::BuiltIn::IncludeMatcher do
  include RSpec::SleepingKingStudios::Examples::RSpecMatcherExamples

  let(:example_group) { self }
  let(:expectations)  { "String" }

  it { expect(example_group).to respond_to(:include).with(1..9001).arguments }
  it { expect(example_group.include expectations).to be_a described_class }

  let(:instance) { described_class.new expectations }

  <<-SCENARIOS
    When given a non-enumerable actual,
      Evaluates to false with should message "to respond to include?".
    When given a Hash actual,
      And the parameter is a block,
        And the actual includes an element for which the block evaluates to true,
          Evaluates to true with should_not message "not to include".
        And the actual does not include an element for which the block evaluates to true,
          Evaluates to false with should message "to include".
      And the parameter is a proc,
        And the actual includes an element for which the proc evaluates to true,
          Evaluates to true with should_not message "not to include".
        And the actual does not include an element for which the proc evaluates to true,
          Evaluates to false with should message "to include".
    When given an Array actual,
      And the parameter is a proc,
        And the actual includes an element for which the proc evaluates to true,
          Evaluates to true with should_not message "not to include".
        And the actual does not include an element for which the proc evaluates to true,
          Evaluates to false with should message "to include".
  SCENARIOS

  describe 'with a non-enumerable object' do
    let(:failure_message) { 'but it does not respond to `include?`' }
    let(:failure_message_when_negated) { failure_message }
    let(:actual) { Object.new }

    include_examples 'fails with a positive expectation'

    include_examples 'fails with a negative expectation'
  end # describe

  describe 'with a Hash' do
    let(:actual)        { { :foo => "foo", :bar => "bar", :baz => "baz" } }
    let(:actual_string) { actual.inspect.gsub(/(\S)=>(\S)/, '\1 => \2') }

    describe 'with a matching block expectation' do
      let(:failure_message_when_negated) { "expected #{actual_string} not to include an item matching the block" }
      let(:expectations) { ->((_, str)){ str =~ /ba/ } }
      let(:instance) { described_class.new &expectations }

      include_examples 'passes with a positive expectation'

      include_examples 'fails with a negative expectation'
    end # describe

    describe 'with a non-matching proc expectation' do
      let(:failure_message) { "expected #{actual_string} to include an item matching the block" }
      let(:expectations) { ->((_, str)){ str =~ /xy/ } }
      let(:instance) { described_class.new &expectations }

      include_examples 'fails with a positive expectation'

      include_examples 'passes with a negative expectation'
    end # describe

    describe 'with a matching proc expectation' do
      let(:failure_message_when_negated) { "expected #{actual_string} not to include an item matching the block" }
      let(:expectations) { ->((_, str)){ str =~ /ba/ } }

      include_examples 'passes with a positive expectation'

      include_examples 'fails with a negative expectation'
    end # describe

    describe 'with a non-matching proc expectation' do
      let(:failure_message) { "expected #{actual_string} to include an item matching the block" }
      let(:expectations) { ->((_, str)){ str =~ /xy/ } }

      include_examples 'fails with a positive expectation'

      include_examples 'passes with a negative expectation'
    end # describe
  end # describe

  describe 'with an Array' do
    let(:actual) { %w(foo bar baz) }

    describe 'with a matching block expectation' do
      let(:failure_message_when_negated) { "expected #{actual.inspect} not to include an item matching the block" }
      let(:expectations) { ->(str){ str =~ /ba/ } }
      let(:instance) { described_class.new &expectations }

      include_examples 'passes with a positive expectation'

      include_examples 'fails with a negative expectation'
    end # describe

    describe 'with a non-matching block expectation' do
      let(:failure_message) { "expected #{actual.inspect} to include an item matching the block" }
      let(:expectations) { ->(str){ str =~ /xy/ } }
      let(:instance) { described_class.new &expectations }

      include_examples 'fails with a positive expectation'

      include_examples 'passes with a negative expectation'
    end # describe

    describe 'with a matching proc expectation' do
      let(:failure_message_when_negated) { "expected #{actual.inspect} not to include an item matching the block" }
      let(:expectations) { ->(str){ str =~ /ba/ } }

      include_examples 'passes with a positive expectation'

      include_examples 'fails with a negative expectation'
    end # describe

    describe 'with a non-matching proc expectation' do
      let(:failure_message) { "expected #{actual.inspect} to include an item matching the block" }
      let(:expectations) { ->(str){ str =~ /xy/ } }

      include_examples 'fails with a positive expectation'

      include_examples 'passes with a negative expectation'
    end # describe
  end # describe
end # describe
