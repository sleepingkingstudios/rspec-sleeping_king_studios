# frozen_string_literal: true

require 'support/integration/deferred/naming_examples'
require 'support/models/rocket'

RSpec.describe Spec::Models::Rocket do
  subject(:rocket) { described_class.new('Imp IV') }

  describe '#name' do
    include Spec::Integration::Deferred::NamingExamples
  end
end
