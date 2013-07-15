# spec/rspec/sleeping_king_studios/matchers/base_matcher_spec.rb

require 'rspec/sleeping_king_studios/matchers/base_matcher'
require 'rspec/sleeping_king_studios/matchers/built_in/be_kind_of'

module RSpec::SleepingKingStudios::Matchers
  module BaseMatcherHelpers
    shared_examples_for RSpec::SleepingKingStudios::Matchers::BaseMatcher do
      describe '#matches?' do
        specify { expect(instance).to respond_to(:matches?).with(1).arguments }
        specify { expect(instance.matches? nil).to be_a [true, false] }
      end # describe

      describe 'description' do
        specify { expect(instance).to respond_to(:description).with(0).arguments }
        specify { expect(instance.description).to be_a String }
      end # describe

      describe 'failure_message_for_should' do
        specify { expect(instance).to respond_to(:failure_message_for_should).with(0).arguments }
        specify { expect(instance.failure_message_for_should).to be_a String }
      end # describe

      describe 'failure_message_for_should_not' do
        specify { expect(instance).to respond_to(:failure_message_for_should_not).with(0).arguments }
        specify { expect(instance.failure_message_for_should_not).to be_a String }
      end # describe

      specify 'returns true on successful match' do
        allow(instance).to receive(:matches?).and_return(true)
        expect(instance).to pass_with_actual nil
      end # specify

      specify 'returns false on an unsuccessful match' do
        allow(instance).to receive(:matches?).and_return(false)
        expect(instance).to fail_with_actual nil
      end # specify
    end # shared examples
  end # module
end # module
