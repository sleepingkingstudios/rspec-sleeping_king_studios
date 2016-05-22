# lib/rspec/sleeping_king_studios/examples/property_examples.rb

require 'rspec/sleeping_king_studios/concerns/shared_example_group'
require 'rspec/sleeping_king_studios/examples'
require 'rspec/sleeping_king_studios/matchers/core/have_constant'
require 'rspec/sleeping_king_studios/matchers/core/have_predicate'
require 'rspec/sleeping_king_studios/matchers/core/have_property'
require 'rspec/sleeping_king_studios/matchers/core/have_reader'
require 'rspec/sleeping_king_studios/matchers/core/have_writer'
require 'sleeping_king_studios/tools/object_tools'

# Pregenerated example groups for testing the presence and value of reader and
# writer methods.
module RSpec::SleepingKingStudios::Examples::PropertyExamples
  extend RSpec::SleepingKingStudios::Concerns::SharedExampleGroup

  # @api private
  #
  # Internal object used to differentiate a nil expectation from a default
  # value expectation.
  UNDEFINED_VALUE_EXPECTATION = Object.new.freeze

  private def format_expected_value expected_value
    if expected_value.is_a?(Proc)
      object_tools   = SleepingKingStudios::Tools::ObjectTools

      if 0 == expected_value.arity
        comparable_value = object_tools.apply self, expected_value
      else
        comparable_value = satisfy do |actual_value|
          object_tools.apply self, expected_value, actual_value
        end # satisfy
      end # if-else
    else
      comparable_value = expected_value
    end # if

    comparable_value
  end # method format_expected_value

  shared_examples 'should have constant' do |constant_name, expected_value = UNDEFINED_VALUE_EXPECTATION|
    it "should have constant :#{constant_name}" do
      if defined?(described_class) && described_class.is_a?(Module)
        object = described_class
      else
        object = subject
      end # if-else

      if expected_value == UNDEFINED_VALUE_EXPECTATION
        expect(object).to have_constant(constant_name)
      else
        expected_value = format_expected_value(expected_value)

        expect(object).to have_constant(constant_name).with_value(expected_value)
      end # if-else
    end # it
  end # shared_examples

  shared_examples 'should have immutable constant' do |constant_name, expected_value = UNDEFINED_VALUE_EXPECTATION|
    it "should have immutable constant :#{constant_name}" do
      if defined?(described_class) && described_class.is_a?(Module)
        object = described_class
      else
        object = subject
      end # if-else

      if expected_value == UNDEFINED_VALUE_EXPECTATION
        expect(object).to have_immutable_constant(constant_name)
      else
        expected_value = format_expected_value(expected_value)

        expect(object).to have_immutable_constant(constant_name).with_value(expected_value)
      end # if-else
    end # it
  end # shared_examples

  shared_examples 'should have predicate' do |property, expected_value = UNDEFINED_VALUE_EXPECTATION|
    it "should have predicate :#{property}?" do
      object = defined?(instance) ? instance : subject

      if expected_value == UNDEFINED_VALUE_EXPECTATION
        expect(object).to have_predicate(property)
      else
        expected_value = format_expected_value(expected_value)

        expect(object).to have_predicate(property).with_value(expected_value)
      end # if-else
    end # it
  end # shared_examples
  alias_shared_examples 'has predicate', 'should have predicate'

  shared_examples 'should have reader' do |property, expected_value = UNDEFINED_VALUE_EXPECTATION|
    it "should have reader :#{property}" do
      object = defined?(instance) ? instance : subject

      if expected_value == UNDEFINED_VALUE_EXPECTATION
        expect(object).to have_reader(property)
      else
        expected_value = format_expected_value(expected_value)

        expect(object).to have_reader(property).with_value(expected_value)
      end # if-else
    end # it
  end # shared_examples
  alias_shared_examples 'has reader', 'should have reader'

  shared_examples 'should have writer' do |property|
    it "should have writer :#{property}=" do
      object = defined?(instance) ? instance : subject

      expect(object).to have_writer(property)
    end # it
  end # shared_examples
  alias_shared_examples 'has writer', 'should have writer'

  shared_examples 'should have property' do |property, expected_value = UNDEFINED_VALUE_EXPECTATION|
    it "should have property :#{property}" do
      object = defined?(instance) ? instance : subject

      if expected_value == UNDEFINED_VALUE_EXPECTATION
        expect(object).to have_property(property)
      else
        expected_value = format_expected_value(expected_value)

        expect(object).to have_property(property).with_value(expected_value)
      end # if-else
    end # it
  end # shared_examples
  alias_shared_examples 'has property', 'should have property'
end # module
