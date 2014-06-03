# spec/rspec/sleeping_king_studios/matchers/base_matcher_spec.rb

require 'rspec/sleeping_king_studios/matchers/base_matcher'

module RSpec::SleepingKingStudios::Matchers
  module BaseMatcherHelpers
    shared_examples_for ::RSpec::SleepingKingStudios::Matchers::BaseMatcher do
      let(:actual) { defined?(super) ? super() : Object.new }

      describe '#actual' do
        it { expect(instance).to respond_to(:actual).with(0).arguments }
      end # describe

      describe '#description' do
        it { expect(instance).to respond_to(:description).with(0).arguments }
        it { expect(instance.description).to be_a String }
      end # describe

      describe '#failure_message' do
        it { expect(instance).to respond_to(:failure_message).with(0).arguments }
        it 'returns a String' do
          instance.matches? actual
          expect(instance.failure_message).to be_a String
        end # it
      end # describe

      describe '#failure_message_when_negated' do
        it { expect(instance).to respond_to(:failure_message_when_negated).with(0).arguments }
        it 'returns a String' do
          instance.matches? actual
          expect(instance.failure_message_when_negated).to be_a String
        end # it
      end # describe

      describe '#matches?' do
        it { expect(instance).to respond_to(:matches?).with(1).arguments }
        it { expect([true, false]).to include(instance.matches? actual) }
      end # describe

      it 'returns true on successful match' do
        original_matches = instance.method(:matches?)
        allow(instance).to receive(:matches?) do |actual|
          original_matches.call actual
          true
        end # receive
        expect(instance.matches? actual).to be true
      end # it

      it 'returns false on an unsuccessful match' do
        original_matches = instance.method(:matches?)
        allow(instance).to receive(:matches?) do |actual|
          original_matches.call actual
          false
        end # receive
        expect(instance.matches? actual).to be false
      end # it
    end # shared examples
  end # module
end # module
