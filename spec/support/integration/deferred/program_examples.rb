# frozen_string_literal: true

require 'rspec/sleeping_king_studios'

require 'support/integration/deferred'

module Spec::Integration::Deferred
  module CustomExampleGroups
    extend RSpec::SleepingKingStudios::Deferred::Examples::Dsl::Meta

    define_example_group_method :custom_example

    define_example_group_method :custom_example_group
  end

  module ProgramExamples
    include RSpec::SleepingKingStudios::Deferred::Examples
    extend  CustomExampleGroups

    custom_example do
      expect(subject).to respond_to(:program).with(0).arguments
    end

    custom_example_group '#program' do
      custom_example do
        expect(subject.program).to be == 'Imp'
      end
    end
  end
end
