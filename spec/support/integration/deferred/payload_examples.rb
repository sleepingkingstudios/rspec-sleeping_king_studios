# frozen_string_literal: true

require 'support/integration/deferred'

module Spec::Integration::Deferred
  module ShouldNotChangeThePreviousPayload
    include RSpec::SleepingKingStudios::Deferred::Examples

    let!(:previous_payload) { subject.payload }

    it 'should not change the previous payload' do
      launch_rocket(payload:)

      expect(previous_payload).to be == {}
    end
  end

  module WhenThePayloadIncludesABattery
    include RSpec::SleepingKingStudios::Deferred::Examples

    let(:payload) { super().merge(battery: true) }
  end

  module WhenThePayloadIncludesASolarArray
    include RSpec::SleepingKingStudios::Deferred::Examples

    let(:payload) { super().merge(solar_array: true) }
  end

  module WhenThePayloadIncludesExperiments
    include RSpec::SleepingKingStudios::Deferred::Examples

    let(:payload) { super().merge(experiments: true) }
  end

  module PayloadExamples
    include RSpec::SleepingKingStudios::Deferred::Examples

    describe '#launch' do
      let(:launch_site) { 'KSC' }
      let(:payload)     { {} }

      def launch_rocket(**options)
        subject.launch(launch_site:, **options)
      end

      context 'when the rocket has a basic payload' do
        include Spec::Integration::Deferred::WhenThePayloadIncludesABattery
        include Spec::Integration::Deferred::ShouldNotChangeThePreviousPayload

        let(:expected) { { battery: true } }

        it 'should set the payload' do
          expect { launch_rocket(payload:) }
            .to change(rocket, :payload)
            .to be == expected
        end
      end

      context 'when the rocket has a complex payload' do
        include Spec::Integration::Deferred::WhenThePayloadIncludesABattery
        include Spec::Integration::Deferred::WhenThePayloadIncludesASolarArray
        include Spec::Integration::Deferred::WhenThePayloadIncludesExperiments

        let(:expected) do
          { battery: true, experiments: true, solar_array: true }
        end

        it 'should set the payload' do
          expect { launch_rocket(payload:) }
            .to change(rocket, :payload)
            .to be == expected
        end
      end
    end

    describe '#payload' do
      it { expect(subject.payload).to be == {} }
    end
  end
end
