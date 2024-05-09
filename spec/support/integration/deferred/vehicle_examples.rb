# frozen_string_literal: true

require 'rspec/sleeping_king_studios'

require 'support/integration/deferred'
require 'support/integration/deferred/naming_examples'

module Spec::Integration::Deferred
  module VehicleExamples
    include RSpec::SleepingKingStudios::Deferred::Examples

    describe '#name' do # rubocop:disable RSpec/EmptyExampleGroup
      include Spec::Integration::Deferred::NamingExamples
    end

    describe '#type' do
      it { expect(subject).to respond_to(:type).with(0).arguments }

      it { expect(subject.type).to be == expected_type }
    end
  end
end
