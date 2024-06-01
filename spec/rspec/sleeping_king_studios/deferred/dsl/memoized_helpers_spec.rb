# frozen_string_literal: true

require 'rspec/sleeping_king_studios/concerns/example_constants'
require 'rspec/sleeping_king_studios/deferred/dsl/hooks'
require 'rspec/sleeping_king_studios/deferred/dsl/memoized_helpers'
require 'rspec/sleeping_king_studios/matchers/built_in/respond_to'
require 'rspec/sleeping_king_studios/matchers/core/have_constant'

require 'support/isolated_example_group'

require 'support/shared_examples/deferred_examples'

RSpec.describe RSpec::SleepingKingStudios::Deferred::Dsl::MemoizedHelpers do
  extend  RSpec::SleepingKingStudios::Concerns::ExampleConstants
  include Spec::Support::SharedExamples::DeferredExamples

  subject(:definitions) { described_class }

  let(:described_class)   { Spec::DeferredExamples }
  let(:ancestor_class)    { Spec::InheritedExamples }
  let(:ancestor_examples) { ancestor_class }

  example_constant 'Spec::InheritedExamples' do
    Module.new do
      extend RSpec::SleepingKingStudios::Deferred::Definitions
      extend RSpec::SleepingKingStudios::Deferred::Dsl::Hooks
      extend RSpec::SleepingKingStudios::Deferred::Dsl::MemoizedHelpers
    end
  end

  example_constant 'Spec::DeferredExamples' do
    Module.new do
      extend  RSpec::SleepingKingStudios::Deferred::Definitions
      extend  RSpec::SleepingKingStudios::Deferred::Dsl::Hooks
      extend  RSpec::SleepingKingStudios::Deferred::Dsl::MemoizedHelpers
      include Spec::InheritedExamples
    end
  end

  include_examples 'should define memoized helpers'
end
