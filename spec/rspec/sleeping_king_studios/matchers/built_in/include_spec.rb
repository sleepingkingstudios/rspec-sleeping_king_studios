# spec/rspec/sleeping_king_studios/matchers/built_in/include_spec.rb

require 'rspec/sleeping_king_studios/spec_helper'
require 'rspec/sleeping_king_studios/matchers/base_matcher_helpers'
require 'rspec/sleeping_king_studios/matchers/built_in/respond_to'

require 'rspec/sleeping_king_studios/matchers/built_in/include'

describe RSpec::SleepingKingStudios::Matchers::BuiltIn::IncludeMatcher do
  include RSpec::SleepingKingStudios::Matchers::BaseMatcherHelpers

  let(:example_group) { self }
  let(:expectations)  { "String" }
  
  specify { expect(example_group).to respond_to(:include).with(1..9001).arguments }
  specify { expect(example_group.include expectations).to be_a described_class }

  let(:instance) { described_class.new expectations }

  it_behaves_like RSpec::SleepingKingStudios::Matchers::BaseMatcher do
    let(:actual)   { [] }
    let(:instance) { super().tap { |matcher| matcher.matches? actual } }
  end # shared behavior

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

  context 'with a non-enumerable object' do
    let(:actual) { Object.new }

    specify 'fails' do
      expect(instance).to fail_with_actual(actual).
        with_message "expected #{actual.inspect} to respond to :include?"
    end # specify
  end # context

  context 'with a Hash' do
    let(:actual) { { :foo => "foo", :bar => "bar", :baz => "baz" } }

    context 'with a matching block expectation' do
      let(:expectations) { ->((_, str)){ str =~ /ba/ } }
      let(:instance) { described_class.new &expectations }

      specify 'passes' do
        expect(instance).to pass_with_actual(actual).
          with_message "expected #{actual.inspect} not to include matching block"
      end # specify
    end # context

    context 'with a non-matching proc expectation' do
      let(:expectations) { ->((_, str)){ str =~ /xy/ } }
      let(:instance) { described_class.new &expectations }

      specify 'fails' do
        expect(instance).to fail_with_actual(actual).
          with_message "expected #{actual.inspect} to include matching block"
      end # specify
    end # context

    context 'with a matching proc expectation' do
      let(:expectations) { ->((_, str)){ str =~ /ba/ } }

      specify 'passes' do
        expect(instance).to pass_with_actual(actual).
          with_message "expected #{actual.inspect} not to include matching block"
      end # specify
    end # context

    context 'with a non-matching proc expectation' do
      let(:expectations) { ->((_, str)){ str =~ /xy/ } }

      specify 'fails' do
        expect(instance).to fail_with_actual(actual).
          with_message "expected #{actual.inspect} to include matching block"
      end # specify
    end # context
  end # context

  context 'with an Array' do
    let(:actual) { %w(foo bar baz) }

    context 'with a matching block expectation' do
      let(:expectations) { ->(str){ str =~ /ba/ } }
      let(:instance) { described_class.new &expectations }

      specify 'passes' do
        expect(instance).to pass_with_actual(actual).
          with_message "expected #{actual.inspect} not to include matching block"
      end # specify
    end # context

    context 'with a non-matching proc expectation' do
      let(:expectations) { ->(str){ str =~ /xy/ } }
      let(:instance) { described_class.new &expectations }

      specify 'fails' do
        expect(instance).to fail_with_actual(actual).
          with_message "expected #{actual.inspect} to include matching block"
      end # specify
    end # context

    context 'with a matching proc expectation' do
      let(:expectations) { ->(str){ str =~ /ba/ } }

      specify 'passes' do
        expect(instance).to pass_with_actual(actual).
          with_message "expected #{actual.inspect} not to include matching block"
      end # specify
    end # context

    context 'with a non-matching proc expectation' do
      let(:expectations) { ->(str){ str =~ /xy/ } }

      specify 'fails' do
        expect(instance).to fail_with_actual(actual).
          with_message "expected #{actual.inspect} to include matching block"
      end # specify
    end # context
  end # context
end # describe
