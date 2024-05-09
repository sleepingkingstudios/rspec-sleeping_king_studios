# frozen_string_literal: true

require 'rspec/sleeping_king_studios'

require 'support/integration/deferred'

module Spec::Integration::Deferred
  module NamingExamples
    include RSpec::SleepingKingStudios::Deferred::Examples

    it { expect(subject).to respond_to(:name).with(0).arguments }

    it { expect(subject.name).to be_a String }
  end
end
