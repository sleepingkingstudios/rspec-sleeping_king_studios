# frozen_string_literal: true

require 'rspec/sleeping_king_studios/concerns/example_constants'
require 'rspec/sleeping_king_studios/deferred/definitions'
require 'rspec/sleeping_king_studios/deferred/missing'

require 'support/isolated_example_group'

RSpec.describe RSpec::SleepingKingStudios::Deferred::Missing do
  extend RSpec::SleepingKingStudios::Concerns::ExampleConstants

  shared_context 'when there are missing calls' do
    example_implementations = [ # rubocop:disable RSpec/LeakyLocalVariable
      -> { expect(1).to be_a Integer }, # rubocop:disable RSpec/ExpectActual
      -> { it { expect(Object.new.freeze).to be_a Object } }
    ]

    let(:expected_missing) do
      [
        RSpec::SleepingKingStudios::Deferred::Call.new(
          :custom_example,
          'should be an Integer',
          :aggregate_failures,
          &example_implementations[0]
        ),
        RSpec::SleepingKingStudios::Deferred::Call.new(
          :custom_example_group,
          'should be numeric',
          focus: false,
          &example_implementations[1]
        )
      ]
    end

    before(:example) do
      described_class.custom_example(
        'should be an Integer',
        :aggregate_failures,
        &example_implementations[0]
      )

      described_class.custom_example_group(
        'should be numeric',
        focus: false,
        &example_implementations[1]
      )
    end
  end

  let(:described_class) { Spec::DeferredExamples }

  example_constant 'Spec::DeferredExamples' do
    Module.new do
      include RSpec::SleepingKingStudios::Deferred::Definitions
      include RSpec::SleepingKingStudios::Deferred::Missing
    end
  end

  describe '.call' do
    context 'when there are missing calls' do
      include_context 'when there are missing calls'

      let(:deferred_calls) do
        described_class.deferred_calls
      end
      let(:example_group) do
        instance_double(RSpec::Core::ExampleGroup)
      end

      before(:example) do
        deferred_calls.each { |deferred| allow(deferred).to receive(:call) }
      end

      it 'should call the deferred calls in order' do
        described_class.call(example_group)

        expect(deferred_calls).to all have_received(:call).with(example_group)
      end
    end
  end

  describe '.included' do
    context 'when there are missing calls' do
      include_context 'when there are missing calls'

      let(:deferred_calls) do
        described_class.deferred_calls
      end
      let(:example_group) do
        Spec::Support.isolated_example_group
      end

      before(:example) do
        deferred_calls.each { |deferred| allow(deferred).to receive(:call) }
      end

      it 'should call the deferred calls in order' do
        example_group.include(described_class)

        expect(deferred_calls).to all have_received(:call).with(example_group)
      end
    end
  end

  describe '.method_missing' do
    let(:method_name) { :custom_example }
    let(:arguments)   { %w[tag_0 tag_1] }
    let(:keywords)    { { option: 'value' } }
    let(:block)       { -> {} }

    it 'should add a deferred call to the class' do
      expect do
        described_class.send(method_name, *arguments, **keywords, &block)
      end
        .to change(described_class, :deferred_calls)
    end

    it 'should define a deferred call', :aggregate_failures do
      described_class.send(method_name, *arguments, **keywords, &block)

      deferred = described_class.deferred_calls.last

      expect(deferred).to be_a(RSpec::SleepingKingStudios::Deferred::Call)
      expect(deferred.method_name).to be method_name
      expect(deferred.arguments).to be == arguments
      expect(deferred.keywords).to be == keywords
      expect(deferred.block).to be == block
    end

    context 'when the deferred examples are called' do
      let(:example_group) { instance_double(RSpec::Core::ExampleGroup) }

      it 'should call the deferred example' do
        described_class.send(method_name, *arguments, **keywords, &block)

        deferred = described_class.deferred_calls.last

        allow(deferred).to receive(:call)

        described_class.call(example_group)

        expect(deferred).to have_received(:call).with(example_group)
      end
    end
  end
end
