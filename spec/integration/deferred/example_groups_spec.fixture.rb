# frozen_string_literal: true

require 'support/integration/deferred/launch_examples'
require 'support/models/rocket'

RSpec.describe Spec::Models::Rocket do
  subject(:rocket) { described_class.new('Imp IV') }

  include Spec::Integration::Deferred::LaunchExamples
end
