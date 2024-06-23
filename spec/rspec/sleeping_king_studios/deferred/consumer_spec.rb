# frozen_string_literal: true

require 'rspec/sleeping_king_studios/concerns/example_constants'
require 'rspec/sleeping_king_studios/deferred/consumer'
require 'rspec/sleeping_king_studios/deferred/provider'

require 'support/isolated_example_group'
require 'support/shared_examples/deferred_registry_examples'

RSpec.describe RSpec::SleepingKingStudios::Deferred::Consumer do
  extend RSpec::SleepingKingStudios::Concerns::ExampleConstants
  include Spec::Support::SharedExamples::DeferredRegistryExamples

  let(:described_class)   { Spec::ExampleGroup }
  let(:ancestor_class)    { Spec::InheritedExamples }
  let(:ancestor_examples) { ancestor_class }

  example_constant 'Spec::InheritedExamples' do
    Spec::Support.isolated_example_group do
      include RSpec::SleepingKingStudios::Deferred::Provider
      include RSpec::SleepingKingStudios::Deferred::Consumer # rubocop:disable RSpec/DescribedClass
    end
  end

  example_constant 'Spec::ExampleGroup' do
    Spec::Support.isolated_example_group(Spec::InheritedExamples)
  end

  include_examples 'should implement including deferred examples'
end
