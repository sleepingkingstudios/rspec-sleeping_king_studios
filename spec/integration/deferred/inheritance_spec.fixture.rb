# frozen_string_literal: true

require 'support/integration/deferred/rocket_examples'
require 'support/models/rocket'

RSpec.describe Spec::Models::Rocket do # rubocop:disable RSpec/EmptyExampleGroup
  subject(:rocket) { described_class.new('Imp IV') }

  let(:expected_type) { :rocket }

  include Spec::Integration::Deferred::RocketExamples
end
