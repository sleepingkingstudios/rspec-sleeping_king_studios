# frozen_string_literal: true

require 'rspec/sleeping_king_studios'

require 'support/integration/deferred'

module Spec::Integration::Deferred
  module CrewExamples
    include RSpec::SleepingKingStudios::Deferred::Examples

    shared_context 'when the rocket is launched with a crew' do
      let(:launch_site) { 'KSC' }
      let(:crew)        { %w[Valentina Grace Rosalind] }

      before(:example) { rocket.launch(launch_site:, crew:) }
    end

    shared_examples 'should return the last launched crew' do
      it { expect(rocket.crew).to be == crew }
    end

    let(:crew) { [] }

    include_examples 'should return the last launched crew'

    describe '#launch' do
      context 'when the rocket is launched with a crew' do
        include_context 'when the rocket is launched with a crew'

        include_examples 'should return the last launched crew'
      end
    end
  end
end
