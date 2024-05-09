# frozen_string_literal: true

require 'support/integration/deferred'

module Spec::Integration::Deferred
  module LaunchExamples
    include RSpec::SleepingKingStudios::Deferred::Examples

    describe '#launch' do
      let(:launch_site) { 'KSC' }

      def launch_rocket
        subject.launch(launch_site: launch_site)
      end

      it 'should launch the rocket' do
        expect { launch_rocket }.to change(subject, :launched?).to be true
      end

      it 'should set the launch site' do
        expect { launch_rocket }
          .to change(subject, :launch_site)
          .to be == launch_site
      end
    end

    describe '#launch_site' do
      it { expect(subject.launch_site).to be nil }
    end

    describe '#launched?' do
      it { expect(subject.launched?).to be false }
    end
  end
end
