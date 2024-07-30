# frozen_string_literal: true

require 'support/integration/deferred/wrapped_contexts'

RSpec.describe Spec::Models::Rocket do
  include RSpec::SleepingKingStudios::Deferred::Consumer
  include Spec::Integration::Deferred::WrappedContexts

  subject(:rocket) { described_class.new('Imp IV') }

  wrap_deferred 'when the rocket has been launched' do
    it { expect(rocket.launched?).to be true }

    wrap_deferred 'when the payload includes a booster' do
      let(:expected_payload) { { booster: true } }

      it { expect(rocket.payload).to be == expected_payload }
    end

    wrap_deferred 'when the payload includes a satellite' do
      let(:expected_payload) { { satellite: true } }

      it { expect(rocket.payload).to be == expected_payload }
    end

    context 'when the rocket has multiple payloads' do
      let(:expected_payload) { { booster: true, satellite: true } }

      include_deferred 'when the payload includes a booster'
      include_deferred 'when the payload includes a satellite'

      it { expect(rocket.payload).to be == expected_payload }
    end
  end
end
