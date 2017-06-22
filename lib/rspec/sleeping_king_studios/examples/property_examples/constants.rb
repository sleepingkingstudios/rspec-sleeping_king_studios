# lib/rspec/sleeping_king_studios/examples/property_examples/constants.rb

require 'rspec/sleeping_king_studios/concerns/shared_example_group'
require 'rspec/sleeping_king_studios/examples'
require 'rspec/sleeping_king_studios/matchers/core/have_constant'

module RSpec::SleepingKingStudios::Examples
  module PropertyExamples
    module Constants
      extend RSpec::SleepingKingStudios::Concerns::SharedExampleGroup

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
      alias_shared_examples 'has constant', 'should have constant'

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
      alias_shared_examples 'has immutable constant', 'should have immutable constant'
    end # module
  end # module
end # module
