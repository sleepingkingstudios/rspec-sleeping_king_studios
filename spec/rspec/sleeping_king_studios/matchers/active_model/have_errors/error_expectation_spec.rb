# spec/rspec/sleeping_king_studios/matchers/active_model/have_errors/message_spec.rb

require 'rspec/sleeping_king_studios/spec_helper'
require 'rspec/sleeping_king_studios/matchers/core/construct'
require 'rspec/sleeping_king_studios/matchers/core/have_property'
require 'rspec/sleeping_king_studios/matchers/core/have_reader'

require 'active_model'

require 'rspec/sleeping_king_studios/matchers/active_model/have_errors/error_expectation'
require 'rspec/sleeping_king_studios/matchers/active_model/have_errors/message_expectation'

describe RSpec::SleepingKingStudios::Matchers::ActiveModel::HaveErrors::ErrorExpectation do
  specify { expect(described_class).to construct.with(1..3).arguments }

  let(:attribute) { :foo }
  let(:instance)  { described_class.new attribute }

  specify '#attribute' do
    expect(instance).to have_property(:attribute).with(attribute)
  end # specify

  specify '#expected' do
    expect(instance).to have_property(:expected).with(true)
  end # specify

  specify '#received' do
    expect(instance).to have_property(:received).with(false)
  end # specify

  describe '#messages' do
    specify 'has reader' do
      expect(instance).to have_reader(:messages).with([])
    end # specify

    context do
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

      specify '#expected' do
        expect(instance.messages.expected).to be == messages.select { |msg| msg.expected }
      end # specify

      specify '#missing' do
        expect(instance.messages.missing).to be == messages.select { |msg| msg.expected && !msg.received }
      end # specify

      specify '#received' do
        expect(instance.messages.received).to be == messages.select { |msg| msg.received }
      end # specify
    end # context
  end # describe
end # describe
