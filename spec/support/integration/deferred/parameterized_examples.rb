# frozen_string_literal: true

require 'rspec/sleeping_king_studios'

require 'support/integration/deferred'

module Spec::Integration::Deferred
  module ParameterizedExamples
    include RSpec::SleepingKingStudios::Deferred::Provider

    module ShouldBehaveLikeARocketExamples
      include RSpec::SleepingKingStudios::Deferred::Examples

      describe '#launch' do
        it { expect(subject).to respond_to(:launch) }
      end
    end

    module ShouldBeASpaceVehicleExamples
      include RSpec::SleepingKingStudios::Deferred::Examples

      self.description = 'should be a SpaceVehicle'

      it { expect(subject).to be_a Spec::Models::SpaceVehicle }
    end

    deferred_examples 'should be a Vehicle' do |vehicle_type:|
      it { expect(subject).to be_a Spec::Models::Vehicle }

      describe '#type' do
        it { expect(subject.type).to be == vehicle_type }
      end
    end
  end
end
