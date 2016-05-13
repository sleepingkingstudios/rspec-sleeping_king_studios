# spec/rspec/sleeping_king_studios/concerns/shared_example_group_spec.rb

require 'spec_helper'

require 'rspec/sleeping_king_studios/concerns/shared_example_group'
require 'rspec/sleeping_king_studios/matchers/built_in/respond_to'

RSpec.describe RSpec::SleepingKingStudios::Concerns::SharedExampleGroup do
  shared_examples 'with a defined example group' do
    before(:each) do
      instance.shared_examples('defined examples') {}
    end # before each
  end # shared examples

  let(:instance)       { Module.new.extend described_class }
  let(:registry)       { RSpec.world.shared_example_group_registry }
  let(:example_groups) { registry.send :shared_example_groups }

  def expect_to_define_example_group object, name
    expect(example_groups[object]).to be_a Hash
    expect(example_groups[object][name]).to be_a Proc
  end # method expect_to_define_example_group

  describe '#alias_shared_context' do
    let(:context_name) { 'shared context' }

    it { expect(instance).to respond_to(:alias_shared_context).with(2).arguments }

    context 'with a defined example group' do
      include_examples 'with a defined example group'

      it 'defines a shared example group' do
        instance.alias_shared_context(context_name, 'defined examples')

        expect_to_define_example_group(instance, context_name)
        expect_to_define_example_group(instance, 'defined examples')
      end # it
    end # context

    context 'with an undefined example group' do
      it 'raises an error' do
        expect {
          instance.alias_shared_context(context_name, 'defined examples')
        }.to raise_error ArgumentError, %{Could not find shared examples "defined examples"}
      end # it
    end # context
  end # describe

  describe '#alias_shared_examples' do
    let(:examples_name) { 'shared examples' }

    it { expect(instance).to respond_to(:alias_shared_examples).with(2).arguments }

    context 'with a defined example group' do
      include_examples 'with a defined example group'

      it 'defines a shared example group' do
        instance.alias_shared_examples(examples_name, 'defined examples')

        expect_to_define_example_group(instance, examples_name)
        expect_to_define_example_group(instance, 'defined examples')
      end # it
    end # context

    context 'with an undefined example group' do
      it 'raises an error' do
        expect {
          instance.alias_shared_examples(examples_name, 'defined examples')
        }.to raise_error ArgumentError, %{Could not find shared examples "defined examples"}
      end # it
    end # context
  end # describe

  describe '#included' do
    include_examples 'with a defined example group'

    let!(:object) do
      Module.new.send :include, instance
    end # let

    it 'defines the shared example groups on the module' do
      expect(example_groups[object]).to be_a Hash
      expect(example_groups[object]['defined examples']).to be_a Proc
    end # it

    describe 'with the example group already defined' do
      let(:wrapper) do
        mod = Module.new.extend described_class
        mod.send :include, instance
        mod
      end # let

      it 'defines the shared example groups on the module' do
        object.send :include, wrapper

        expect(example_groups[object]).to be_a Hash
        expect(example_groups[object]['defined examples']).to be_a Proc
      end # it

      it 'does not trigger a warning message' do
        expect(RSpec).not_to receive(:warn_with)

        object.send :include, wrapper
      end # it
    end # describe

    describe 'with a conflicting example group' do
      let(:wrapper) do
        mod = Module.new.extend described_class
        mod.shared_examples('defined examples') {}
        mod
      end # let
      let(:message) { "WARNING: Shared example group 'defined examples' has been previously defined" }

      it 'triggers a warning message' do
        expect(RSpec).to receive(:warn_with) do |message, *rest|
          expect(message).to be_a(String)
          expect(message).to start_with(message)
        end # expect to receive

        object.send :include, wrapper
      end # it
    end # describe
  end # describe

  describe '#shared_context' do
    let(:examples_name) { 'shared context' }

    it { expect(instance).to respond_to(:shared_context).with(1..9001).arguments.and_a_block }

    it 'defines a shared example group' do
      expect(registry).to receive(:add).with(instance, examples_name, :key => :value).and_call_original

      instance.shared_context(examples_name, :key => :value) {}

      expect_to_define_example_group(instance, examples_name)
    end # it

    context 'with a shared example group defined' do
      include_examples 'with a defined example group'

      it 'defines a shared example group' do
        expect(registry).to receive(:add).with(instance, examples_name, :key => :value).and_call_original

        instance.shared_context(examples_name, :key => :value) {}

        expect_to_define_example_group(instance, examples_name)
        expect_to_define_example_group(instance, 'defined examples')
      end # it
    end # context
  end # describe

  describe '#shared_examples' do
    let(:examples_name) { 'shared examples' }

    it { expect(instance).to respond_to(:shared_examples).with(1..9001).arguments.and_a_block }

    it 'defines a shared example group' do
      expect(registry).to receive(:add).with(instance, examples_name, :key => :value).and_call_original

      instance.shared_examples(examples_name, :key => :value) {}

      expect_to_define_example_group(instance, examples_name)
    end # it

    context 'with a shared example group defined' do
      include_examples 'with a defined example group'

      it 'defines a shared example group' do
        expect(registry).to receive(:add).with(instance, examples_name, :key => :value).and_call_original

        instance.shared_examples(examples_name, :key => :value) {}

        expect_to_define_example_group(instance, examples_name)
        expect_to_define_example_group(instance, 'defined examples')
      end # it
    end # context
  end # describe
end # describe
