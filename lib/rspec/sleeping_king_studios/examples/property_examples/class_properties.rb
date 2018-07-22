# lib/rspec/sleeping_king_studios/examples/property_examples/class_properties.rb

require 'rspec/sleeping_king_studios/concerns/shared_example_group'
require 'rspec/sleeping_king_studios/examples'
require 'rspec/sleeping_king_studios/matchers/core/have_property'
require 'rspec/sleeping_king_studios/matchers/core/have_reader'
require 'rspec/sleeping_king_studios/matchers/core/have_writer'

module RSpec::SleepingKingStudios::Examples
  module PropertyExamples
    module ClassProperties
      extend RSpec::SleepingKingStudios::Concerns::SharedExampleGroup

      shared_examples 'should have class property' do |property, expected_value = UNDEFINED_VALUE_EXPECTATION|
        it "should have class property :#{property}" do
          if expected_value == UNDEFINED_VALUE_EXPECTATION
            expect(described_class).to have_property(property)
          else
            expected_value = format_expected_value(expected_value)

            expect(described_class).to have_property(property).with_value(expected_value)
          end # if-else
        end # it
      end # shared_examples
      alias_shared_examples 'defines class property', 'should have class property'
      alias_shared_examples 'has class property', 'should have class property'
      alias_shared_examples 'should define class property', 'should have class property'

      shared_examples 'should have class reader' do |property, expected_value = UNDEFINED_VALUE_EXPECTATION|
        it "should have class reader :#{property}" do
          if expected_value == UNDEFINED_VALUE_EXPECTATION
            expect(described_class).to have_reader(property)
          else
            expected_value = format_expected_value(expected_value)

            expect(described_class).to have_reader(property).with_value(expected_value)
          end # if-else
        end # it
      end # shared_examples
      alias_shared_examples 'defines class reader', 'should have class reader'
      alias_shared_examples 'has class reader', 'should have class reader'
      alias_shared_examples 'should define class reader', 'should have class reader'

      shared_examples 'should have class writer' do |property|
        writer_name = property.to_s.sub /\=\z/, ''

        it "should have class writer :#{writer_name}" do
          expect(described_class).to have_writer(property)
        end # it
      end # shared_examples
      alias_shared_examples 'defines class writer', 'should have class writer'
      alias_shared_examples 'has class writer', 'should have class writer'
      alias_shared_examples 'should define class writer', 'should have class writer'

      shared_examples 'should not have class reader' do |property|
        it "should not have class reader :#{property}" do
          expect(described_class).not_to have_reader(property)
        end # it
      end # shared_examples
      alias_shared_examples 'does not define class reader', 'should not have class reader'
      alias_shared_examples 'does not have class reader', 'should not have class reader'
      alias_shared_examples 'should not define class reader', 'should not have class reader'

      shared_examples 'should not have class writer' do |property|
        writer_name = property.to_s.sub /\=\z/, ''

        it "should not have class writer :#{writer_name}" do
          expect(described_class).not_to have_writer(property)
        end # it
      end # shared_examples
      alias_shared_examples 'does not define class writer', 'should not have class writer'
      alias_shared_examples 'does not have class writer', 'should not have class writer'
      alias_shared_examples 'should not define class writer', 'should not have class writer'
    end # module
  end # module
end # module
