# lib/rspec/sleeping_king_studios/examples/property_examples.rb

require 'rspec/sleeping_king_studios/concerns/shared_example_group'
require 'rspec/sleeping_king_studios/examples'
require 'rspec/sleeping_king_studios/matchers/core/have_reader'
require 'rspec/sleeping_king_studios/matchers/core/have_writer'
require 'sleeping_king_studios/tools/object_tools'

module RSpec::SleepingKingStudios::Examples::PropertyExamples
  extend RSpec::SleepingKingStudios::Concerns::SharedExampleGroup

  UNDEFINED_PROPERTY_EXPECTATION = Object.new.freeze

  shared_examples 'has reader' do |property, expected_value = UNDEFINED_PROPERTY_EXPECTATION|
    it "has reader :#{property}" do
      object = defined?(instance) ? instance : subject

      expect(object).to have_reader(property)

      next if expected_value == UNDEFINED_PROPERTY_EXPECTATION

      actual_value = instance.send property

      if expected_value.is_a?(Proc)
        args = [self, expected_value]
        args.push actual_value unless 0 == expected_value.arity

        expected_value = SleepingKingStudios::Tools::ObjectTools.apply *args
      end # if

      case expected_value
      when ->(obj) { obj.respond_to?(:matches?) }
        expect(actual_value).to expected_value
      when true, false
        expected_value
      else
        expect(actual_value).to be == expected_value
      end # case
    end # it
  end # shared_examples
  alias_shared_examples 'should have reader', 'has reader'

  shared_examples 'has writer' do |property|
    it "has writer :#{property}=" do
      object = defined?(instance) ? instance : subject

      expect(object).to have_writer(property)
    end # it
  end # shared_examples
  alias_shared_examples 'should have writer', 'has writer'

  shared_examples 'has property' do |property, expected_value = UNDEFINED_PROPERTY_EXPECTATION|
    include_examples 'has reader', property, expected_value

    include_examples 'has writer', property
  end # shared_examples
  alias_shared_examples 'should have property', 'has property'
end # module
