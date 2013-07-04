# spec/rspec/sleeping_king_studios/matchers/core/have_writer_spec.rb

require 'rspec/sleeping_king_studios/spec_helper'

require 'rspec/sleeping_king_studios/matchers/core/have_writer'

describe '#have_writer' do
  let(:example_group) { RSpec::Core::ExampleGroup.new }
  let(:property)      { :foo }
  let(:instance)      { example_group.have_writer property }

  specify { expect(example_group).to respond_to(:have_writer).with(1).arguments }

  describe '#with' do
    specify { expect(instance).to respond_to(:with).with(1).arguments }
    specify { expect(instance.with 5).to be instance }
  end # describe with

  <<-SCENARIOS
    When the object responds to :property=,
      And there is no expected value set,
        Evaluates to true with should_not message "expected not to respond to".
      And there is an expected value set,
        And the object responds to :property,
          And the expected value matches the actual value,
            Evaluates to true with should_not message "expected not to respond to with value".
          And the expected value does not match the actual value,
            Evaluates to false with should message "unexpected value for, expected, received".
        And the object does not respond to :property,
          And there a block was declared to evaluate :property,
            And the expected value matches the actual value,
              Evaluates to true with should_not message "expected not to respond to with value".
            And the expected value does not match the actual value,
              Evaluates to false with should message "unexpected value for, expected, received".
          And there was not a block declared to evaluate :property,
            Evaluates to false with should message "unable to evaluate, please define block".
    When the object does not respond to :property=,
      Evaluates to false with should message "expected to respond to".
  SCENARIOS

  describe 'with an object that responds to :property=' do
    let(:value)  { 42 }
    let(:actual) { Struct.new(property).new }

    specify 'with no argument set' do
      expect(instance).to pass_with_actual(actual).
        with_message "expected #{actual} not to respond to #{property.inspect}="
    end # specify

    describe 'and responds to :property' do
      let(:actual) do
        Struct.new(property) do
          def inspect; to_s; end
          def to_s; "<struct>"; end
        end.new
      end # let

      specify 'with a valid response' do
        expect(instance.with value).to pass_with_actual(actual).
          with_message "expected #{actual} not to respond to #{property.inspect}= with value #{value}"
      end # specify

      specify 'with an invalid response' do
        allow(actual).to receive(property).and_return(value)
        failure_message = "unexpected value for #{actual}\##{property}=\n" +
          "  expected: nil\n       got: #{value}"
        expect(instance.with nil).to fail_with_actual(actual).
          with_message failure_message
      end # specify
    end # describe

    describe 'but does not respond to :property' do
      let(:actual) do
        Class.new.tap do |klass|
          klass.send :attr_writer, property
          klass.send :define_method, :inspect, ->{ to_s }
        end.new
      end # let

      describe 'with no block added to #with' do
        specify do
          failure_message = "unable to test #{property.inspect}= because " +
            "#{actual} does not respond to #{property.inspect}; try adding a " +
            "test block to #with"
          expect(instance.with value).to fail_with_actual(actual).
            with_message failure_message
        end # specify
      end # describe

      describe 'with a block added to #with' do
        specify 'with a valid response' do
          expect(instance.with(value) { instance_variable_get "@foo" }).to pass_with_actual(actual).
            with_message "expected #{actual} not to respond to #{property.inspect}= with value #{value}"
        end # specify

        specify 'with an invalid response' do
          allow(actual).to receive(property).and_return(value)
          failure_message = "unexpected value for #{actual}\##{property}=\n" +
            "  expected: #{value}\n       got: nil"
          expect(instance.with(value) { nil }).to fail_with_actual(actual).
            with_message failure_message
        end # specify
      end # describe
    end # describe
  end # describe

  describe 'with an object that does not respond to :property=' do
    let(:actual) { Object.new }

    specify do
      expect(instance).to fail_with_actual(actual).
        with_message "expected #{actual} to respond to #{property.inspect}="
    end # specify
  end # describe
end # describe
