# frozen_string_literal: true

require 'rspec/sleeping_king_studios/concerns/example_constants'
require 'rspec/sleeping_king_studios/deferred/definitions'
require 'rspec/sleeping_king_studios/deferred/dsl/examples'

require 'support/shared_examples/deferred_examples'

RSpec.describe RSpec::SleepingKingStudios::Deferred::Dsl::Examples do
  extend  RSpec::SleepingKingStudios::Concerns::ExampleConstants
  include Spec::Support::SharedExamples::DeferredExamples

  subject(:definitions) { described_class }

  let(:described_class)   { Spec::DeferredExamples }
  let(:ancestor_class)    { Spec::InheritedExamples }
  let(:ancestor_examples) { ancestor_class }

  example_constant 'Spec::InheritedExamples' do
    Module.new do
      extend RSpec::SleepingKingStudios::Deferred::Definitions
      extend RSpec::SleepingKingStudios::Deferred::Dsl::Examples
    end
  end

  example_constant 'Spec::DeferredExamples' do
    Module.new do
      extend  RSpec::SleepingKingStudios::Deferred::Definitions
      extend  RSpec::SleepingKingStudios::Deferred::Dsl::Examples
      include Spec::InheritedExamples
    end
  end

  include_examples 'should define deferred examples'
end
