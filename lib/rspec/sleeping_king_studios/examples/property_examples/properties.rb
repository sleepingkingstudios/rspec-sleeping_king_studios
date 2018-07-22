# lib/rspec/sleeping_king_studios/examples/property_examples/properties.rb

require 'rspec/sleeping_king_studios/concerns/shared_example_group'
require 'rspec/sleeping_king_studios/examples/property_examples'
require 'rspec/sleeping_king_studios/matchers/core/have_property'
require 'rspec/sleeping_king_studios/matchers/core/have_reader'
require 'rspec/sleeping_king_studios/matchers/core/have_writer'

module RSpec::SleepingKingStudios::Examples
  module PropertyExamples
    module Properties
      extend RSpec::SleepingKingStudios::Concerns::SharedExampleGroup

      shared_examples 'should have property' do |property, expected_value = UNDEFINED_VALUE_EXPECTATION, allow_private: false|
        it "should have property :#{property}" do
          object  = defined?(instance) ? instance : subject
          matcher = have_property(property, :allow_private => allow_private)

          if expected_value == UNDEFINED_VALUE_EXPECTATION
            if allow_private
              expect(object).to have_property(property, allow_private: true)
            else
              expect(object).to have_property(property)
            end
          else
            expected_value = format_expected_value(expected_value)

            if allow_private
              expect(object).to have_property(property, allow_private: true).with_value(expected_value)
            else
              expect(object).to have_property(property).with_value(expected_value)
            end
          end # if-else
        end # it
      end # shared_examples
      alias_shared_examples 'defines property', 'should have property'
      alias_shared_examples 'has property', 'should have property'
      alias_shared_examples 'should define property', 'should have property'

      shared_examples 'should have reader' do |property, expected_value = UNDEFINED_VALUE_EXPECTATION, allow_private: false|
        it "should have reader :#{property}" do
          object  = defined?(instance) ? instance : subject

          if expected_value == UNDEFINED_VALUE_EXPECTATION
            if allow_private
              expect(object).to have_reader(property, allow_private: true)
            else
              expect(object).to have_reader(property)
            end
          else
            expected_value = format_expected_value(expected_value)

            if allow_private
              expect(object).to have_reader(property, allow_private: true).with_value(expected_value)
            else
              expect(object).to have_reader(property).with_value(expected_value)
            end
          end # if-else
        end # it
      end # shared_examples
      alias_shared_examples 'defines reader', 'should have reader'
      alias_shared_examples 'has reader', 'should have reader'
      alias_shared_examples 'should define reader', 'should have reader'

      shared_examples 'should have writer' do |property, allow_private: false|
        writer_name = property.to_s.sub /\=\z/, ''

        it "should have writer :#{writer_name}" do
          object = defined?(instance) ? instance : subject

          expect(object).to have_writer(property, :allow_private => allow_private)
        end # it
      end # shared_examples
      alias_shared_examples 'defines writer', 'should have writer'
      alias_shared_examples 'has writer', 'should have writer'
      alias_shared_examples 'should define writer', 'should have writer'

      shared_examples 'should not have reader' do |property, allow_private: false|
        it "should not have reader :#{property}" do
          object = defined?(instance) ? instance : subject

          expect(object).not_to have_reader(property, :allow_private => allow_private)
        end # it
      end # shared_examples
      alias_shared_examples 'does not define reader', 'should not have reader'
      alias_shared_examples 'does not have reader', 'should not have reader'
      alias_shared_examples 'should not define reader', 'should not have reader'

      shared_examples 'should not have writer' do |property, allow_private: false|
        writer_name = property.to_s.sub /\=\z/, ''

        it "should not have writer :#{writer_name}" do
          object = defined?(instance) ? instance : subject

          expect(object).not_to have_writer(property, :allow_private => allow_private)
        end # it
      end # shared_examples
      alias_shared_examples 'does not define writer', 'should not have writer'
      alias_shared_examples 'does not have writer', 'should not have writer'
      alias_shared_examples 'should not define writer', 'should not have writer'
    end # module
  end # module
end # module
