# spec/rspec/sleeping_king_studios/matchers/active_model/have_errors/message_spec.rb

require 'rspec/sleeping_king_studios/spec_helper'
require 'rspec/sleeping_king_studios/matchers/core/construct'
require 'rspec/sleeping_king_studios/matchers/core/have_property'

require 'rspec/sleeping_king_studios/matchers/active_model/have_errors/message_expectation'

describe RSpec::SleepingKingStudios::Matchers::ActiveModel::HaveErrors::MessageExpectation do
  specify { expect(described_class).to construct.with(1..3).arguments }

  let(:message)  { "can't be blank" }
  let(:instance) { described_class.new message }

  specify '#message' do
    expect(instance).to have_property(:message).with(message)
  end # specify

  specify '#expected' do
    expect(instance).to have_property(:expected).with(true)
  end # specify

  specify '#received' do
    expect(instance).to have_property(:received).with(false)
  end # specify
end # describe