# frozen_string_literal: true

require 'support/integration/deferred/crew_examples'

RSpec.describe Spec::Models::Rocket do # rubocop:disable RSpec/EmptyExampleGroup
  subject(:rocket) { described_class.new('Imp IV') }

  include Spec::Integration::Deferred::CrewExamples
end
