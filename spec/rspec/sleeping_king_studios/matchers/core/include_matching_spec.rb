# spec/rspec/sleeping_king_studios/matchers/core/include_matching_spec.rb

require 'rspec/sleeping_king_studios/spec_helper'

require 'rspec/sleeping_king_studios/matchers/core/include_matching'

describe 'include matching matcher' do
  let(:example_group) { RSpec::Core::ExampleGroup.new }

  specify { expect(example_group).to respond_to(:include_matching).with(0).arguments }

  <<-SCENARIOS
    When the object is enumerable,
      And a block is provided,
        And the object contains an item such that the block evaluates to true,
          Evaluates to true with should not message "expected not to include item matching".
        And the object does not contain an item such that the block evaluates to true,
          Evaluates to false with should message "expected to include item matching".
      And a block is not provided,
        Evaluates to false with should message "expected a block".
    When the object is not enumerable,
      Evaluates to false with should message "expected to be enumerable".
  SCENARIOS

  describe 'with an enumerable object' do
    let(:actual) { %w(foo bar baz) }

    describe 'with a block' do
      describe 'with a matching item' do
        let(:instance) { example_group.include_matching { |str| str =~ /foo/ } }

        specify do
          expect(instance).to pass_with_actual(actual).
            with_message "expected #{actual.inspect} not to include an item matching the block"
        end # specify
      end # describe

      pending
    end # describe

    describe 'without a block' do
      let(:instance) { example_group.include_matching }

      specify do
        expect(instance).to fail_with_actual(actual).
          with_message "must provide a block"
      end # specify
    end # describe
  end # describe

  describe 'with a non-enumerable object' do
    let(:actual)   { Object.new }
    let(:instance) { example_group.include_matching { true } }

    specify do
      expect(instance).to fail_with_actual(actual).
        with_message "expected #{actual.inspect} to be enumerable"
    end # specify
  end # describe
end # describe
