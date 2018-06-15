# lib/rspec/sleeping_king_studios/examples/property_examples/private_properties.rb

require 'rspec/sleeping_king_studios/concerns/shared_example_group'
require 'rspec/sleeping_king_studios/examples'

module RSpec::SleepingKingStudios::Examples
  module PropertyExamples
    module PrivateProperties
      extend RSpec::SleepingKingStudios::Concerns::SharedExampleGroup

      shared_examples 'should have private reader' do |property, expected_value = UNDEFINED_VALUE_EXPECTATION|
        it "should have private reader :#{property}" do
          object  = defined?(instance) ? instance : subject

          expect(object).not_to respond_to(property)

          if expected_value == UNDEFINED_VALUE_EXPECTATION
            expect(object).to have_reader(property, allow_private: true)
          else
            expected_value = format_expected_value(expected_value)

            expect(object).to have_reader(property, allow_private: true).with_value(expected_value)
          end # if-else
        end # it
      end # shared_examples
      alias_shared_examples 'has private reader', 'should have private reader'

      shared_examples 'should have private writer' do |property|
        writer_name = :"#{property.to_s.sub(/=\z/, '')}="

        it "should have private writer :#{writer_name}" do
          object = defined?(instance) ? instance : subject

          expect(object).not_to respond_to(writer_name)

          expect(object).to have_writer(writer_name, :allow_private => true)
        end # it
      end # shared_examples
      alias_shared_examples 'has private writer', 'should have private writer'

      shared_examples 'should have private property' do |property, expected_value = UNDEFINED_VALUE_EXPECTATION|
        writer_name = :"#{property.to_s.sub(/=\z/, '')}="

        it "should have private property :#{property}" do
          object  = defined?(instance) ? instance : subject
          matcher = have_property(property, :allow_private => true)

          expect(object).not_to respond_to(property)
          expect(object).not_to respond_to(writer_name)

          if expected_value == UNDEFINED_VALUE_EXPECTATION
            expect(object).to have_property(property, allow_private: true)
          else
            expected_value = format_expected_value(expected_value)

            expect(object).to have_property(property, allow_private: true).with_value(expected_value)
          end # if-else
        end # it
      end # shared_examples
      alias_shared_examples 'has private property', 'should have private property'
    end # module
  end # module
end # module
