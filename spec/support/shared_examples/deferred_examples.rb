# frozen_string_literal: true

require 'rspec/sleeping_king_studios/concerns/shared_example_group'
require 'rspec/sleeping_king_studios/matchers/built_in/respond_to'

require 'support/isolated_example_group'
require 'support/shared_examples'

module Spec::Support::SharedExamples
  module DeferredExamples
    extend RSpec::SleepingKingStudios::Concerns::SharedExampleGroup

    shared_examples 'should define deferred calls' do
      describe '.call' do
        let(:example_group) { instance_double(RSpec::Core::ExampleGroup) }

        it { expect(subject).to respond_to(:call).with(1).argument }

        context 'when there are many deferred calls' do
          let(:deferred_calls) do
            Array.new(3) do |index|
              instance_double(
                RSpec::SleepingKingStudios::Deferred::Call,
                call:    nil,
                inspect: "deferred-#{index}"
              )
            end
          end
          let(:applied_calls) { [] }

          before(:example) do
            allow(subject)
              .to receive(:deferred_calls)
              .and_return(deferred_calls)

            deferred_calls.each do |deferred|
              allow(deferred).to receive(:call) do
                applied_calls << deferred.inspect
              end
            end
          end

          it 'should call the deferred calls on the receiver',
            :aggregate_failures \
          do
            subject.call(example_group)

            expect(deferred_calls)
              .to all have_received(:call)
              .with(example_group)
            expect(applied_calls).to be == deferred_calls.map(&:inspect)
          end
        end
      end

      describe '.deferred_calls' do
        it { expect(subject).to respond_to(:deferred_calls).with(0).arguments }

        it { expect(subject.deferred_calls).to be == [] }
      end

      describe '.included' do
        before(:example) do
          allow(subject).to receive(:call)

          allow(ancestor_examples).to receive(:call)
        end

        describe 'with a Module' do
          let(:other) { Module.new }

          it 'should not call the deferred examples' do
            other.include(subject)

            expect(subject).not_to have_received(:call)
          end

          it 'should not call the inherited examples' do
            other.include(subject)

            expect(ancestor_examples).not_to have_received(:call)
          end
        end

        describe 'with deferred examples' do
          let(:other) do
            Module.new do
              include RSpec::SleepingKingStudios::Deferred::Definitions
            end
          end

          it 'should not call the deferred examples' do
            other.include(subject)

            expect(subject).not_to have_received(:call)
          end

          it 'should not call the inherited examples' do
            other.include(subject)

            expect(ancestor_examples).not_to have_received(:call)
          end
        end

        describe 'with an example group' do
          let(:example_group) do
            Spec::Support.isolated_example_group
          end
          let(:applied_calls) { [] }

          before(:example) do
            allow(subject).to receive(:call) do
              applied_calls << 'examples'
            end

            allow(ancestor_examples).to receive(:call) do
              applied_calls << 'ancestor'
            end
          end

          it 'should call the deferred and inherited examples',
            :aggregate_failures \
          do
            example_group.include(subject)

            expect(subject).to have_received(:call).with(example_group)
            expect(ancestor_examples)
              .to have_received(:call)
              .with(example_group)
            expect(applied_calls).to be == %w[ancestor examples]
          end
        end
      end
    end

    shared_examples 'should define deferred examples' do
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
            .to change(described_class, :deferred_calls)
        end

        it 'should define a deferred example', :aggregate_failures do
          described_class.send(method_name, *arguments, **keywords, &block)

          deferred = described_class.deferred_calls.last

          expect(deferred)
            .to be_a(RSpec::SleepingKingStudios::Deferred::Calls::Example)
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

    shared_examples 'should define deferred example groups' do
      shared_examples 'should define an example group macro' do |method_name|
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

        it 'should add a deferred example group to the class' do
          expect do
            described_class.send(method_name, *arguments, **keywords, &block)
          end
            .to change(described_class, :deferred_calls)
        end

        it 'should define a deferred example group', :aggregate_failures do
          described_class.send(method_name, *arguments, **keywords, &block)

          deferred =
            described_class.deferred_calls.last

          expect(deferred)
            .to be_a(RSpec::SleepingKingStudios::Deferred::Calls::ExampleGroup)
          expect(deferred.method_name).to be method_name
          expect(deferred.arguments).to be == arguments
          expect(deferred.keywords).to be == keywords
          expect(deferred.block).to be == block
        end

        context 'when the deferred examples are called' do
          let(:example_group) { instance_double(RSpec::Core::ExampleGroup) }

          it 'should call the deferred example group' do
            described_class.send(method_name, *arguments, **keywords, &block)

            deferred = described_class.deferred_calls.last

            allow(deferred).to receive(:call)

            described_class.call(example_group)

            expect(deferred).to have_received(:call).with(example_group)
          end
        end
      end

      describe '.context' do
        include_examples 'should define an example group macro', :context
      end

      describe '.describe' do
        include_examples 'should define an example group macro', :describe
      end

      describe '.example_group' do
        include_examples 'should define an example group macro', :example_group
      end

      describe '.fcontext' do
        include_examples 'should define an example group macro', :fcontext
      end

      describe '.fdescribe' do
        include_examples 'should define an example group macro', :fdescribe
      end

      describe '.xcontext' do
        include_examples 'should define an example group macro', :xcontext
      end

      describe '.xdescribe' do
        include_examples 'should define an example group macro', :xdescribe
      end
    end

    shared_examples 'should define deferred hooks' do
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
            described_class
              .send(method_name, scope, *arguments, **keywords, &block)
          end
            .to change(described_class, :deferred_hooks)
        end

        it 'should define a deferred hook', :aggregate_failures do
          described_class
            .send(method_name, scope, *arguments, **keywords, &block)

          deferred = described_class.deferred_hooks.last

          expect(deferred)
            .to be_a(RSpec::SleepingKingStudios::Deferred::Calls::Hook)
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

            deferred = described_class.deferred_hooks.last

            allow(deferred).to receive(:call)

            described_class.call(example_group)

            expect(deferred).to have_received(:call).with(example_group)
          end
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
        let(:example_group) { instance_double(RSpec::Core::ExampleGroup) }

        it { expect(subject).to respond_to(:call).with(1).argument }

        context 'when there are many deferred hooks' do
          let(:deferred_hooks) do
            Array.new(3) do |index|
              instance_double(
                RSpec::SleepingKingStudios::Deferred::Calls::Hook,
                call:    nil,
                inspect: "deferred-#{index}"
              )
            end
          end
          let(:applied_calls)  { [] }
          let(:expected_calls) { deferred_hooks.reverse_each.map(&:inspect) }

          before(:example) do
            allow(subject)
              .to receive(:deferred_hooks)
              .and_return(deferred_hooks)

            deferred_hooks.each do |deferred|
              allow(deferred).to receive(:call) do
                applied_calls << deferred.inspect
              end
            end
          end

          it 'should call the deferred calls on the receiver',
            :aggregate_failures \
          do
            subject.call(example_group)

            expect(deferred_hooks)
              .to all have_received(:call)
              .with(example_group)
            expect(applied_calls).to be == expected_calls
          end
        end
      end

      describe '.deferred_hooks' do
        it { expect(subject).to respond_to(:deferred_hooks).with(0).arguments }

        it { expect(subject.deferred_hooks).to be == [] }
      end

      describe '.prepend_before' do
        include_examples 'should define a hook macro', :prepend_before
      end
    end

    shared_examples 'should define memoized helpers' do
      shared_examples 'should define a memoized helper macro' \
      do |method_name, before: false, subject: false|
        shared_context 'when the helper is defined' do
          before(:example) do
            described_class.send(method_name, helper_name, &block)
          end
        end

        shared_examples 'should call and memoize the block value' do
          context 'when the helper is defined' do
            include_context 'when the helper is defined'

            it 'should return the value returned by the block' do
              expect(call_helper).to be 0
            end

            it 'should memoize the value', :aggregate_failures do
              3.times { expect(call_helper).to be 0 }
            end
          end
        end

        shared_examples 'should call the existing implementation' do
          context 'when the helper is defined' do
            include_context 'when the helper is defined'

            it 'should call the existing implementation' do
              expect(call_helper).to be existing_block.call
            end
          end
        end

        shared_examples 'should wrap the existing implementation' do
          context 'when the helper calls super()' do
            include_context 'when the helper is defined'

            let(:block) { -> { super() - 1 } }

            it 'should return the value returned by the block' do
              expect(call_helper).to be(-2)
            end

            it 'should memoize the value', :aggregate_failures do
              3.times { expect(call_helper).to be(-2) }
            end
          end
        end

        let(:existing_block) { -> { -1 } }
        let(:helper_name)    { :payload }
        let(:block) do
          counter = -1

          -> { counter += 1 }
        end
        let(:parent_group) { Spec::Support.isolated_example_group }
        let(:example_group) do
          deferred_examples = described_class

          Spec::Support.isolated_example_group(parent_group) do
            include deferred_examples
          end
        end
        let(:example_instance) { example_group.new }

        def call_helper
          example_instance.send(helper_name)
        end

        it 'should define the class method' do
          expect(described_class)
            .to respond_to(method_name)
            .with(1).argument
            .and_a_block
        end

        it 'should define the helper method' do
          described_class.send(method_name, helper_name, &block)

          expect(example_group.new).to respond_to(helper_name).with(0).arguments
        end

        include_examples 'should call and memoize the block value'

        context 'when a helper is declared in a parent example group' do
          before(:example) do
            parent_group.let(helper_name, &existing_block)
          end

          include_examples 'should call and memoize the block value'

          include_examples 'should wrap the existing implementation'
        end

        context 'when a method is declared in a parent example group' do
          before(:example) do
            parent_group.define_method(helper_name, &existing_block)
          end

          include_examples 'should call and memoize the block value'

          include_examples 'should wrap the existing implementation'
        end

        context 'when a helper is defined in the example scope' do
          before(:example) do
            example_group.let(helper_name) { -1 }
          end

          include_examples 'should call the existing implementation'
        end

        context 'when a method is defined in the example scope' do
          before(:example) do
            example_group.define_method(helper_name, &existing_block)
          end

          include_examples 'should call the existing implementation'
        end

        context 'when a helper is defined in the same scope' do
          before(:example) do
            described_class.let(helper_name) { -1 }
          end

          include_examples 'should call and memoize the block value'
        end

        context 'when a method is defined in the same scope' do
          before(:example) do
            described_class.define_method(helper_name) { -1 }
          end

          include_examples 'should call and memoize the block value'
        end

        context 'when a helper is defined in inherited examples' do
          before(:example) do
            ancestor_class.let(helper_name) { -1 }
          end

          include_examples 'should call and memoize the block value'
        end

        context 'when a method is defined in inherited examples' do
          before(:example) do
            ancestor_class.define_method(helper_name) { -1 }
          end

          include_examples 'should call and memoize the block value'
        end

        if before
          it 'should add a deferred hook to the class' do
            expect { described_class.send(method_name, helper_name, &block) }
              .to change(described_class, :deferred_hooks)
          end

          it 'should define a deferred hook', :aggregate_failures do
            described_class.send(method_name, helper_name, &block)

            deferred = described_class.deferred_hooks.last

            expect(deferred)
              .to be_a(RSpec::SleepingKingStudios::Deferred::Calls::Hook)
            expect(deferred.method_name).to be :before
            expect(deferred.scope).to be :example
            expect(deferred.arguments).to be == %i[example]
            expect(deferred.keywords).to be == {}
            expect(deferred.block).to be_a Proc
          end

          it 'should reference the helper method in the hook' do
            described_class.send(method_name, helper_name, &block)

            deferred = described_class.deferred_hooks.last
            value    = example_instance.instance_exec(&deferred.block)

            expect(value).to be 0
          end
        end
      end

      describe '::HelperImplementations' do
        it 'should define the constant' do
          expect(described_class)
            .to define_constant(:HelperImplementations)
            .with_value(an_instance_of Module)
        end

        it 'should not include the helper implementations' do
          expect(described_class)
            .not_to be < described_class::HelperImplementations
        end
      end

      describe '#call' do
        let(:example_group) { Spec::Support.isolated_example_group }

        it 'should include the helper implementations' do
          example_group.include(described_class)

          expect(described_class).to be < described_class::HelperImplementations
        end
      end

      describe '.let' do
        include_examples 'should define a memoized helper macro', :let
      end

      describe '.let!' do
        include_examples 'should define a memoized helper macro',
          :let!,
          before: true
      end
    end
  end
end
