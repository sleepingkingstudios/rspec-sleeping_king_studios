# frozen_string_literal: true

require 'rspec/sleeping_king_studios/concerns/example_constants'
require 'rspec/sleeping_king_studios/deferred/examples/hooks'
require 'rspec/sleeping_king_studios/matchers/built_in/respond_to'

RSpec.describe RSpec::SleepingKingStudios::Deferred::Examples::Hooks do
  extend RSpec::SleepingKingStudios::Concerns::ExampleConstants

  shared_context 'when there are deferred hooks' do
    example_implementations = [
      -> { 'before.deferred.first' },
      -> { 'before.deferred.second' },
      -> { 'prepend_before.deferred' },
      -> { 'after.deferred' },
      -> { 'append_after.deferred' },
      -> { 'around.example' }
    ]

    let(:expected_hooks) do
      [
        RSpec::SleepingKingStudios::Deferred::Hook.new(
          :before,
          :example,
          &example_implementations[0]
        ),
        RSpec::SleepingKingStudios::Deferred::Hook.new(
          :before,
          :example,
          &example_implementations[1]
        ),
        RSpec::SleepingKingStudios::Deferred::Hook.new(
          :prepend_before,
          :example,
          &example_implementations[2]
        ),
        RSpec::SleepingKingStudios::Deferred::Hook.new(
          :after,
          :example,
          &example_implementations[3]
        ),
        RSpec::SleepingKingStudios::Deferred::Hook.new(
          :append_after,
          :example,
          &example_implementations[4]
        ),
        RSpec::SleepingKingStudios::Deferred::Hook.new(
          :around,
          :example,
          &example_implementations[5]
        )
      ].reverse
    end

    before(:example) do
      described_class.before(
        :example,
        &example_implementations[0]
      )

      described_class.before(
        :example,
        &example_implementations[1]
      )

      described_class.prepend_before(
        :example,
        &example_implementations[2]
      )

      described_class.after(
        :example,
        &example_implementations[3]
      )

      described_class.append_after(
        :example,
        &example_implementations[4]
      )

      described_class.around(
        :example,
        &example_implementations[5]
      )
    end
  end

  shared_context 'when there are inherited hooks' do
    example_implementations = [
      -> { 'before.inherited' },
      -> { 'prepend_before.inherited.first' },
      -> { 'prepend_before.inherited.second' }
    ]

    let(:inherited_hooks) do
      [
        RSpec::SleepingKingStudios::Deferred::Hook.new(
          :before,
          :example,
          &example_implementations[0]
        ),
        RSpec::SleepingKingStudios::Deferred::Hook.new(
          :prepend_before,
          :example,
          &example_implementations[1]
        ),
        RSpec::SleepingKingStudios::Deferred::Hook.new(
          :prepend_before,
          :example,
          &example_implementations[2]
        )
      ].reverse
    end

    before(:example) do
      described_class.include(Spec::InheritedHooks)

      Spec::InheritedHooks.before(
        :example,
        &example_implementations[0]
      )

      Spec::InheritedHooks.prepend_before(
        :example,
        &example_implementations[1]
      )

      Spec::InheritedHooks.prepend_before(
        :example,
        &example_implementations[2]
      )
    end
  end

  shared_examples 'should define a hook macro' do |method_name|
    let(:scope)     { :example }
    let(:arguments) { %w[tag_0 tag_1] }
    let(:keywords)  { { option: 'value' } }
    let(:block)     { -> {} }

    it 'should define the class method' do
      expect(described_class)
        .to respond_to(method_name)
        .with(1).argument
        .and_unlimited_arguments
        .and_any_keywords
        .and_a_block
    end

    it 'should add a deferred hook to the class' do
      expect do
        described_class.send(method_name, scope, *arguments, **keywords, &block)
      end
        .to change(described_class, :ordered_deferred_calls)
    end

    it 'should define a deferred hook', :aggregate_failures do
      described_class.send(method_name, scope, *arguments, **keywords, &block)

      deferred = described_class.send(:ordered_deferred_calls).last

      expect(deferred).to be_a(RSpec::SleepingKingStudios::Deferred::Hook)
      expect(deferred.method_name).to be method_name
      expect(deferred.scope).to be == scope
      expect(deferred.arguments).to be == [scope, *arguments]
      expect(deferred.keywords).to be == keywords
      expect(deferred.block).to be == block
    end

    context 'when the deferred examples are called' do
      let(:example_group) { instance_double(RSpec::Core::ExampleGroup) }

      it 'should call the deferred example' do
        described_class.send(method_name, scope, *arguments, **keywords, &block)

        deferred = described_class.send(:ordered_deferred_calls).last

        allow(deferred).to receive(:call)

        described_class.call(example_group)

        expect(deferred).to have_received(:call).with(example_group)
      end
    end
  end

  let(:described_class) { Spec::DeferredHooks }

  example_constant 'Spec::DeferredHooks' do
    Module.new do
      extend RSpec::SleepingKingStudios::Deferred::Examples::Hooks
    end
  end

  example_constant 'Spec::InheritedHooks' do
    Module.new do
      extend RSpec::SleepingKingStudios::Deferred::Examples::Hooks
    end
  end

  describe '.after' do
    include_examples 'should define a hook macro', :after
  end

  describe '.append_after' do
    include_examples 'should define a hook macro', :append_after
  end

  describe '.around' do
    include_examples 'should define a hook macro', :around
  end

  describe '.before' do
    include_examples 'should define a hook macro', :before
  end

  describe '.call' do
    shared_examples 'should call the deferred calls' do
      let(:deferred_calls) do
        described_class.send(:ordered_deferred_calls)
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

    it 'should define the class method' do
      expect(described_class).to respond_to(:call).with(1).argument
    end

    context 'when there are deferred hooks' do
      include_context 'when there are deferred hooks'

      include_examples 'should call the deferred calls'
    end

    context 'when there are inherited hooks' do
      include_context 'when there are inherited hooks'

      include_examples 'should call the deferred calls'
    end

    context 'when there are deferred and inherited hooks' do
      include_context 'when there are deferred hooks'
      include_context 'when there are inherited hooks'

      include_examples 'should call the deferred calls'
    end
  end

  describe '.included' do
    shared_examples 'should call the deferred calls' do
      let(:deferred_calls) do
        described_class.send(:ordered_deferred_calls)
      end
      let(:example_group) do
        Class.new(RSpec::Core::ExampleGroup)
      end

      before(:example) do
        deferred_calls.each { |deferred| allow(deferred).to receive(:call) }
      end

      it 'should call the deferred calls in order' do
        example_group.include(described_class)

        expect(deferred_calls).to all have_received(:call).with(example_group)
      end
    end

    context 'when there are deferred hooks' do
      include_context 'when there are deferred hooks'

      include_examples 'should call the deferred calls'
    end

    context 'when there are inherited hooks' do
      include_context 'when there are inherited hooks'

      include_examples 'should call the deferred calls'
    end

    context 'when there are deferred and inherited hooks' do
      include_context 'when there are deferred hooks'
      include_context 'when there are inherited hooks'

      include_examples 'should call the deferred calls'
    end
  end

  describe '.ordered_deferred_calls' do
    let(:expected) { [] }

    it 'should define the private class reader' do
      expect(described_class)
        .to respond_to(:ordered_deferred_calls, true)
        .with(0).arguments
    end

    it 'should not define any deferred calls' do
      expect(described_class.send(:ordered_deferred_calls)).to be == expected
    end

    context 'when there are deferred hooks' do
      include_context 'when there are deferred hooks'

      let(:expected) { expected_hooks }

      it 'should define the deferred hooks' do
        expect(described_class.send(:ordered_deferred_calls)).to be == expected
      end
    end

    context 'when there are inherited hooks' do
      include_context 'when there are inherited hooks'

      let(:expected) { inherited_hooks }

      it 'should define the deferred hooks' do
        expect(described_class.send(:ordered_deferred_calls)).to be == expected
      end
    end

    context 'when there are deferred and inherited hooks' do
      include_context 'when there are deferred hooks'
      include_context 'when there are inherited hooks'

      let(:expected) { inherited_hooks + expected_hooks }

      it 'should define the deferred hooks' do
        expect(described_class.send(:ordered_deferred_calls)).to be == expected
      end
    end
  end

  describe '.prepend_before' do
    include_examples 'should define a hook macro', :prepend_before
  end
end
