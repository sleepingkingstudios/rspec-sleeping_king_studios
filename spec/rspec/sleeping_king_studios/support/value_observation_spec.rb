require 'spec_helper'

require 'rspec/sleeping_king_studios/concerns/wrap_examples'
require 'rspec/sleeping_king_studios/matchers/core/construct'
require 'rspec/sleeping_king_studios/matchers/core/have_predicate'
require 'rspec/sleeping_king_studios/matchers/core/have_reader'

require 'rspec/sleeping_king_studios/support/value_observation'

RSpec.describe RSpec::SleepingKingStudios::Support::ValueObservation do
  extend RSpec::SleepingKingStudios::Concerns::WrapExamples

  shared_context 'when the value has changed' do
    let(:changed_value) { 'changed value'.freeze }

    before(:example) do
      instance # Force evaluation of the memoized helper.

      object.value = changed_value
    end
  end

  shared_examples 'when the observation is defined with a block' do
    let(:instance) { described_class.new { object.value.upcase } }
  end

  subject(:instance) { described_class.new(object, method_name) }

  let(:method_name)   { :value }
  let(:initial_value) { 'initial value'.freeze }
  let(:object)        { Struct.new(method_name).new(initial_value) }

  describe '::new' do
    it 'should define the constructor' do
      expect(described_class)
        .to be_constructible
        .with(0..2).arguments
        .and_a_block
    end
  end

  describe '#changed?' do
    it { expect(instance).to have_predicate(:changed?).with_value(false) }

    wrap_context 'when the value has changed' do
      it { expect(instance.changed?).to be true }
    end
  end

  describe '#current_value' do
    it { expect(instance).to respond_to(:current_value).with(0).arguments }

    it { expect(instance.current_value).to be initial_value }

    wrap_context 'when the value has changed' do
      it { expect(instance.current_value).to be changed_value }
    end

    wrap_examples 'when the observation is defined with a block' do
      it { expect(instance.current_value).to be == initial_value.upcase }

      wrap_context 'when the value has changed' do
        it { expect(instance.current_value).to be == changed_value.upcase }
      end
    end
  end

  describe '#description' do
    it { expect(instance).to have_reader(:description).with("##{method_name}") }

    wrap_examples 'when the observation is defined with a block' do
      it { expect(instance.description).to be == 'result' }
    end
  end

  describe '#initial_value' do
    it { expect(instance).to respond_to(:initial_value).with(0).arguments }

    it { expect(instance.initial_value).to be initial_value }

    wrap_context 'when the value has changed' do
      it { expect(instance.initial_value).to be initial_value }
    end

    wrap_examples 'when the observation is defined with a block' do
      it { expect(instance.initial_value).to be == initial_value.upcase }

      wrap_context 'when the value has changed' do
        it { expect(instance.initial_value).to be == initial_value.upcase }
      end
    end
  end
end
