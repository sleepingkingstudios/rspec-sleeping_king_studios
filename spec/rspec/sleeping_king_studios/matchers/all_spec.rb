# spec/rspec/sleeping_king_studios/matchers/all_spec.rb

require 'rspec/sleeping_king_studios/spec_helper'
require 'rspec/sleeping_king_studios/matchers/all'

RSpec.describe RSpec::SleepingKingStudios::Matchers do
  describe '#be_kind_of Matcher' do
    let(:passing_actual) { "I'm a String!" }
    let(:failing_actual) { Object.new }

    describe 'with a single type' do
      it { expect(passing_actual).to be_a String }

      it { expect(failing_actual).not_to be_a String }
    end # describe

    describe 'with an array of types' do
      it { expect(passing_actual).to be_a [String, Array, nil] }

      it { expect(failing_actual).not_to be_a [String, Array, nil] }
    end # describe
  end # describe

  describe '#have_errors Matcher' do
    let(:passing_actual) { FactoryGirl.build :active_model }
    let(:failing_actual) { FactoryGirl.build :active_model, :foo => '100110', :bar => 'The Fox And The Hound' }

    it { expect(passing_actual).to have_errors }

    it { expect(failing_actual).not_to have_errors }

    describe 'with an attribute' do
      let(:attribute) { :foo }

      it { expect(passing_actual).to have_errors.on(attribute) }

      it { expect(failing_actual).not_to have_errors.on(attribute) }

      describe 'with a message' do
        it { expect(passing_actual).to have_errors.on(attribute).with_message("not to be nil") }

        it { expect(failing_actual).not_to have_errors.on(attribute).with_message("not to be nil") }
      end # describe

      describe 'with multiple messages' do
        it { expect(passing_actual).to have_errors.on(attribute).with_messages("not to be nil", "to be 1s and 0s") }

        it { expect(failing_actual).not_to have_errors.on(attribute).with_messages("not to be nil", 'to be 1s and 0s') }
      end # describe
    end # describe
  end # describe
end # describe
