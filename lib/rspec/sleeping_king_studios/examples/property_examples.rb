# lib/rspec/sleeping_king_studios/examples/property_examples.rb

require 'sleeping_king_studios/tools/object_tools'

require 'rspec/sleeping_king_studios/concerns/shared_example_group'
require 'rspec/sleeping_king_studios/examples'
require 'rspec/sleeping_king_studios/examples/property_examples/constants'
require 'rspec/sleeping_king_studios/examples/property_examples/predicates'
require 'rspec/sleeping_king_studios/examples/property_examples/properties'

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
      object_tools = SleepingKingStudios::Tools::ObjectTools

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

  include RSpec::SleepingKingStudios::Examples::PropertyExamples::Constants
  include RSpec::SleepingKingStudios::Examples::PropertyExamples::Predicates
  include RSpec::SleepingKingStudios::Examples::PropertyExamples::Properties
end # module
