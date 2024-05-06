# frozen_string_literal: true

require 'rspec/sleeping_king_studios/concerns/example_constants'
require 'rspec/sleeping_king_studios/deferred/examples'
require 'rspec/sleeping_king_studios/matchers/built_in/respond_to'

RSpec.describe RSpec::SleepingKingStudios::Deferred::Examples do
  extend RSpec::SleepingKingStudios::Concerns::ExampleConstants

  shared_examples 'should define an example macro' do |method_name|
    let(:arguments) { %w[tag_0 tag_1] }
    let(:keywords)  { { option: 'value' } }
    let(:block)     { -> {} }

    it 'should define the class method' do
      expect(described_class)
        .to respond_to(method_name)
        .with(0).arguments
        .and_unlimited_arguments
        .and_any_keywords
        .and_a_block
    end

    it 'should add a deferred example to the class' do
      expect do
        described_class.send(method_name, *arguments, **keywords, &block)
      end
        .to change(described_class, :ordered_deferred_calls)
    end

    it 'should define a deferred example', :aggregate_failures do
      described_class.send(method_name, *arguments, **keywords, &block)

      deferred = described_class.send(:ordered_deferred_calls)[:example].last

      expect(deferred).to be_a(RSpec::SleepingKingStudios::Deferred::Example)
      expect(deferred.method_name).to be method_name
      expect(deferred.arguments).to be == arguments
      expect(deferred.keywords).to be == keywords
      expect(deferred.block).to be == block
    end

    context 'when the deferred examples are called' do
      let(:example_group) { instance_double(RSpec::Core::ExampleGroup) }

      it 'should call the deferred example' do
        described_class.send(method_name, *arguments, **keywords, &block)

        deferred = described_class.send(:ordered_deferred_calls)[:example].last

        allow(deferred).to receive(:call)

        described_class.call(example_group)

        expect(deferred).to have_received(:call).with(example_group)
      end
    end
  end

  let(:described_class) { Spec::DeferredExamples }

  example_class 'Spec::DeferredExamples' do |klass|
    klass.include RSpec::SleepingKingStudios::Deferred::Examples # rubocop:disable RSpec/DescribedClass
  end

  describe '.call' do
    it 'should define the class method' do
      expect(described_class).to respond_to(:call).with(1).argument
    end
  end

  describe '.example' do
    include_examples 'should define an example macro', :example
  end

  describe '.fexample' do
    include_examples 'should define an example macro', :fexample
  end

  describe '.fit' do
    include_examples 'should define an example macro', :fit
  end

  describe '.focus' do
    include_examples 'should define an example macro', :focus
  end

  describe '.fspecify' do
    include_examples 'should define an example macro', :fspecify
  end

  describe '.it' do
    include_examples 'should define an example macro', :it
  end

  describe '.ordered_deferred_calls' do
    it 'should define the private class reader' do
      expect(described_class)
        .to respond_to(:ordered_deferred_calls, true)
        .with(0).arguments
    end

    it { expect(described_class.send(:ordered_deferred_calls)).to be == {} }
  end

  describe '.pending' do
    include_examples 'should define an example macro', :pending
  end

  describe '.skip' do
    include_examples 'should define an example macro', :skip
  end

  describe '.specify' do
    include_examples 'should define an example macro', :specify
  end

  describe '.xexample' do
    include_examples 'should define an example macro', :xexample
  end

  describe '.xit' do
    include_examples 'should define an example macro', :xit
  end

  describe '.xspecify' do
    include_examples 'should define an example macro', :xspecify
  end
end
