# spec/rspec/sleeping_king_studios/matchers/active_model/have_errors/error_expectation_spec.rb

require 'rspec/sleeping_king_studios/spec_helper'
require 'rspec/sleeping_king_studios/matchers/core/construct'
require 'rspec/sleeping_king_studios/matchers/core/have_property'
require 'rspec/sleeping_king_studios/matchers/core/have_reader'

require 'active_model'

require 'rspec/sleeping_king_studios/matchers/active_model/have_errors/error_expectation'
require 'rspec/sleeping_king_studios/matchers/active_model/have_errors/message_expectation'

describe RSpec::SleepingKingStudios::Matchers::ActiveModel::HaveErrors::ErrorExpectation do
  it { expect(described_class).to construct.with(1..3).arguments }

  let(:attribute) { :foo }
  let(:instance)  { described_class.new attribute }

  describe '#attribute' do
    it { expect(instance).to have_property(:attribute).with(attribute) }
  end # describe

  describe '#expected' do
    it { expect(instance).to have_property(:expected).with(true) }
  end # describe

  describe '#received' do
    it { expect(instance).to have_property(:received).with(false) }
  end # describe

  describe '#messages' do
    it { expect(instance).to have_reader(:messages).with([]) }

    context 'with defined messages' do
      let(:messages) do
        [ double(:expected => true,  :received => true),
          double(:expected => true,  :received => false),
          double(:expected => false, :received => true),
          double(:expected => false, :received => false)
        ] # end array
      end # let

      before(:each) do
        instance.messages[0...4] = messages
      end # before each

      describe '#expected' do
        it { expect(instance.messages.expected).to be == messages.select { |msg| msg.expected } }
      end # describe

      describe '#missing' do
        it { expect(instance.messages.missing).to be == messages.select { |msg| msg.expected && !msg.received } }
      end # describe

      describe '#received' do
        it { expect(instance.messages.received).to be == messages.select { |msg| msg.received } }
      end # describe
    end # context
  end # describe
end # describe
