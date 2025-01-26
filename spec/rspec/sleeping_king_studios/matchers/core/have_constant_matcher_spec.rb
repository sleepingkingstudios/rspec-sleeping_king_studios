# spec/rspec/sleeping_king_studios/matchers/core/have_constant_matcher_spec.rb

require 'rspec/sleeping_king_studios/examples/rspec_matcher_examples'
require 'rspec/sleeping_king_studios/matchers/core/have_aliased_method'

require 'rspec/sleeping_king_studios/matchers/core/have_constant_matcher'

RSpec.describe RSpec::SleepingKingStudios::Matchers::Core::HaveConstantMatcher do
  include RSpec::SleepingKingStudios::Examples::RSpecMatcherExamples

  let(:constant_name) { :FOO }
  let(:instance)      { described_class.new constant_name }

  describe '#description' do
    let(:immutable) { false }
    let(:expected) do
      "have #{immutable ? 'immutable ' : ''}constant #{constant_name.inspect}"
    end # let

    it { expect(instance).to respond_to(:description).with(0).arguments }

    it { expect(instance.description).to be == expected }

    context 'with an immutable expectation set' do
      let(:immutable) { true }
      let(:instance)  { super().immutable }

      it { expect(instance.description).to be == expected }
    end # context

    context 'with a value expectation set' do
      let(:expected_value) { 12345 }
      let(:expected)       { super() << " with value #{expected_value.inspect}" }
      let(:instance)       { super().with(expected_value) }

      it { expect(instance.description).to be == expected }

      context 'with an immutable expectation set' do
        let(:immutable) { true }
        let(:instance)  { super().immutable }

        it { expect(instance.description).to be == expected }
      end # context
    end # context
  end # describe

  describe '#frozen' do
    it { expect(instance).to respond_to(:frozen).with(0).arguments }

    it { expect(instance.frozen).to be instance }
  end # describe

  describe '#frozen?' do
    it { expect(instance).to respond_to(:frozen?).with(0).arguments }

    it { expect(instance.frozen?).to be false }

    context 'with an frozen expectation' do
      let(:instance) { super().frozen }

      it { expect(instance.frozen?).to be true }
    end # context
  end # describe

  describe '#immutable' do
    it { expect(instance).to respond_to(:immutable).with(0).arguments }

    it { expect(instance.immutable).to be instance }
  end # describe

  describe '#immutable?' do
    it { expect(instance).to respond_to(:immutable?).with(0).arguments }

    it { expect(instance.immutable?).to be false }

    context 'with an immutable expectation' do
      let(:instance) { super().immutable }

      it { expect(instance.immutable?).to be true }
    end # context
  end # describe

  describe '#matches?' do
    let(:failure_message) do
      message = "expected #{actual.inspect} to have "

      message << 'immutable ' if immutable

      message << "constant #{constant_name.inspect}"

      message << expected_string

      message
    end # let
    let(:failure_message_when_negated) do
      message = "expected #{actual.inspect} not to have "

      message << 'immutable ' if immutable

      message << "constant #{constant_name.inspect}"

      message << expected_string

      message <<
        ", but #{actual.inspect} defines constant #{constant_name.inspect} "\
        "with value #{constant_value.inspect}"

      message
    end # let
    let(:expected_string) do
      return '' unless defined?(expected_value)

      message = ' with value '

      if expected_value.respond_to?(:matches?) && expected_value.respond_to?(:description)
        message << expected_value.description
      else
        message << expected_value.inspect
      end # if-else

      message
    end # let
    let(:immutable) { false }

    describe 'with an object that does not respond to ::const_defined?' do
      let(:failure_message) do
        super() <<
          ", but #{actual.inspect} does not respond to ::const_defined?"
      end # let
      let(:actual) { Object.new }

      include_examples 'should fail with a positive expectation'

      include_examples 'should pass with a negative expectation'
    end # describe

    describe 'with an object that does not define the constant' do
      let(:failure_message) do
        super() <<
          ", but #{actual.inspect} does not define constant #{constant_name.inspect}"
      end # let
      let(:actual) { Module.new }

      include_examples 'should fail with a positive expectation'

      include_examples 'should pass with a negative expectation'
    end # describe

    describe 'with an object that defines the constant' do
      let(:actual) do
        Module.new.tap do |mod|
          mod.send :const_set, constant_name, constant_value
        end # tap
      end # let
      let(:constant_value) { 'FOO' }

      include_examples 'should pass with a positive expectation'

      include_examples 'should fail with a negative expectation'

      describe 'with a non-matching value expectation' do
        let(:failure_message) do
          super() <<
            ", but constant #{constant_name.inspect} has value #{constant_value.inspect}"
        end # let
        let(:expected_value) { 12345 }
        let(:instance)       { super().with_value(expected_value) }

        include_examples 'should fail with a positive expectation'

        include_examples 'should fail with a negative expectation'

        describe 'with an immutable expectation' do
          let(:immutable) { true }
          let(:instance)  { super().immutable }

          describe 'with a mutable value' do
            let(:failure_message) do
              super() <<
                " and the value of #{constant_name.inspect} was mutable"
            end # let

            include_examples 'should fail with a positive expectation'

            include_examples 'should fail with a negative expectation'
          end # describe

          describe 'with an immutable value' do
            let(:constant_value) { super().freeze }

            include_examples 'should fail with a positive expectation'

            include_examples 'should fail with a negative expectation'
          end # describe
        end # describe
      end # describe

      describe 'with a non-matching matcher expectation' do
        let(:failure_message) do
          super() <<
            ", but constant #{constant_name.inspect} has value #{constant_value.inspect}"
        end # let
        let(:expected_value) { an_instance_of Integer }
        let(:instance)       { super().with_value(expected_value) }

        include_examples 'should fail with a positive expectation'

        include_examples 'should fail with a negative expectation'
      end # describe

      describe 'with a matching value expectation' do
        let(:expected_value) { constant_value }
        let(:instance)       { super().with_value(expected_value) }

        include_examples 'should pass with a positive expectation'

        include_examples 'should fail with a negative expectation'

        describe 'with an immutable expectation' do
          let(:immutable) { true }
          let(:instance)  { super().immutable }

          describe 'with a mutable value' do
            let(:failure_message) do
              super() <<
                ", but the value of #{constant_name.inspect} was mutable"
            end # let

            include_examples 'should fail with a positive expectation'

            include_examples 'should fail with a negative expectation'
          end # describe

          describe 'with an immutable value' do
            let(:constant_value) { super().freeze }

            include_examples 'should pass with a positive expectation'

            include_examples 'should fail with a negative expectation'
          end # describe
        end # describe
      end # describe

      describe 'with a matching matcher expectation' do
        let(:expected_value) { an_instance_of String }
        let(:instance)       { super().with_value(expected_value) }

        include_examples 'should pass with a positive expectation'

        include_examples 'should fail with a negative expectation'
      end # describe

      describe 'with an immutable expectation' do
        let(:immutable) { true }
        let(:instance)  { super().immutable }

        describe 'with a nil value' do
          let(:constant_value) { nil }

          include_examples 'should pass with a positive expectation'

          include_examples 'should fail with a negative expectation'
        end # describe

        describe 'with a false value' do
          let(:constant_value) { false }

          include_examples 'should pass with a positive expectation'

          include_examples 'should fail with a negative expectation'
        end # describe

        describe 'with a true value' do
          let(:constant_value) { true }

          include_examples 'should pass with a positive expectation'

          include_examples 'should fail with a negative expectation'
        end # describe

        describe 'with a symbol value' do
          let(:constant_value) { :symbol }

          include_examples 'should pass with a positive expectation'

          include_examples 'should fail with a negative expectation'
        end # describe

        describe 'with a numeric value' do
          let(:constant_value) { 42 }

          include_examples 'should pass with a positive expectation'

          include_examples 'should fail with a negative expectation'
        end # describe

        describe 'with a string value' do
          let(:failure_message) do
            super() << ", but the value of #{constant_name.inspect} was mutable"
          end # let
          let(:constant_value) { 'swordfish' }

          include_examples 'should fail with a positive expectation'

          include_examples 'should fail with a negative expectation'

          describe 'with a frozen value' do
            let(:constant_value) { super().freeze }

            include_examples 'should pass with a positive expectation'

            include_examples 'should fail with a negative expectation'
          end # describe
        end # describe

        describe 'with an array value' do
          let(:failure_message) do
            super() << ", but the value of #{constant_name.inspect} was mutable"
          end # let
          let(:constant_value) { %w(foo bar baz) }

          include_examples 'should fail with a positive expectation'

          include_examples 'should fail with a negative expectation'

          describe 'with a frozen array and non-frozen items' do
            let(:constant_value) { super().freeze }

            include_examples 'should fail with a positive expectation'

            include_examples 'should fail with a negative expectation'
          end # describe

          describe 'with a frozen array and frozen items' do
            let(:constant_value) { super().map(&:freeze).freeze }

            include_examples 'should pass with a positive expectation'

            include_examples 'should fail with a negative expectation'
          end # describe
        end # describe

        describe 'with a hash value' do
          let(:failure_message) do
            super() << ", but the value of #{constant_name.inspect} was mutable"
          end # let
          let(:hash_keys)   { %i(foo bar baz) }
          let(:hash_values) { %w(foo bar baz) }
          let(:constant_value) do
            {}.tap do |hsh|
              hash_keys.each.with_index do |key, index|
                hsh[key] = hash_values[index]
              end # each
            end # tap
          end # let

          include_examples 'should fail with a positive expectation'

          include_examples 'should fail with a negative expectation'

          describe 'with a frozen hsh and non-frozen keys' do
            let(:key_struct)     { Struct.new(:key) }
            let(:hash_keys)      { super().map { |key| key_struct.new(key) } }
            let(:hash_values)    { super().map &:freeze }
            let(:constant_value) { super().freeze }

            include_examples 'should fail with a positive expectation'

            include_examples 'should fail with a negative expectation'
          end # describe

          describe 'with a frozen hsh and non-frozen values' do
            let(:constant_value) { super().freeze }

            include_examples 'should fail with a positive expectation'

            include_examples 'should fail with a negative expectation'
          end # describe

          describe 'with a frozen hsh and non-frozen keys and values' do
            let(:key_struct)     { Struct.new(:key) }
            let(:hash_keys)      { super().map { |key| key_struct.new(key) } }
            let(:constant_value) { super().freeze }

            include_examples 'should fail with a positive expectation'

            include_examples 'should fail with a negative expectation'
          end # describe

          describe 'with a frozen hsh and frozen keys and values' do
            let(:hash_values)    { super().map &:freeze }
            let(:constant_value) { super().freeze }

            include_examples 'should pass with a positive expectation'

            include_examples 'should fail with a negative expectation'
          end # describe
        end # describe
      end # describe
    end # describe
  end # describe

  describe '#with_value' do
    it { expect(instance).to respond_to(:with_value).with(1).arguments }

    it { expect(instance).to have_aliased_method(:with_value).as(:with) }

    it { expect(instance.with_value false).to be instance }
  end # describe with
end # describe
