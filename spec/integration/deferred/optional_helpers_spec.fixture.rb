# frozen_string_literal: true

require 'support/integration/deferred/orbit_examples'

RSpec.describe Spec::Models::Rocket do
  subject(:rocket) { described_class.new('Imp IV') }

  include Spec::Integration::Deferred::OrbitExamples
end
