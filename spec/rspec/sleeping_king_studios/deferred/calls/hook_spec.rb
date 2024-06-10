# frozen_string_literal: true

require 'rspec/sleeping_king_studios/concerns/example_constants'
require 'rspec/sleeping_king_studios/deferred/calls/hook'

require 'support/shared_examples/deferred_call_examples'

RSpec.describe RSpec::SleepingKingStudios::Deferred::Calls::Hook do
  extend  RSpec::SleepingKingStudios::Concerns::ExampleConstants
  include Spec::Support::SharedExamples::DeferredCallExamples

  subject(:deferred) do
    described_class.new(method_name, *arguments, **keywords, &block)
  end

  let(:method_name) { :before }
  let(:scope)       { :example }
  let(:arguments)   { [scope] }
  let(:keywords)    { {} }
  let(:block)       { -> {} }
  let(:receiver)    { instance_double(Spec::ExampleGroup, before: nil) }

  example_class 'Spec::ExampleGroup' do |klass|
    klass.define_method(:before) { |*, **| nil }
  end

  include_examples 'should be a deferred call',
    other_arguments:   %i[context other arguments],
    other_method_name: :after

  describe '.new' do
    describe 'with method_name: :around and scope: :context' do
      let(:method_name) { :around }
      let(:arguments)   { %i[context] }
      let(:error_message) do
        'scope for an :around hook must be :example'
      end

      it 'should raise an exception' do
        expect do
          described_class.new(method_name, *arguments, **keywords, &block)
        end
          .to raise_error ArgumentError, error_message
      end
    end

    describe 'with method_name: invalid' do
      let(:method_name) { :eventually }
      let(:error_message) do
        'invalid hook method :eventually'
      end

      it 'should raise an exception' do
        expect do
          described_class.new(method_name, *arguments, **keywords, &block)
        end
          .to raise_error ArgumentError, error_message
      end
    end

    describe 'with scope: nil' do
      let(:arguments) { [] }
      let(:error_message) do
        "scope can't be blank"
      end

      it 'should raise an exception' do
        expect do
          described_class.new(method_name, *arguments, **keywords, &block)
        end
          .to raise_error ArgumentError, error_message
      end
    end

    describe 'with scope: an Object' do
      let(:arguments) { [Object.new.freeze] }
      let(:error_message) do
        'scope is not a String or a Symbol'
      end

      it 'should raise an exception' do
        expect do
          described_class.new(method_name, *arguments, **keywords, &block)
        end
          .to raise_error ArgumentError, error_message
      end
    end

    describe 'with scope: an empty String' do
      let(:arguments) { [''] }
      let(:error_message) do
        "scope can't be blank"
      end

      it 'should raise an exception' do
        expect do
          described_class.new(method_name, *arguments, **keywords, &block)
        end
          .to raise_error ArgumentError, error_message
      end
    end

    describe 'with scope: an empty Symbol' do
      let(:arguments) { [:''] }
      let(:error_message) do
        "scope can't be blank"
      end

      it 'should raise an exception' do
        expect do
          described_class.new(method_name, *arguments, **keywords, &block)
        end
          .to raise_error ArgumentError, error_message
      end
    end

    describe 'with scope: invalid' do
      let(:arguments) { %i[never] }
      let(:error_message) do
        'scope for a :before hook must be :context, :each, or :example'
      end

      it 'should raise an exception' do
        expect do
          described_class.new(method_name, *arguments, **keywords, &block)
        end
          .to raise_error ArgumentError, error_message
      end
    end

    describe 'without a block' do
      let(:block) { nil }
      let(:error_message) do
        'no block given'
      end

      it 'should raise an exception' do
        expect do
          described_class.new(method_name, *arguments, **keywords, &block)
        end
          .to raise_error ArgumentError, error_message
      end
    end
  end

  describe '#scope' do
    it { expect(deferred).to respond_to(:scope).with(0).arguments }

    context 'when initialized with scope: :context' do
      let(:arguments) { %i[context] }

      it { expect(deferred.scope).to be :context }
    end

    context 'when initialized with scope: :each' do
      let(:arguments) { %i[each] }

      it { expect(deferred.scope).to be :each }
    end

    context 'when initialized with scope: :example' do
      let(:arguments) { %i[example] }

      it { expect(deferred.scope).to be :example }
    end
  end
end
