require 'spec_helper'

require 'rspec/sleeping_king_studios/configuration'

require 'rspec/sleeping_king_studios/matchers/core/construct'
require 'rspec/sleeping_king_studios/matchers/core/have_constant'
require 'rspec/sleeping_king_studios/matchers/core/have_reader'
require 'rspec/sleeping_king_studios/matchers/core/have_writer'

RSpec.describe RSpec::SleepingKingStudios::Configuration::Examples do
  subject(:instance) { described_class.new }

  describe '::new' do
    it { expect(described_class).to be_constructible.with(0).arguments }
  end

  describe '::MISSING_FAILURE_MESSAGE_HANDLERS' do
    it 'should define the constant' do
      expect(described_class)
        .to have_immutable_constant(:MISSING_FAILURE_MESSAGE_HANDLERS)
        .with_value(contain_exactly :exception, :ignore, :pending)
    end
  end

  describe '::STRING_FAILURE_MESSAGE_MATCH_OPTIONS' do
    it 'should define the constant' do
      expect(described_class)
        .to have_immutable_constant(:STRING_FAILURE_MESSAGE_MATCH_OPTIONS)
        .with_value(contain_exactly :exact, :substring)
    end
  end

  describe '#handle_missing_failure_message_with' do
    it 'should define the reader' do
      expect(instance)
        .to have_reader(:handle_missing_failure_message_with)
        .with_value(:pending)
    end
  end

  describe '#handle_missing_failure_message_with=' do
    it 'should define the writer' do
      expect(instance).to have_writer(:handle_missing_failure_message_with=)
    end

    describe 'with an invalid value' do
      let(:expected_message) do
        'unrecognized handler value -- must be in ' \
        "#{described_class::MISSING_FAILURE_MESSAGE_HANDLERS.join ', '}"
      end

      it 'should raise an error' do
        expect { instance.handle_missing_failure_message_with = :panic }
          .to raise_error ArgumentError, expected_message
      end
    end

    describe 'with a valid string value' do
      it 'should update the value' do
        expect { instance.handle_missing_failure_message_with = 'ignore' }
          .to change(instance, :handle_missing_failure_message_with)
          .to be :ignore
      end
    end

    describe 'with a valid symbol value' do
      it 'should update the value' do
        expect { instance.handle_missing_failure_message_with = :ignore }
          .to change(instance, :handle_missing_failure_message_with)
          .to be :ignore
      end
    end
  end

  describe '#match_string_failure_message_as' do
    it 'should define the reader' do
      expect(instance)
        .to have_reader(:match_string_failure_message_as)
        .with_value(:substring)
    end
  end

  describe '#match_string_failure_message_as=' do
    it 'should define the writer' do
      expect(instance).to have_writer(:match_string_failure_message_as=)
    end

    describe 'with an invalid value' do
      let(:expected_message) do
        'unrecognized value -- must be in ' \
        "#{described_class::STRING_FAILURE_MESSAGE_MATCH_OPTIONS.join ', '}"
      end

      it 'should raise an error' do
        expect { instance.match_string_failure_message_as = :anything }
          .to raise_error ArgumentError, expected_message
      end
    end

    describe 'with a valid string value' do
      it 'should update the value' do
        expect { instance.match_string_failure_message_as = 'exact' }
          .to change(instance, :match_string_failure_message_as)
          .to be :exact
      end
    end

    describe 'with a valid symbol value' do
      it 'should update the value' do
        expect { instance.match_string_failure_message_as = :exact }
          .to change(instance, :match_string_failure_message_as)
          .to be :exact
      end
    end
  end
end
