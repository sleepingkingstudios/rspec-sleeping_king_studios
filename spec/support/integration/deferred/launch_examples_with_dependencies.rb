# frozen_string_literal: true

require 'support/integration/deferred'

module Spec::Integration::Deferred
  module LaunchExamplesWithDependencies
    include RSpec::SleepingKingStudios::Deferred::Consumer

    deferred_examples 'should launch the rocket' do
      include RSpec::SleepingKingStudios::Deferred::Dependencies

      depends_on :launch_site

      depends_on :rocket, 'the pointy end points toward space'

      describe '#launch' do
        it { expect { rocket.launch(launch_site:) }.not_to raise_error }
      end
    end
  end
end
