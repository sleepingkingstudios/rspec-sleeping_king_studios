# frozen_string_literal: true

require 'support/integration/deferred'

module Spec::Integration::Deferred
  module ShouldSetTheOrbit
    include RSpec::SleepingKingStudios::Deferred::Examples

    let?(:expected_orbit) { nil }

    it 'should set the orbit' do
      launch_rocket

      expect(subject.orbit).to eq expected_orbit
    end
  end

  module OrbitExamples
    include RSpec::SleepingKingStudios::Deferred::Examples

    describe '#launch' do
      let(:launch_site) { 'KSC' }
      let(:options)     { {} }

      def launch_rocket
        subject.launch(launch_site:, **options)
      end

      context 'when the rocket is launched' do # rubocop:disable RSpec/EmptyExampleGroup
        include Spec::Integration::Deferred::ShouldSetTheOrbit
      end

      describe 'with orbit: value' do
        let(:expected_orbit) { options[:orbit] }
        let(:options) { { orbit: { periapsis: '100 km', apoapsis: '300 km' } } }

        context 'when the rocket is launched' do # rubocop:disable RSpec/EmptyExampleGroup
          include Spec::Integration::Deferred::ShouldSetTheOrbit
        end
      end
    end

    describe '#orbit' do
      it { expect(subject.orbit).to be nil }
    end
  end
end
