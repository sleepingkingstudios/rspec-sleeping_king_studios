# frozen_string_literal: true

require 'rspec/sleeping_king_studios'

require 'support/integration/deferred'
require 'support/integration/deferred/launch_examples'
require 'support/integration/deferred/vehicle_examples'

module Spec::Integration::Deferred
  module RocketExamples
    include RSpec::SleepingKingStudios::Deferred::Examples
    include Spec::Integration::Deferred::VehicleExamples
    include Spec::Integration::Deferred::LaunchExamples
  end
end
