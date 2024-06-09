# frozen_string_literal: true

require 'rspec/sleeping_king_studios/concerns/example_constants'
require 'rspec/sleeping_king_studios/deferred/examples'

require 'support/shared_examples/deferred_examples'

RSpec.describe RSpec::SleepingKingStudios::Deferred::Examples do
  extend  RSpec::SleepingKingStudios::Concerns::ExampleConstants
  include Spec::Support::SharedExamples::DeferredExamples

  subject(:definitions) { described_class }

  let(:described_class)   { Spec::DeferredExamples }
  let(:ancestor_class)    { Spec::InheritedExamples }
  let(:ancestor_examples) { ancestor_class }

  example_constant 'Spec::InheritedExamples' do
    Module.new do
      include RSpec::SleepingKingStudios::Deferred::Examples
    end
  end

  example_constant 'Spec::DeferredExamples' do
    Module.new do
      include RSpec::SleepingKingStudios::Deferred::Examples
      include Spec::InheritedExamples
    end
  end

  include_examples 'should define deferred calls'

  include_examples 'should define deferred examples'

  include_examples 'should define deferred example groups'

  include_examples 'should define deferred hooks'

  include_examples 'should define memoized helpers'
end
