# frozen_string_literal: true

require 'rspec/sleeping_king_studios'

require 'support/integration/deferred'

module Spec::Integration::Deferred
  module OrdinalExamples
    include RSpec::SleepingKingStudios::Deferred::Examples
    include RSpec::SleepingKingStudios::Deferred::Missing

    custom_example do
      expect(subject).to respond_to(:ordinal).with(0).arguments
    end

    custom_example_group '#ordinal' do
      custom_example do
        expect(subject.ordinal).to be == 'IV'
      end
    end
  end
end
