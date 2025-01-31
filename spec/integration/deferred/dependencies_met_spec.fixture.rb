# frozen_string_literal: true

require 'rspec/sleeping_king_studios'

require 'support/integration/deferred/launch_examples_with_dependencies'
require 'support/models/rocket'

RSpec.describe 'Rocket' do
  include RSpec::SleepingKingStudios::Deferred::Consumer
  include Spec::Integration::Deferred::LaunchExamplesWithDependencies

  let(:launch_site) { 'KSC' }
  let(:rocket)      { Spec::Models::Rocket.new('Imp IV') }

  include_deferred 'should launch the rocket'
end
