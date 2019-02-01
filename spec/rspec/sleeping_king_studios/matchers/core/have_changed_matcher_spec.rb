# frozen_string_literals: true

require 'spec_helper'

require 'rspec/sleeping_king_studios/concerns/example_constants'
require 'rspec/sleeping_king_studios/concerns/wrap_examples'
require 'rspec/sleeping_king_studios/examples/rspec_matcher_examples'
require 'rspec/sleeping_king_studios/matchers/core/have_changed_matcher'

RSpec.describe RSpec::SleepingKingStudios::Matchers::Core::HaveChangedMatcher do
  extend  RSpec::SleepingKingStudios::Concerns::ExampleConstants
  extend  RSpec::SleepingKingStudios::Concerns::WrapExamples
  include RSpec::SleepingKingStudios::Examples::RSpecMatcherExamples

  shared_context 'when the value has changed' do
    let(:changed_value) { defined?(super()) ? super() : 'changed value'.freeze }

    before(:example) do
      actual # Force evaluation of the memoized helper.

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
      actual # Force evaluation of the memoized helper.

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
    let!(:cached_value) do
      tools.array.deep_dup(initial_value)
    end
    let(:tools) { SleepingKingStudios::Tools::Toolbelt.instance }

    before(:example) do
      actual # Force evaluation of the memoized helper.

      initial_value.dig(0, :modifiers) << { name: 'Medium Well', price: '0.0' }
    end
  end

  shared_context 'when the matcher has a non-matching expected initial value' do
    let(:expected_initial_value) { 'other value'.freeze }
    let(:instance)               { super().from(expected_initial_value) }
  end

  shared_context 'when the matcher has a matching expected initial value' do
    let(:instance) { super().from(initial_value) }
  end

  shared_context 'when the matcher has a non-matching expected current value' do
    let(:expected_current_value) { 'other value'.freeze }
    let(:instance)               { super().to(expected_current_value) }
  end

  shared_context 'when the matcher has a matching expected current value' do
    let(:changed_value) { 'changed value'.freeze }
    let(:instance)      { super().to(changed_value) }
  end

  shared_context 'when the matcher has an invalid expected difference' do
    let(:expected_difference) { 'difference'.freeze }
    let(:instance)            { super().by(expected_difference) }
  end

  shared_context 'when the matcher has a non-matching expected difference' do
    let(:initial_value)       { 3 }
    let(:changed_value)       { 5 }
    let(:expected_difference) { 10 }
    let(:actual_difference)   { changed_value - initial_value }
    let(:instance)            { super().by(expected_difference) }
  end

  shared_context 'when the matcher has a matching expected difference' do
    let(:initial_value)       { 3 }
    let(:changed_value)       { 5 }
    let(:expected_difference) { 2 }
    let(:instance)            { super().by(expected_difference) }
  end

  shared_context 'when the matcher has multiple non-matching expectations' do
    let(:initial_value)          { 3 }
    let(:changed_value)          { 5 }
    let(:expected_difference)    { 10 }
    let(:expected_current_value) { 4 }
    let(:actual_difference)      { changed_value - initial_value }
    let(:instance) do
      super().to(expected_current_value).by(expected_difference)
    end
  end

  subject(:instance) { described_class.new }

  describe '#by' do
    it { expect(instance).to respond_to(:by).with(1).argument }

    it { expect(instance.by 1).to be instance }
  end

  describe '#description' do
    let(:expected) { 'have changed' }

    it { expect(instance).to respond_to(:description).with(0).arguments }

    it { expect(instance.description).to be == expected }

    context 'when the matcher has an expected initial value' do
      let(:expected_initial_value) { 'other value'.freeze }
      let(:instance)               { super().from(expected_initial_value) }
      let(:expected) do
        super() << " from #{expected_initial_value.inspect}"
      end

      it { expect(instance.description).to be == expected }
    end

    context 'when the matcher has an expected current value' do
      let(:expected_current_value) { 'changed value'.freeze }
      let(:instance)               { super().to(expected_current_value) }
      let(:expected) do
        super() << " to #{expected_current_value.inspect}"
      end

      it { expect(instance.description).to be == expected }
    end

    context 'when the matcher has an expected difference' do
      let(:expected_difference) { 'expected difference'.freeze }
      let(:instance)            { super().by(expected_difference) }
      let(:expected) do
        super() << " by #{expected_difference.inspect}"
      end

      it { expect(instance.description).to be == expected }
    end

    context 'when the matcher has multiple expectations' do
      let(:expected_initial_value) { 'other value'.freeze }
      let(:expected_current_value) { 'changed value'.freeze }
      let(:expected_difference)    { 'expected difference'.freeze }
      let(:instance) do
        super()
          .from(expected_initial_value)
          .to(expected_current_value)
          .by(expected_difference)
      end
      let(:expected) do
        super() <<
          " from #{expected_initial_value.inspect}" <<
          " by #{expected_difference.inspect}" <<
          " to #{expected_current_value.inspect}"
      end

      it { expect(instance.description).to be == expected }
    end
  end

  describe '#does_not_match' do
    let(:failure_message_when_negated) do
      "expected #{actual.description} not to have changed"
    end
    let(:initial_value) { 'initial value'.freeze }
    let(:object)        { Struct.new(:value).new(initial_value) }
    let(:actual) do
      RSpec::SleepingKingStudios::Support::ValueSpy.new(object, :value)
    end

    describe 'with nil' do
      it 'should raise an error' do
        expect { instance.does_not_match? nil }
          .to raise_error(
            ArgumentError,
            'You must pass a value spy to `expect`.'
          )
      end
    end

    describe 'with an object' do
      it 'should raise an error' do
        expect { instance.does_not_match? Object.new }
          .to raise_error(
            ArgumentError,
            'You must pass a value spy to `expect`.'
          )
      end
    end

    describe 'with a value spy with an unchanged value' do
      include_examples 'should pass with a negative expectation'
    end

    describe 'with a value spy with a changed hash' do
      include_context 'when the value hash has changed'

      let(:failure_message_when_negated) do
        super() <<
          ", but did change from #{initial_value.inspect} to " <<
          changed_value.inspect
      end

      include_examples 'should fail with a negative expectation'
    end

    describe 'with a value spy with a changed value' do
      include_context 'when the value has changed'

      let(:failure_message_when_negated) do
        super() <<
          ", but did change from #{initial_value.inspect} to " <<
          changed_value.inspect
      end

      include_examples 'should fail with a negative expectation'
    end

    describe 'with a value spy with a modified value' do
      include_context 'when the value is modified'

      let(:failure_message_when_negated) do
        super() <<
          ", but did change from #{cached_value.inspect} to " <<
          initial_value.inspect
      end

      include_examples 'should fail with a negative expectation'
    end

    wrap_context 'when the matcher has a non-matching expected initial value' do
      let(:failure_message_when_negated) do
        "expected #{actual.description} to have initially been " \
        "#{expected_initial_value.inspect}, but was #{initial_value.inspect}"
      end

      describe 'with a value spy with an unchanged value' do
        include_examples 'should fail with a negative expectation'
      end

      describe 'with a value spy with a changed value' do
        include_context 'when the value has changed'

        include_examples 'should fail with a negative expectation'
      end
    end

    wrap_context 'when the matcher has a matching expected initial value' do
      describe 'with a value spy with an unchanged value' do
        include_examples 'should pass with a negative expectation'
      end

      describe 'with a value spy with a changed value' do
        include_context 'when the value has changed'

        let(:failure_message_when_negated) do
          super() <<
            ", but did change from #{initial_value.inspect} to " <<
            changed_value.inspect
        end

        include_examples 'should fail with a negative expectation'
      end
    end

    wrap_context 'when the matcher has a non-matching expected current value' do
      describe 'with a value spy with an unchanged value' do
        it 'should raise an error' do
          expect { instance.does_not_match? actual }
            .to raise_error NotImplementedError,
              "`expect().not_to have_changed().to()` is not supported"
        end
      end

      describe 'with a value spy with a changed value' do
        include_context 'when the value has changed'

        it 'should raise an error' do
          expect { instance.does_not_match? actual }
            .to raise_error NotImplementedError,
              "`expect().not_to have_changed().to()` is not supported"
        end
      end
    end

    wrap_context 'when the matcher has a matching expected current value' do
      describe 'with a value spy with an unchanged value' do
        it 'should raise an error' do
          expect { instance.does_not_match? actual }
            .to raise_error NotImplementedError,
              "`expect().not_to have_changed().to()` is not supported"
        end
      end

      describe 'with a value spy with a changed value' do
        include_context 'when the value has changed'

        it 'should raise an error' do
          expect { instance.does_not_match? actual }
            .to raise_error NotImplementedError,
              "`expect().not_to have_changed().to()` is not supported"
        end
      end
    end

    wrap_context 'when the matcher has an invalid expected difference' do
      describe 'with a value spy with an unchanged value' do
        it 'should raise an error' do
          expect { instance.does_not_match? actual }
            .to raise_error NotImplementedError,
              "`expect().not_to have_changed().by()` is not supported"
        end
      end

      describe 'with a value spy with a changed value' do
        include_context 'when the value has changed'

        it 'should raise an error' do
          expect { instance.does_not_match? actual }
            .to raise_error NotImplementedError,
              "`expect().not_to have_changed().by()` is not supported"
        end
      end
    end

    wrap_context 'when the matcher has a non-matching expected difference' do
      describe 'with a value spy with an unchanged value' do
        it 'should raise an error' do
          expect { instance.does_not_match? actual }
            .to raise_error NotImplementedError,
              "`expect().not_to have_changed().by()` is not supported"
        end
      end

      describe 'with a value spy with a changed value' do
        include_context 'when the value has changed'

        it 'should raise an error' do
          expect { instance.does_not_match? actual }
            .to raise_error NotImplementedError,
              "`expect().not_to have_changed().by()` is not supported"
        end
      end
    end

    wrap_context 'when the matcher has a matching expected difference' do
      describe 'with a value spy with an unchanged value' do
        it 'should raise an error' do
          expect { instance.does_not_match? actual }
            .to raise_error NotImplementedError,
              "`expect().not_to have_changed().by()` is not supported"
        end
      end

      describe 'with a value spy with a changed value' do
        include_context 'when the value has changed'

        it 'should raise an error' do
          expect { instance.does_not_match? actual }
            .to raise_error NotImplementedError,
              "`expect().not_to have_changed().by()` is not supported"
        end
      end
    end
  end

  describe '#from' do
    it { expect(instance).to respond_to(:from).with(1).argument }

    it { expect(instance.from 'value').to be instance }
  end

  describe '#matches?' do
    let(:failure_message) do
      "expected #{actual.description} to have changed"
    end
    let(:failure_message_when_negated) do
      "expected #{actual.description} not to have changed"
    end
    let(:initial_value) { 'initial value'.freeze }
    let(:object)        { Struct.new(:value).new(initial_value) }
    let(:actual) do
      RSpec::SleepingKingStudios::Support::ValueSpy.new(object, :value)
    end

    describe 'with nil' do
      it 'should raise an error' do
        expect { instance.matches? nil }
          .to raise_error(
            ArgumentError,
            'You must pass a value spy to `expect`.'
          )
      end
    end

    describe 'with an object' do
      it 'should raise an error' do
        expect { instance.matches? Object.new }
          .to raise_error(
            ArgumentError,
            'You must pass a value spy to `expect`.'
          )
      end
    end

    describe 'with a value spy with an unchanged value' do
      let(:failure_message) do
        super() << ", but is still #{object.value.inspect}"
      end

      include_examples 'should fail with a positive expectation'
    end

    describe 'with a value spy with a changed hash' do
      include_context 'when the value hash has changed'

      include_examples 'should pass with a positive expectation'
    end

    describe 'with a value spy with a changed value' do
      include_context 'when the value has changed'

      include_examples 'should pass with a positive expectation'
    end

    describe 'with a value spy with a modified value' do
      include_context 'when the value is modified'

      include_examples 'should pass with a positive expectation'
    end

    wrap_context 'when the matcher has a non-matching expected initial value' do
      let(:failure_message) do
        "expected #{actual.description} to have initially been " \
        "#{expected_initial_value.inspect}, but was #{initial_value.inspect}"
      end

      describe 'with a value spy with an unchanged value' do
        include_examples 'should fail with a positive expectation'
      end

      describe 'with a value spy with a changed value' do
        include_context 'when the value has changed'

        include_examples 'should fail with a positive expectation'
      end
    end

    wrap_context 'when the matcher has a matching expected initial value' do
      describe 'with a value spy with an unchanged value' do
        let(:failure_message) do
          super() << ", but is still #{object.value.inspect}"
        end

        include_examples 'should fail with a positive expectation'
      end

      describe 'with a value spy with a changed value' do
        include_context 'when the value has changed'

        include_examples 'should pass with a positive expectation'
      end
    end

    wrap_context 'when the matcher has a non-matching expected current value' do
      let(:failure_message) do
        super() << " to #{expected_current_value.inspect}"
      end

      describe 'with a value spy with an unchanged value' do
        let(:failure_message) do
          super() << ", but is still #{object.value.inspect}"
        end

        include_examples 'should fail with a positive expectation'
      end

      describe 'with a value spy with a changed value' do
        include_context 'when the value has changed'

        let(:failure_message) do
          super() << ", but is now #{changed_value.inspect}"
        end

        include_examples 'should fail with a positive expectation'
      end
    end

    wrap_context 'when the matcher has a matching expected current value' do
      let(:failure_message) do
        super() << " to #{changed_value.inspect}"
      end

      describe 'with a value spy with an unchanged value' do
        let(:failure_message) do
          super() << ", but is still #{object.value.inspect}"
        end

        include_examples 'should fail with a positive expectation'
      end

      describe 'with a value spy with a changed value' do
        include_context 'when the value has changed'

        include_examples 'should pass with a positive expectation'
      end
    end

    wrap_context 'when the matcher has an invalid expected difference' do
      let(:failure_message) do
        super() << " by #{expected_difference.inspect}"
      end

      describe 'with a value spy with an unchanged value' do
        let(:failure_message) do
          super() << ", but is still #{object.value.inspect}"
        end

        include_examples 'should fail with a positive expectation'
      end

      describe 'with a value spy with a changed value' do
        include_context 'when the value has changed'

        let(:error_message) do
          "undefined method `-' for #{changed_value.inspect}:String\n" \
          "Did you mean?  -@"
        end

        it 'should raise an error' do
          expect { instance.matches? actual }
            .to raise_error NoMethodError, error_message
        end
      end
    end

    wrap_context 'when the matcher has a non-matching expected difference' do
      let(:failure_message) do
        super() << " by #{expected_difference.inspect}"
      end

      describe 'with a value spy with an unchanged value' do
        let(:failure_message) do
          super() << ", but is still #{object.value.inspect}"
        end

        include_examples 'should fail with a positive expectation'
      end

      describe 'with a value spy with a changed value' do
        include_context 'when the value has changed'

        let(:failure_message) do
          super() << ", but was changed by #{actual_difference.inspect}"
        end

        include_examples 'should fail with a positive expectation'
      end
    end

    wrap_context 'when the matcher has a matching expected difference' do
      let(:failure_message) do
        super() << " by #{expected_difference.inspect}"
      end

      describe 'with a value spy with an unchanged value' do
        let(:failure_message) do
          super() << ", but is still #{object.value.inspect}"
        end

        include_examples 'should fail with a positive expectation'
      end

      describe 'with a value spy with a changed value' do
        include_context 'when the value has changed'

        include_examples 'should pass with a positive expectation'
      end
    end

    wrap_context 'when the matcher has multiple non-matching expectations' do
      let(:failure_message) do
          super() <<
            " by #{expected_difference.inspect}" <<
            " to #{expected_current_value.inspect}"
        end

      describe 'with a value spy with an unchanged value' do
        let(:failure_message) do
          super() << ", but is still #{object.value.inspect}"
        end

        include_examples 'should fail with a positive expectation'
      end

      describe 'with a value spy with a changed value' do
        include_context 'when the value has changed'

        let(:failure_message) do
          super() << ", but is now #{changed_value.inspect}"
        end

        include_examples 'should fail with a positive expectation'
      end
    end
  end

  describe '#to' do
    it { expect(instance).to respond_to(:to).with(1).argument }

    it { expect(instance.to 'value').to be instance }
  end
end
