# spec/rspec/sleeping_king_studios/concerns/wrap_examples_spec.rb

require 'spec_helper'

require 'rspec/sleeping_king_studios/concerns/wrap_examples'
require 'rspec/sleeping_king_studios/matchers/built_in/respond_to'

require 'support/mock_describe_examples'

RSpec.describe RSpec::SleepingKingStudios::Concerns::WrapExamples do
  let(:described_class) do
    Class.new do
      extend Spec::Support::MockDescribeExamples
      extend RSpec::SleepingKingStudios::Concerns::WrapExamples
    end # class
  end # let

  describe '#fwrap_examples' do
    let(:examples_name) { 'focused examples' }

    it { expect(described_class).to respond_to(:fwrap_context).with(1).argument.and_unlimited_arguments.and_arbitrary_keywords.and_a_block }

    it { expect(described_class).to respond_to(:fwrap_examples).with(1).argument.and_unlimited_arguments.and_arbitrary_keywords.and_a_block }

    context 'without a defined shared example group' do
      let(:exception_class)   { ArgumentError }
      let(:exception_message) { %{Could not find shared examples "#{examples_name}"} }

      before(:example) do
        allow(described_class).to receive(:include_examples) do |name, *args, **kwargs|
          raise exception_class.new(exception_message)
        end # allow
      end # before example

      it 'should raise an error' do
        expect { described_class.fwrap_examples examples_name }.to raise_error exception_class, exception_message
      end # it
    end # context

    context 'with a defined shared example group' do
      let(:example_kwargs) { { :wibble => :wobble } }
      let(:example_args)   { %w(foo bar baz) }

      describe 'with no arguments' do
        def perform_action &block
          described_class.fwrap_examples examples_name
        end # method perform_action

        it 'should include the shared example group' do
          expect(described_class).to receive(:include_examples).with(examples_name)

          perform_action
        end # it
      end # describe

      describe 'with many arguments' do
        def perform_action &block
          described_class.fwrap_examples examples_name, *example_args
        end # method perform_action

        it 'should include the shared example group' do
          expect(described_class).to receive(:include_examples).with(examples_name, *example_args)

          perform_action
        end # it
      end # it

      describe 'with many keywords' do
        def perform_action &block
          described_class.fwrap_examples examples_name, **example_kwargs
        end # method perform_action

        it 'should include the shared example group' do
          allow(described_class).to receive(:include_examples)

          perform_action

          expect(described_class)
            .to have_received(:include_examples)
            .with(examples_name, **example_kwargs)
        end # it
      end # it

      describe 'with many arguments and many keywords' do
        def perform_action &block
          described_class.fwrap_examples examples_name, *example_args, **example_kwargs
        end # method perform_action

        it 'should include the shared example group' do
          allow(described_class).to receive(:include_examples)

          perform_action

          expect(described_class)
            .to have_received(:include_examples)
            .with(examples_name, *example_args, **example_kwargs)
        end # it
      end # it

      describe 'with a block' do
        def perform_action &block
          described_class.fwrap_examples examples_name, *example_args, **example_kwargs, &block
        end # method perform_action

        it 'should include the shared example group and evaluate the block' do
          allow(described_class).to receive(:include_examples) do
            described_class.examples_included = true
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

          expect(described_class)
            .to have_received(:include_examples)
            .with(examples_name, *example_args, **example_kwargs)
        end # it
      end # describe
    end # context
  end # describe

  describe '#xwrap_examples' do
    let(:examples_name) { 'skipped examples' }

    it { expect(described_class).to respond_to(:xwrap_context).with(1).argument.and_unlimited_arguments.and_arbitrary_keywords.and_a_block }

    it { expect(described_class).to respond_to(:xwrap_examples).with(1).argument.and_unlimited_arguments.and_arbitrary_keywords.and_a_block }

    context 'without a defined shared example group' do
      let(:exception_class)   { ArgumentError }
      let(:exception_message) { %{Could not find shared examples "#{examples_name}"} }

      before(:example) do
        allow(described_class).to receive(:include_examples) do |name, *args, **kwargs|
          raise exception_class.new(exception_message)
        end # allow
      end # before example

      it 'should raise an error' do
        expect { described_class.xwrap_examples examples_name }.to raise_error exception_class, exception_message
      end # it
    end # context

    context 'with a defined shared example group' do
      let(:example_args)   { %w(foo bar baz) }
      let(:example_kwargs) { { :wibble => :wobble } }

      describe 'with no arguments' do
        def perform_action &block
          described_class.xwrap_examples examples_name
        end # method perform_action

        it 'should include the shared example group' do
          expect(described_class).to receive(:include_examples).with(examples_name)

          perform_action
        end # it
      end # describe

      describe 'with many arguments' do
        def perform_action &block
          described_class.xwrap_examples examples_name, *example_args
        end # method perform_action

        it 'should include the shared example group' do
          expect(described_class).to receive(:include_examples).with(examples_name, *example_args)

          perform_action
        end # it
      end # it

      describe 'with many keywords' do
        def perform_action &block
          described_class.xwrap_examples examples_name, **example_kwargs
        end # method perform_action

        it 'should include the shared example group' do
          allow(described_class).to receive(:include_examples)

          perform_action

          expect(described_class)
            .to have_received(:include_examples)
            .with(examples_name, **example_kwargs)
        end # it
      end # it

      describe 'with many arguments and many keywords' do
        def perform_action &block
          described_class.xwrap_examples examples_name, *example_args, **example_kwargs
        end # method perform_action

        it 'should include the shared example group' do
          allow(described_class).to receive(:include_examples)

          perform_action

          expect(described_class)
            .to have_received(:include_examples)
            .with(examples_name, *example_args, **example_kwargs)
        end # it
      end # it

      describe 'with a block' do
        def perform_action &block
          described_class.xwrap_examples examples_name, *example_args, **example_kwargs, &block
        end # method perform_action

        it 'should include the shared example group and evaluate the block' do
          allow(described_class).to receive(:include_examples) do
            described_class.examples_included = true
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

          expect(described_class)
            .to have_received(:include_examples)
            .with(examples_name, *example_args, **example_kwargs)
        end # it
      end # describe
    end # context
  end # describe

  describe '#wrap_examples' do
    let(:examples_name)  { 'defined examples' }

    it { expect(described_class).to respond_to(:wrap_context).with(1).argument.and_unlimited_arguments.and_arbitrary_keywords.and_a_block }

    it { expect(described_class).to respond_to(:wrap_examples).with(1).argument.and_unlimited_arguments.and_arbitrary_keywords.and_a_block }

    context 'without a defined shared example group' do
      let(:exception_class)   { ArgumentError }
      let(:exception_message) { %{Could not find shared examples "#{examples_name}"} }

      before(:example) do
        allow(described_class).to receive(:include_examples) do |name, *args, **kwargs|
          raise exception_class.new(exception_message)
        end # allow
      end # before example

      it 'should raise an error' do
        expect { described_class.wrap_examples examples_name }.to raise_error exception_class, exception_message
      end # it
    end # context

    context 'with a defined shared example group' do
      let(:example_args)   { %w(foo bar baz) }
      let(:example_kwargs) { { :wibble => :wobble } }

      describe 'with no arguments' do
        def perform_action &block
          described_class.wrap_examples examples_name
        end # method perform_action

        it 'should include the shared example group' do
          expect(described_class).to receive(:include_examples).with(examples_name)

          perform_action
        end # it
      end # describe

      describe 'with many arguments' do
        def perform_action &block
          described_class.wrap_examples examples_name, *example_args
        end # method perform_action

        it 'should include the shared example group' do
          expect(described_class).to receive(:include_examples).with(examples_name, *example_args)

          perform_action
        end # it
      end # it

      describe 'with many keywords' do
        def perform_action &block
          described_class.wrap_examples examples_name, **example_kwargs
        end # method perform_action

        it 'should include the shared example group' do
          allow(described_class).to receive(:include_examples)

          perform_action

          expect(described_class)
            .to have_received(:include_examples)
            .with(examples_name, **example_kwargs)
        end # it
      end # it

      describe 'with many arguments and many keywords' do
        def perform_action &block
          described_class.wrap_examples examples_name, *example_args, **example_kwargs
        end # method perform_action

        it 'should include the shared example group' do
          allow(described_class).to receive(:include_examples)

          perform_action

          expect(described_class)
            .to have_received(:include_examples)
            .with(examples_name, *example_args, **example_kwargs)
        end # it
      end # it

      describe 'with a block' do
        def perform_action &block
          described_class.wrap_examples examples_name, *example_args, **example_kwargs, &block
        end # method perform_action

        it 'should include the shared example group and evaluate the block' do
          allow(described_class).to receive(:include_examples) do
            described_class.examples_included = true
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

          expect(described_class)
            .to have_received(:include_examples)
            .with(examples_name, *example_args, **example_kwargs)
        end # it
      end # describe
    end # context
  end # describe
end # describe
