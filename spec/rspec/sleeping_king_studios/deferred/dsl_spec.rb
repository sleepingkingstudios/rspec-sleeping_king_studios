# frozen_string_literal: true

require 'rspec/sleeping_king_studios/deferred/definitions'
require 'rspec/sleeping_king_studios/deferred/dsl'

require 'support/shared_examples/deferred_examples'

RSpec.describe RSpec::SleepingKingStudios::Deferred::Dsl do
  extend  RSpec::SleepingKingStudios::Concerns::ExampleConstants
  include Spec::Support::SharedExamples::DeferredExamples

  subject(:definitions) { described_class }

  let(:described_class)   { Spec::DeferredExamples }
  let(:ancestor_class)    { Spec::InheritedExamples }
  let(:ancestor_examples) { ancestor_class }

  example_constant 'Spec::InheritedExamples' do
    Module.new do
      extend RSpec::SleepingKingStudios::Deferred::Definitions
      extend RSpec::SleepingKingStudios::Deferred::Dsl
    end
  end

  example_constant 'Spec::DeferredExamples' do
    Module.new do
      extend  RSpec::SleepingKingStudios::Deferred::Definitions
      extend  RSpec::SleepingKingStudios::Deferred::Dsl
      include Spec::InheritedExamples
    end
  end

  include_examples 'should define deferred examples'

  include_examples 'should define deferred example groups'

  include_examples 'should define deferred hooks'
end
