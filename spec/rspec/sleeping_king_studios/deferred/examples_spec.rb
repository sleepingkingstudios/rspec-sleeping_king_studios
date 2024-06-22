# frozen_string_literal: true

require 'rspec/sleeping_king_studios/concerns/example_constants'
require 'rspec/sleeping_king_studios/deferred/examples'

require 'support/shared_examples/deferred_examples'
require 'support/shared_examples/deferred_registry_examples'

RSpec.describe RSpec::SleepingKingStudios::Deferred::Examples do
  extend  RSpec::SleepingKingStudios::Concerns::ExampleConstants
  include Spec::Support::SharedExamples::DeferredExamples
  include Spec::Support::SharedExamples::DeferredRegistryExamples

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

  describe '.description' do
    let(:module_name) { 'ShouldDoSomething' }

    before(:example) do
      allow(described_class).to receive(:name).and_return(module_name)
    end

    it { expect(described_class).to respond_to(:description).with(0).arguments }

    it { expect(described_class.description).to be == 'should do something' }

    describe 'with an anonymous Module' do
      let(:module_name) { nil }

      it { expect(described_class.description).to be == '(anonymous examples)' }
    end

    describe 'with a scoped Module' do
      let(:module_name) { 'Namespace::Examples::ShouldDoSomething' }

      it { expect(described_class.description).to be == 'should do something' }
    end

    describe 'with a Module name ending in "Context"' do
      let(:module_name) { 'ShouldDoSomethingContext' }

      it { expect(described_class.description).to be == 'should do something' }
    end

    describe 'with a Module name ending in "Example"' do
      let(:module_name) { 'ShouldDoSomethingExample' }

      it { expect(described_class.description).to be == 'should do something' }
    end

    describe 'with a Module name ending in "Examples"' do
      let(:module_name) { 'ShouldDoSomethingExamples' }

      it { expect(described_class.description).to be == 'should do something' }
    end
  end

  describe '.description=' do
    it { expect(described_class).to respond_to(:description=).with(1).argument }

    describe 'with nil' do
      let(:error_message) { "description can't be blank" }

      it 'should raise an exception' do
        expect { described_class.description = nil }
          .to raise_error ArgumentError, error_message
      end
    end

    describe 'with an Object' do
      let(:error_message) { 'description is not a String or a Symbol' }

      it 'should raise an exception' do
        expect { described_class.description = Object.new.freeze }
          .to raise_error ArgumentError, error_message
      end
    end

    describe 'with an empty String' do
      let(:error_message) { "description can't be blank" }

      it 'should raise an exception' do
        expect { described_class.description = '' }
          .to raise_error ArgumentError, error_message
      end
    end

    describe 'with an empty Symbol' do
      let(:error_message) { "description can't be blank" }

      it 'should raise an exception' do
        expect { described_class.description = :'' }
          .to raise_error ArgumentError, error_message
      end
    end

    describe 'with a valid String' do
      let(:value) { 'should behave like a BasicObject' }

      it 'should set the description' do
        expect { described_class.description = value }
          .to change(described_class, :description)
          .to be == value
      end
    end

    describe 'with a valid Symbol' do
      let(:value)    { :should_behave_like_a_BasicObject }
      let(:expected) { 'should behave like a BasicObject' }

      it 'should set the description' do
        expect { described_class.description = value }
          .to change(described_class, :description)
          .to be == expected
      end
    end
  end

  include_examples 'should define deferred calls'

  include_examples 'should define deferred examples'

  include_examples 'should define deferred example groups'

  include_examples 'should define deferred hooks'

  include_examples 'should define deferred shared example groups'

  include_examples 'should define memoized helpers'

  include_examples 'should define a registry for deferred examples'

  include_examples 'should implement including deferred examples'
end
