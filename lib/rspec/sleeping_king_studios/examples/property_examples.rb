# frozen_string_literal: true

require 'sleeping_king_studios/tools/toolbelt'

require 'rspec/sleeping_king_studios/concerns/shared_example_group'
require 'rspec/sleeping_king_studios/examples'
require 'rspec/sleeping_king_studios/examples/property_examples/class_properties' # rubocop:disable Layout/LineLength
require 'rspec/sleeping_king_studios/examples/property_examples/constants'
require 'rspec/sleeping_king_studios/examples/property_examples/private_properties' # rubocop:disable Layout/LineLength
require 'rspec/sleeping_king_studios/examples/property_examples/predicates'
require 'rspec/sleeping_king_studios/examples/property_examples/properties'

# Pregenerated example groups for testing the presence and value of reader and
# writer methods.
module RSpec::SleepingKingStudios::Examples::PropertyExamples
  extend RSpec::SleepingKingStudios::Concerns::SharedExampleGroup
  include RSpec::SleepingKingStudios::Examples::PropertyExamples::ClassProperties
  include RSpec::SleepingKingStudios::Examples::PropertyExamples::Constants
  include RSpec::SleepingKingStudios::Examples::PropertyExamples::PrivateProperties
  include RSpec::SleepingKingStudios::Examples::PropertyExamples::Predicates
  include RSpec::SleepingKingStudios::Examples::PropertyExamples::Properties

  # @api private
  #
  # Internal object used to differentiate a nil expectation from a default
  # value expectation.
  UNDEFINED_VALUE_EXPECTATION = Object.new.freeze

  private

  def format_expected_value(expected_value) # rubocop:disable Metrics/MethodLength
    if expected_value.is_a?(Proc)
      object_tools = SleepingKingStudios::Tools::Toolbelt.instance.object_tools

      if expected_value.arity.zero?
        comparable_value = object_tools.apply(self, expected_value)
      else
        comparable_value = satisfy do |actual_value|
          object_tools.apply(self, expected_value, actual_value)
        end
      end
    else
      comparable_value = expected_value
    end

    comparable_value
  end
end
