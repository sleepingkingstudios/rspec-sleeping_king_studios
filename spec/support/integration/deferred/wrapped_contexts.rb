# frozen_string_literal: true

require 'rspec/sleeping_king_studios'

require 'support/integration/deferred'

module Spec::Integration::Deferred
  module WrappedContexts
    include RSpec::SleepingKingStudios::Deferred::Provider

    module WhenTheRocketHasBeenLaunchedContext
      include RSpec::SleepingKingStudios::Deferred::Examples

      let?(:launch_site) { 'KSC' }
      let?(:payload)     { {} }

      before(:example) do
        subject.launch(launch_site:, payload:)
      end
    end

    deferred_context 'when the payload includes a booster' do
      let(:payload) { super().merge(booster: true) }
    end

    deferred_context 'when the payload includes a satellite' do
      let(:payload) { super().merge(satellite: true) }
    end
  end
end
