# spec/rspec/sleeping_king_studios/concerns/wrap_examples_spec.rb

require 'spec_helper'

require 'rspec/sleeping_king_studios/concerns/wrap_examples'
require 'rspec/sleeping_king_studios/matchers/built_in/respond_to'

RSpec.describe RSpec::SleepingKingStudios::Concerns::WrapExamples do
  let(:instance) do
    Module.new.extend(Spec::Support::MockExampleGroup).extend(described_class)
  end # let

  describe '#fwrap_examples' do
    let(:examples_name) { 'focused examples' }

    it { expect(instance).to respond_to(:fwrap_context).with(1).argument.and_unlimited_arguments.and_arbitrary_keywords.and_a_block }

    it { expect(instance).to respond_to(:fwrap_examples).with(1).argument.and_unlimited_arguments.and_arbitrary_keywords.and_a_block }

    context 'without a defined shared example group' do
      let(:exception_class)   { ArgumentError }
      let(:exception_message) { %{Could not find shared examples "#{examples_name}"} }

      before(:example) do
        allow(instance).to receive(:include_examples) do |name, *args, **kwargs|
          raise exception_class.new(exception_message)
        end # allow
      end # before example

      it 'should raise an error' do
        expect { instance.fwrap_examples examples_name }.to raise_error exception_class, exception_message
      end # it
    end # context

    context 'with a defined shared example group' do
      let(:example_kwargs) { { :wibble => :wobble } }
      let(:example_args)   { %w(foo bar baz) }

      describe 'with no arguments' do
        def perform_action &block
          instance.fwrap_examples examples_name
        end # method perform_action

        it 'should include the shared example group' do
          expect(instance).to receive(:include_examples).with(examples_name)

          perform_action
        end # it
      end # describe

      describe 'with many arguments' do
        def perform_action &block
          instance.fwrap_examples examples_name, *example_args
        end # method perform_action

        it 'should include the shared example group' do
          expect(instance).to receive(:include_examples).with(examples_name, *example_args)

          perform_action
        end # it
      end # it

      describe 'with many keywords' do
        def perform_action &block
          instance.fwrap_examples examples_name, **example_kwargs
        end # method perform_action

        it 'should include the shared example group' do
          expect(instance).to receive(:include_examples).with(examples_name, **example_kwargs)

          perform_action
        end # it
      end # it

      describe 'with many arguments and many keywords' do
        def perform_action &block
          instance.fwrap_examples examples_name, *example_args, **example_kwargs
        end # method perform_action

        it 'should include the shared example group' do
          expect(instance).to receive(:include_examples).with(examples_name, *example_args, **example_kwargs)

          perform_action
        end # it
      end # it

      describe 'with a block' do
        def perform_action &block
          instance.fwrap_examples examples_name, *example_args, **example_kwargs, &block
        end # method perform_action

        it 'should include the shared example group and evaluate the block' do
          expect(instance).to receive(:include_examples).with(examples_name, *example_args, **example_kwargs) do
            instance.examples_included = true
          end # expect

          block_called      = nil
          examples_included = false
          is_describe_block = false
          is_focus          = false
          is_skipped        = false

          perform_action do
            block_called = true

            examples_included = self.examples_included
            is_describe_block = self.is_describe_block
            is_focus          = self.is_focus
            is_skipped        = self.is_skipped
          end # action

          expect(block_called).to be true
          expect(examples_included).to be true
          expect(is_describe_block).to be true
          expect(is_focus).to be true
          expect(is_skipped).to be false
        end # it
      end # describe
    end # context
  end # describe

  describe '#xwrap_examples' do
    let(:examples_name) { 'skipped examples' }

    it { expect(instance).to respond_to(:xwrap_context).with(1).argument.and_unlimited_arguments.and_arbitrary_keywords.and_a_block }

    it { expect(instance).to respond_to(:xwrap_examples).with(1).argument.and_unlimited_arguments.and_arbitrary_keywords.and_a_block }

    context 'without a defined shared example group' do
      let(:exception_class)   { ArgumentError }
      let(:exception_message) { %{Could not find shared examples "#{examples_name}"} }

      before(:example) do
        allow(instance).to receive(:include_examples) do |name, *args, **kwargs|
          raise exception_class.new(exception_message)
        end # allow
      end # before example

      it 'should raise an error' do
        expect { instance.xwrap_examples examples_name }.to raise_error exception_class, exception_message
      end # it
    end # context

    context 'with a defined shared example group' do
      let(:example_args)   { %w(foo bar baz) }
      let(:example_kwargs) { { :wibble => :wobble } }

      describe 'with no arguments' do
        def perform_action &block
          instance.xwrap_examples examples_name
        end # method perform_action

        it 'should include the shared example group' do
          expect(instance).to receive(:include_examples).with(examples_name)

          perform_action
        end # it
      end # describe

      describe 'with many arguments' do
        def perform_action &block
          instance.xwrap_examples examples_name, *example_args
        end # method perform_action

        it 'should include the shared example group' do
          expect(instance).to receive(:include_examples).with(examples_name, *example_args)

          perform_action
        end # it
      end # it

      describe 'with many keywords' do
        def perform_action &block
          instance.xwrap_examples examples_name, **example_kwargs
        end # method perform_action

        it 'should include the shared example group' do
          expect(instance).to receive(:include_examples).with(examples_name, **example_kwargs)

          perform_action
        end # it
      end # it

      describe 'with many arguments and many keywords' do
        def perform_action &block
          instance.xwrap_examples examples_name, *example_args, **example_kwargs
        end # method perform_action

        it 'should include the shared example group' do
          expect(instance).to receive(:include_examples).with(examples_name, *example_args, **example_kwargs)

          perform_action
        end # it
      end # it

      describe 'with a block' do
        def perform_action &block
          instance.xwrap_examples examples_name, *example_args, **example_kwargs, &block
        end # method perform_action

        it 'should include the shared example group and evaluate the block' do
          expect(instance).to receive(:include_examples).with(examples_name, *example_args, **example_kwargs) do
            instance.examples_included = true
          end # expect

          block_called      = nil
          examples_included = false
          is_describe_block = false
          is_focus          = false
          is_skipped        = false

          perform_action do
            block_called = true

            examples_included = self.examples_included
            is_describe_block = self.is_describe_block
            is_focus          = self.is_focus
            is_skipped        = self.is_skipped
          end # action

          expect(block_called).to be true
          expect(examples_included).to be true
          expect(is_describe_block).to be true
          expect(is_focus).to be false
          expect(is_skipped).to be true
        end # it
      end # describe
    end # context
  end # describe

  describe '#wrap_examples' do
    let(:examples_name)  { 'defined examples' }

    it { expect(instance).to respond_to(:wrap_context).with(1).argument.and_unlimited_arguments.and_arbitrary_keywords.and_a_block }

    it { expect(instance).to respond_to(:wrap_examples).with(1).argument.and_unlimited_arguments.and_arbitrary_keywords.and_a_block }

    context 'without a defined shared example group' do
      let(:exception_class)   { ArgumentError }
      let(:exception_message) { %{Could not find shared examples "#{examples_name}"} }

      before(:example) do
        allow(instance).to receive(:include_examples) do |name, *args, **kwargs|
          raise exception_class.new(exception_message)
        end # allow
      end # before example

      it 'should raise an error' do
        expect { instance.wrap_examples examples_name }.to raise_error exception_class, exception_message
      end # it
    end # context

    context 'with a defined shared example group' do
      let(:example_args)   { %w(foo bar baz) }
      let(:example_kwargs) { { :wibble => :wobble } }

      describe 'with no arguments' do
        def perform_action &block
          instance.wrap_examples examples_name
        end # method perform_action

        it 'should include the shared example group' do
          expect(instance).to receive(:include_examples).with(examples_name)

          perform_action
        end # it
      end # describe

      describe 'with many arguments' do
        def perform_action &block
          instance.wrap_examples examples_name, *example_args
        end # method perform_action

        it 'should include the shared example group' do
          expect(instance).to receive(:include_examples).with(examples_name, *example_args)

          perform_action
        end # it
      end # it

      describe 'with many keywords' do
        def perform_action &block
          instance.wrap_examples examples_name, **example_kwargs
        end # method perform_action

        it 'should include the shared example group' do
          expect(instance).to receive(:include_examples).with(examples_name, **example_kwargs)

          perform_action
        end # it
      end # it

      describe 'with many arguments and many keywords' do
        def perform_action &block
          instance.wrap_examples examples_name, *example_args, **example_kwargs
        end # method perform_action

        it 'should include the shared example group' do
          expect(instance).to receive(:include_examples).with(examples_name, *example_args, **example_kwargs)

          perform_action
        end # it
      end # it

      describe 'with a block' do
        def perform_action &block
          instance.wrap_examples examples_name, *example_args, **example_kwargs, &block
        end # method perform_action

        it 'should include the shared example group and evaluate the block' do
          expect(instance).to receive(:include_examples).with(examples_name, *example_args, **example_kwargs) do
            instance.examples_included = true
          end # expect

          block_called      = nil
          examples_included = false
          is_describe_block = false
          is_focus          = false
          is_skipped        = false

          perform_action do
            block_called = true

            examples_included = self.examples_included
            is_describe_block = self.is_describe_block
            is_focus          = self.is_focus
            is_skipped        = self.is_skipped
          end # action

          expect(block_called).to be true
          expect(examples_included).to be true
          expect(is_describe_block).to be true
          expect(is_focus).to be false
          expect(is_skipped).to be false
        end # it
      end # describe
    end # context
  end # describe
end # describe
