# frozen_string_literal: true

require 'rspec/sleeping_king_studios/concerns/example_constants'
require 'rspec/sleeping_king_studios/deferred/calls/example_group'
require 'rspec/sleeping_king_studios/deferred/examples'

require 'support/shared_examples/deferred_call_examples'

RSpec.describe RSpec::SleepingKingStudios::Deferred::Calls::ExampleGroup do
  extend  RSpec::SleepingKingStudios::Concerns::ExampleConstants
  include Spec::Support::SharedExamples::DeferredCallExamples

  subject(:deferred) do
    described_class.new(method_name, *arguments, **keywords, &block)
  end

  let(:method_name) { :describe }
  let(:arguments)   { [] }
  let(:keywords)    { {} }
  let(:block)       { nil }
  let(:receiver)    { instance_double(Spec::ExampleGroup, describe: nil) }

  example_class 'Spec::ExampleGroup' do |klass|
    klass.define_method(:describe) { |*, **| nil }
  end

  include_examples 'should be a deferred call'

  describe '#deferred_example_group' do
    it 'should define the reader' do
      expect(deferred).to respond_to(:deferred_example_group).with(0).arguments
    end

    it { expect(deferred.deferred_example_group).to be nil }

    context 'when initialized with deferred_example_group: value' do
      let(:deferred_example_group) do
        Module.new do
          include RSpec::SleepingKingStudios::Deferred::Examples
        end
      end
      let(:keywords) do
        super().merge(deferred_example_group: deferred_example_group)
      end

      it 'should return the configured value' do
        expect(deferred.deferred_example_group).to be deferred_example_group
      end
    end
  end
end
