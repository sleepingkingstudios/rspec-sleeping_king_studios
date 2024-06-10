# frozen_string_literal: true

require 'rspec/sleeping_king_studios/concerns/example_constants'
require 'rspec/sleeping_king_studios/deferred/calls/included_examples'

require 'support/shared_examples/deferred_call_examples'

RSpec.describe RSpec::SleepingKingStudios::Deferred::Calls::IncludedExamples do
  extend  RSpec::SleepingKingStudios::Concerns::ExampleConstants
  include Spec::Support::SharedExamples::DeferredCallExamples

  subject(:deferred) do
    described_class.new(method_name, *arguments, **keywords, &block)
  end

  let(:method_name) { :it_should_behave_like }
  let(:name)        { 'should do the thing' }
  let(:arguments)   { [name] }
  let(:keywords)    { {} }
  let(:block)       { -> {} }
  let(:receiver) do
    instance_double(Spec::ExampleGroup, it_should_behave_like: nil)
  end

  example_class 'Spec::ExampleGroup' do |klass|
    klass.define_method(:it_should_behave_like) { |*, **| nil }
  end

  include_examples 'should be a deferred call',
    other_arguments: ['should do the time warp', :other, :arguments]

  describe '.new' do
    let(:error_message) do
      'shared example group name must be a non-empty String, Symbol, or Module'
    end

    describe 'with name: nil' do
      let(:name) { nil }

      it 'should raise an exception' do
        expect { described_class.new(method_name, name, &block) }
          .to raise_error ArgumentError, error_message
      end
    end

    describe 'with name: an Object' do
      let(:name) { Object.new.freeze }

      it 'should raise an exception' do
        expect { described_class.new(method_name, name, &block) }
          .to raise_error ArgumentError, error_message
      end
    end

    describe 'with name: an empty String' do
      let(:name) { '' }

      it 'should raise an exception' do
        expect { described_class.new(method_name, name, &block) }
          .to raise_error ArgumentError, error_message
      end
    end

    describe 'with name: an empty Symbol' do
      let(:name) { :'' }

      it 'should raise an exception' do
        expect { described_class.new(method_name, name, &block) }
          .to raise_error ArgumentError, error_message
      end
    end
  end

  describe '#name' do
    it { expect(deferred).to respond_to(:name).with(0).arguments }

    context 'when initialized with name: a Module' do
      let(:name) { String }

      it { expect(deferred.name).to be == name }
    end

    context 'when initialized with name: a String' do
      it { expect(deferred.name).to be == name }
    end

    context 'when initialized with name: a Symbol' do
      let(:name) { :does_something }

      it { expect(deferred.name).to be == name }
    end
  end
end
