# spec/rspec/sleeping_king_studios/matchers/core/have_property_spec.rb

require 'rspec/sleeping_king_studios/spec_helper'

require 'rspec/sleeping_king_studios/matchers/core/have_property'

describe '#have_reader' do
  let(:example_group) { RSpec::Core::ExampleGroup.new }
  let(:property)      { :foo }
  let(:instance)      { example_group.have_property property }

  specify { expect(example_group).to respond_to(:have_property).with(1).arguments }

  describe '#with' do
    specify { expect(instance).to respond_to(:with).with(1).arguments }
    specify { expect(instance.with 5).to be instance }
  end # describe with
  
  <<-SCENARIOS
    When the object responds to :property and :property=,
      And there is no expected value set,
        Evaluates to true with should_not message "expected not to respond to".
      And there is an expected value set,
        And the expected value matches the actual value,
          Evaluates to true with should_not message "expected not to respond to with value".
        And the expected value does not match the actual value,
          Evaluates to false with should message "unexpected value for, expected, received".
    When the object responds to :property xor property=,
      Evaluates to false with should message "expected to respond to".
    When the object does not respond to :property and :property=,
      Evaluates to false with should message "expected to respond to and".
  SCENARIOS

  describe 'with an object responding to :property and :property=' do
    let(:actual) { Struct.new(property).new }
    let(:value)  { 42 }

    specify 'with no expected value' do
      expect(instance).to pass_with_actual(actual).
        with_message "expected #{actual} not to respond to #{property.inspect} or #{property.inspect}="
    end # specify

    specify 'with a correct expected value' do
      allow(actual).to receive(:to_s).and_return("<struct>").twice
      expect(instance.with 42).to pass_with_actual(actual).
        with_message "expected #{actual} not to respond to #{property.inspect} or #{property.inspect}= with value #{value}"
    end # specify

    specify 'with an incorrect expected value' do
      allow(instance).to receive(property).and_return(nil)
      failure_message = "unexpected value for #{actual}\##{property}\n" +
        "  expected: #{value.inspect}\n" +
        "       got: #{actual.send(property).inspect}"
      expect(instance.with 42).to fail_with_actual(actual).
        with_message failure_message
    end # specify

    pending
  end # describe

  describe 'with an object responding only to :property' do
    let(:actual) { Class.new.tap { |klass| klass.send :attr_reader, property }.new }

    specify do
      expect(instance).to fail_with_actual(actual).
        with_message "expected #{actual} to respond to #{property.inspect}="
    end # specify
  end # describe

  describe 'with an object responding only to :property=' do
    let(:actual) { Class.new.tap { |klass| klass.send :attr_writer, property }.new }

    specify do
      expect(instance).to fail_with_actual(actual).
        with_message "expected #{actual} to respond to #{property.inspect}"
    end # specify
  end # describe

  describe 'with an object not responding to :property or :property=' do
    let(:actual) { Object.new }

    specify do
      expect(instance).to fail_with_actual(actual).
        with_message "expected #{actual} to respond to #{property.inspect} and #{property.inspect}="
    end # specify
  end # describe
end # describe
