# spec/rspec/sleeping_king_studios/matchers/active_model/have_errors/message_expectation_spec.rb

require 'rspec/sleeping_king_studios/matchers/core/construct'
require 'rspec/sleeping_king_studios/matchers/core/have_property'

require 'rspec/sleeping_king_studios/matchers/active_model/have_errors/message_expectation'

RSpec.describe RSpec::SleepingKingStudios::Matchers::ActiveModel::HaveErrors::MessageExpectation do
  it { expect(described_class).to construct.with(1..3).arguments }

  let(:message)  { "can't be blank" }
  let(:instance) { described_class.new message }

  describe '#message' do
    it { expect(instance).to have_property(:message).with(message) }
  end # describe

  describe '#expected' do
    it { expect(instance).to have_property(:expected).with(true) }
  end # describe

  describe '#received' do
    it { expect(instance).to have_property(:received).with(false) }
  end # describe
end # describe
