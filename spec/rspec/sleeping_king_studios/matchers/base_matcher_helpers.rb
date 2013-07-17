# spec/rspec/sleeping_king_studios/matchers/base_matcher_spec.rb

require 'rspec/sleeping_king_studios/matchers/base_matcher'
require 'rspec/sleeping_king_studios/matchers/core/be_boolean'

module RSpec::SleepingKingStudios::Matchers
  module BaseMatcherHelpers
    shared_examples_for ::RSpec::SleepingKingStudios::Matchers::BaseMatcher do
      let(:actual) { defined?(super) ? super() : nil }

      describe '#matches?' do
        specify { expect(instance).to respond_to(:matches?).with(1).arguments }
        specify { expect(instance.matches? actual).to be_boolean }
      end # describe

      describe 'description' do
        specify { expect(instance).to respond_to(:description).with(0).arguments }
        specify { expect(instance.description).to be_a String }
      end # describe

      describe 'failure_message_for_should' do
        specify { expect(instance).to respond_to(:failure_message_for_should).with(0).arguments }
        specify 'returns a String' do
          instance.matches? actual
          expect(instance.failure_message_for_should).to be_a String
        end # specify
      end # describe

      describe 'failure_message_for_should_not' do
        specify { expect(instance).to respond_to(:failure_message_for_should_not).with(0).arguments }
        specify 'returns a String' do
          instance.matches? actual
          expect(instance.failure_message_for_should_not).to be_a String
        end # specify
      end # describe

      specify 'returns true on successful match' do
        original_matches = instance.method(:matches?)
        allow(instance).to receive(:matches?) do |actual|
          original_matches.call actual
          true
        end # receive
        expect(instance).to pass_with_actual actual
      end # specify

      specify 'returns false on an unsuccessful match' do
        original_matches = instance.method(:matches?)
        allow(instance).to receive(:matches?) do |actual|
          original_matches.call actual
          false
        end # receive
        expect(instance).to fail_with_actual actual
      end # specify
    end # shared examples
  end # module
end # module
