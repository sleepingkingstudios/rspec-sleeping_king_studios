# frozen_string_literals: true

require 'rspec/sleeping_king_studios/concerns/example_constants'
require 'rspec/sleeping_king_studios/concerns/wrap_examples'
require 'rspec/sleeping_king_studios/matchers/core/construct'
require 'rspec/sleeping_king_studios/matchers/core/have_predicate'
require 'rspec/sleeping_king_studios/matchers/core/have_reader'
require 'rspec/sleeping_king_studios/support/value_spy'

RSpec.describe RSpec::SleepingKingStudios::Support::ValueSpy do
  extend RSpec::SleepingKingStudios::Concerns::ExampleConstants
  extend RSpec::SleepingKingStudios::Concerns::WrapExamples

  shared_context 'when the value has changed' do
    let(:changed_value) { 'changed value'.freeze }

    before(:example) do
      instance # Force evaluation of the memoized helper.

      object.value = changed_value
    end
  end

  shared_context 'when the value hash has changed' do
    let(:initial_value) { Spec::FuelTank.new(liquid_fuel: 9.0, oxidizer: 11.0) }
    let(:changed_value) { Spec::FuelTank.new(liquid_fuel: 9.0, oxidizer: 11.0) }

    example_class 'Spec::FuelTank' do |klass|
      klass.class_eval do
        def initialize(liquid_fuel:, oxidizer:)
          @liquid_fuel = liquid_fuel
          @oxidizer    = oxidizer
        end

        attr_reader :liquid_fuel, :oxidizer

        def ==(other)
          other.is_a?(self.class) &&
            other.liquid_fuel == liquid_fuel &&
            other.oxidizer == oxidizer
        end
      end
    end

    before(:example) do
      instance # Force evaluation of the memoized helper.

      object.value = changed_value
    end
  end

  shared_context 'when the value is modified' do
    let(:initial_value) do
      [
        {
          name:      'Hamburger',
          price:     '10.0',
          modifiers: [
            {
              name:  'Bacon',
              price: '1.0'
            },
            {
              name:  'Guacamole',
              price: '2.0'
            }
          ]
        },
        {
          name:      'Onion Rings',
          price:     '5.0',
          modifiers: []
        },
        {
          name:      'Vanilla Milkshake',
          price:     '5.0',
          modifiers: []
        }
      ]
    end
    let!(:initial_hash)    { initial_value.hash }
    let!(:initial_inspect) { initial_value.inspect }

    before(:example) do
      instance # Force evaluation of the memoized helper.

      initial_value.dig(0, :modifiers) << { name: 'Medium Well', price: '0.0' }
    end
  end

  shared_examples 'when the spy is defined with a block' do
    let(:instance) { described_class.new { object.value.upcase } }
  end

  subject(:instance) { described_class.new(object, method_name) }

  let(:method_name)   { :value }
  let(:initial_value) { 'initial value'.freeze }
  let(:object_class)  { Spec::CustomStruct }
  let(:object)        { object_class.new(initial_value) }

  example_constant 'Spec::CustomStruct' do
    Struct.new(method_name).tap do |struct|
      struct.send(:define_method, :to_s) { 'Spec::CustomStruct' }
    end
  end

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

    wrap_context 'when the value hash has changed' do
      it { expect(instance.changed?).to be true }
    end

    wrap_context 'when the value is modified' do
      it { expect(instance.changed?).to be true }
    end
  end

  describe '#current_value' do
    it { expect(instance).to respond_to(:current_value).with(0).arguments }

    it { expect(instance.current_value).to be initial_value }

    wrap_context 'when the value has changed' do
      it { expect(instance.current_value).to be changed_value }
    end

    wrap_examples 'when the spy is defined with a block' do
      it { expect(instance.current_value).to be == initial_value.upcase }

      wrap_context 'when the value has changed' do
        it { expect(instance.current_value).to be == changed_value.upcase }
      end
    end
  end

  describe '#description' do
    let(:expected) { "#{object_class}##{method_name}" }

    it { expect(instance).to have_reader(:description).with_value(expected) }

    context 'when the receiver is a Module' do
      let(:object)   { object_class }
      let(:expected) { "#{object_class}.#{method_name}" }

      before(:example) do
        Spec::CustomStruct.singleton_class.send(:define_method, method_name) {}
      end

      it { expect(instance.description).to be == expected }
    end

    wrap_examples 'when the spy is defined with a block' do
      it { expect(instance.description).to be == 'result' }
    end
  end

  describe '#initial_hash' do
    it { expect(instance).to respond_to(:initial_hash).with(0).arguments }

    it { expect(instance.initial_hash).to be initial_value.hash }

    wrap_context 'when the value has changed' do
      it { expect(instance.initial_hash).to be initial_value.hash }
    end

    wrap_context 'when the value hash has changed' do
      it { expect(instance.initial_hash).to be initial_value.hash }
    end

    wrap_context 'when the value is modified' do
      it { expect(instance.initial_hash).to be initial_hash }
    end

    wrap_examples 'when the spy is defined with a block' do
      it { expect(instance.initial_hash).to be == initial_value.upcase.hash }

      wrap_context 'when the value has changed' do
        it { expect(instance.initial_hash).to be == initial_value.upcase.hash }
      end
    end
  end

  describe '#initial_inspect' do
    it { expect(instance).to respond_to(:initial_inspect).with(0).arguments }

    it { expect(instance.initial_inspect).to be == initial_value.inspect }

    wrap_context 'when the value has changed' do
      it { expect(instance.initial_inspect).to be == initial_value.inspect }
    end

    wrap_context 'when the value hash has changed' do
      it { expect(instance.initial_inspect).to be == initial_value.inspect }
    end

    wrap_context 'when the value is modified' do
      it { expect(instance.initial_inspect).to be == initial_inspect }
    end

    wrap_examples 'when the spy is defined with a block' do
      it 'should cache the value of #inspect' do
        expect(instance.initial_inspect).to be == initial_value.upcase.inspect
      end

      wrap_context 'when the value has changed' do
        it 'should cache the value of #inspect' do
          expect(instance.initial_inspect).to be == initial_value.upcase.inspect
        end
      end
    end
  end

  describe '#initial_value' do
    it { expect(instance).to respond_to(:initial_value).with(0).arguments }

    it { expect(instance.initial_value).to be initial_value }

    wrap_context 'when the value has changed' do
      it { expect(instance.initial_value).to be initial_value }
    end

    wrap_context 'when the value hash has changed' do
      it { expect(instance.initial_value).to be initial_value }
    end

    wrap_context 'when the value is modified' do
      it { expect(instance.initial_value).to be initial_value }
    end

    wrap_examples 'when the spy is defined with a block' do
      it { expect(instance.initial_value).to be == initial_value.upcase }

      wrap_context 'when the value has changed' do
        it { expect(instance.initial_value).to be == initial_value.upcase }
      end
    end
  end
end
