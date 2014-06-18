# spec/rspec/sleeping_king_studios/matchers/built_in/include_spec.rb

require 'rspec/sleeping_king_studios/spec_helper'
require 'rspec/sleeping_king_studios/matchers/built_in/respond_to'

require 'rspec/sleeping_king_studios/matchers/built_in/include'

describe RSpec::SleepingKingStudios::Matchers::BuiltIn::IncludeMatcher do
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
    let(:actual) { Object.new }

    it 'fails' do
      expect(instance).to fail_with_actual(actual).
        with_message "expected #{actual.inspect} to respond to :include?"
    end # it
  end # describe

  describe 'with a Hash' do
    let(:actual)        { { :foo => "foo", :bar => "bar", :baz => "baz" } }
    let(:actual_string) { actual.inspect.gsub(/(\S)=>(\S)/, '\1 => \2') }

    describe 'with a matching block expectation' do
      let(:expectations) { ->((_, str)){ str =~ /ba/ } }
      let(:instance) { described_class.new &expectations }

      it 'passes' do
        expect(instance).to pass_with_actual(actual).
          with_message "expected #{actual_string} not to include an item matching the block"
      end # it
    end # describe

    describe 'with a non-matching proc expectation' do
      let(:expectations) { ->((_, str)){ str =~ /xy/ } }
      let(:instance) { described_class.new &expectations }

      it 'fails' do
        expect(instance).to fail_with_actual(actual).
          with_message "expected #{actual_string} to include an item matching the block"
      end # it
    end # describe

    describe 'with a matching proc expectation' do
      let(:expectations) { ->((_, str)){ str =~ /ba/ } }

      it 'passes' do
        expect(instance).to pass_with_actual(actual).
          with_message "expected #{actual_string} not to include an item matching the block"
      end # it
    end # describe

    describe 'with a non-matching proc expectation' do
      let(:expectations) { ->((_, str)){ str =~ /xy/ } }

      it 'fails' do
        expect(instance).to fail_with_actual(actual).
          with_message "expected #{actual_string} to include an item matching the block"
      end # it
    end # describe
  end # describe

  describe 'with an Array' do
    let(:actual) { %w(foo bar baz) }

    describe 'with a matching block expectation' do
      let(:expectations) { ->(str){ str =~ /ba/ } }
      let(:instance) { described_class.new &expectations }

      it 'passes' do
        expect(instance).to pass_with_actual(actual).
          with_message "expected #{actual.inspect} not to include an item matching the block"
      end # it
    end # describe

    describe 'with a non-matching proc expectation' do
      let(:expectations) { ->(str){ str =~ /xy/ } }
      let(:instance) { described_class.new &expectations }

      it 'fails' do
        expect(instance).to fail_with_actual(actual).
          with_message "expected #{actual.inspect} to include an item matching the block"
      end # it
    end # describe

    describe 'with a matching proc expectation' do
      let(:expectations) { ->(str){ str =~ /ba/ } }

      it 'passes' do
        expect(instance).to pass_with_actual(actual).
          with_message "expected #{actual.inspect} not to include an item matching the block"
      end # it
    end # describe

    describe 'with a non-matching proc expectation' do
      let(:expectations) { ->(str){ str =~ /xy/ } }

      it 'fails' do
        expect(instance).to fail_with_actual(actual).
          with_message "expected #{actual.inspect} to include an item matching the block"
      end # it
    end # describe
  end # describe
end # describe
