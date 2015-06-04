# spec/rspec/sleeping_king_studios/concerns/wrap_examples_spec.rb

require 'rspec/sleeping_king_studios/spec_helper'

require 'rspec/sleeping_king_studios/concerns/wrap_examples'
require 'rspec/sleeping_king_studios/matchers/built_in/respond_to'

RSpec.describe RSpec::SleepingKingStudios::Concerns::WrapExamples do
  let(:instance) do
    Module.new do
      class << self
        attr_accessor :examples_included, :is_describe_block, :is_focus

        def describe name, &block
          self.is_describe_block = true
          self.is_focus          = false

          instance_eval(&block)

          self.is_describe_block = false
        end # method describe

        def fdescribe name, &block
          self.is_describe_block = true
          self.is_focus          = true

          instance_eval(&block)

          self.is_describe_block = false
          self.is_focus          = false
        end # method fdescribe

        def include_examples name, *args, **kwargs; end
      end # eigenclass
    end.extend described_class
  end # let

  describe '#fwrap_examples' do
    let(:examples_name)  { 'focused examples' }
    let(:example_args)   { %w(foo bar baz) }
    let(:example_kwargs) { { :wibble => :wobble } }

    def perform_action &block
      instance.fwrap_examples examples_name, *example_args, **example_kwargs, &block
    end # method perform_action

    it { expect(instance).to respond_to(:fwrap_context).with_unlimited_arguments.and_arbitrary_keywords.and_a_block }

    it { expect(instance).to respond_to(:fwrap_examples).with_unlimited_arguments.and_arbitrary_keywords.and_a_block }

    context 'without a defined shared example group' do
      let(:exception_class)   { ArgumentError }
      let(:exception_message) { %{Could not find shared examples "#{examples_name}"} }

      before(:each) do
        allow(instance).to receive(:include_examples) do |name, *args, **kwargs|
          raise exception_class.new(exception_message)
        end # allow
      end # end

      it 'should raise an error' do
        expect { perform_action }.to raise_error exception_class, exception_message
      end # it
    end # context

    context 'with a defined shared example group' do
      it 'should include the shared example group' do
        expect(instance).to receive(:include_examples).with(examples_name, *example_args, **example_kwargs)

        perform_action
      end # it

      describe 'with a block' do
        it 'should include the shared example group and evaluate the block' do
          expect(instance).to receive(:include_examples).with(examples_name, *example_args, **example_kwargs) do
            instance.examples_included = true
          end # expect

          block_called      = nil
          examples_included = false
          is_describe_block = false
          is_focus          = false

          perform_action do
            block_called = true

            examples_included = self.examples_included

            is_describe_block = self.is_describe_block

            is_focus          = self.is_focus
          end # action

          expect(block_called).to be true
          expect(examples_included).to be true
          expect(is_describe_block).to be true
          expect(is_focus).to be true
        end # it
      end # describe
    end # context
  end # describe

  describe '#wrap_examples' do
    let(:examples_name)  { 'defined examples' }
    let(:example_args)   { %w(foo bar baz) }
    let(:example_kwargs) { { :wibble => :wobble } }

    def perform_action &block
      instance.wrap_examples examples_name, *example_args, **example_kwargs, &block
    end # method perform_action

    it { expect(instance).to respond_to(:wrap_context).with_unlimited_arguments.and_arbitrary_keywords.and_a_block }

    it { expect(instance).to respond_to(:wrap_examples).with_unlimited_arguments.and_arbitrary_keywords.and_a_block }

    context 'without a defined shared example group' do
      let(:exception_class)   { ArgumentError }
      let(:exception_message) { %{Could not find shared examples "#{examples_name}"} }

      before(:each) do
        allow(instance).to receive(:include_examples) do |name, *args, **kwargs|
          raise exception_class.new(exception_message)
        end # allow
      end # end

      it 'should raise an error' do
        expect { perform_action }.to raise_error exception_class, exception_message
      end # it
    end # context

    context 'with a defined shared example group' do
      it 'should include the shared example group' do
        expect(instance).to receive(:include_examples).with(examples_name, *example_args, **example_kwargs)

        perform_action
      end # it

      describe 'with a block' do
        it 'should include the shared example group and evaluate the block' do
          expect(instance).to receive(:include_examples).with(examples_name, *example_args, **example_kwargs) do
            instance.examples_included = true
          end # expect

          block_called      = nil
          examples_included = false
          is_describe_block = false
          is_focus          = false

          perform_action do
            block_called = true

            examples_included = self.examples_included

            is_describe_block = self.is_describe_block

            is_focus          = self.is_focus
          end # action

          expect(block_called).to be true
          expect(examples_included).to be true
          expect(is_describe_block).to be true
          expect(is_focus).to be false
        end # it
      end # describe
    end # context
  end # describe
end # describe
