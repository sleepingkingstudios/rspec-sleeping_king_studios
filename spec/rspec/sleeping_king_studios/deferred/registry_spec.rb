# frozen_string_literal: true

require 'rspec/sleeping_king_studios/concerns/example_constants'
require 'rspec/sleeping_king_studios/deferred/registry'

require 'support/isolated_example_group'
require 'support/shared_examples/deferred_registry_examples'

RSpec.describe RSpec::SleepingKingStudios::Deferred::Registry do
  extend RSpec::SleepingKingStudios::Concerns::ExampleConstants
  include Spec::Support::SharedExamples::DeferredRegistryExamples

  subject(:registry) { described_class }

  let(:described_class)   { Spec::ExampleGroup }
  let(:ancestor_class)    { Spec::InheritedExamples }
  let(:ancestor_examples) { ancestor_class }

  example_class 'Spec::InheritedExamples' do |klass|
    klass.include RSpec::SleepingKingStudios::Deferred::Registry # rubocop:disable RSpec/DescribedClass
  end

  example_class 'Spec::ExampleGroup', 'Spec::InheritedExamples'

  describe '::DeferredExamplesNotFoundError' do
    it 'should define the constant' do
      expect(described_class).to define_constant(:DeferredExamplesNotFoundError)
    end

    it 'should be an exception', :aggregate_failures do
      expect(described_class::DeferredExamplesNotFoundError).to be_a Class
      expect(described_class::DeferredExamplesNotFoundError)
        .to be < StandardError
    end
  end

  include_examples 'should define a registry for deferred examples'
end
