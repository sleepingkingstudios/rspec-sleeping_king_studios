# frozen_string_literal: true

require 'support/integration/deferred/parameterized_examples'

RSpec.describe Spec::Models::Rocket do
  include RSpec::SleepingKingStudios::Deferred::Consumer
  include Spec::Integration::Deferred::ParameterizedExamples

  subject(:rocket) { described_class.new('Imp IV') }

  finclude_deferred 'should be a SpaceVehicle'

  fwrap_deferred 'should behave like a rocket' # rubocop:disable RSpec/Focus

  it { expect(rocket.type).to be :submarine }
end
