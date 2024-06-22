# frozen_string_literal: true

require 'support/integration/deferred/parameterized_examples'

RSpec.describe Spec::Models::Rocket do
  include RSpec::SleepingKingStudios::Deferred::Consumer
  include Spec::Integration::Deferred::ParameterizedExamples

  subject(:rocket) { described_class.new('Imp IV') }

  include_deferred 'should be a Vehicle', vehicle_type: :rocket

  include_deferred 'should be a SpaceVehicle'

  include_deferred 'should behave like a rocket'
end
