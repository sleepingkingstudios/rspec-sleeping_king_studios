# frozen_string_literal: true

require 'spec_helper'

require 'rspec/sleeping_king_studios/concerns/example_constants'
require 'rspec/sleeping_king_studios/concerns/wrap_examples'
require 'rspec/sleeping_king_studios/contract'
require 'rspec/sleeping_king_studios/contracts/development'
require 'rspec/sleeping_king_studios/matchers/built_in/respond_to'

require 'support/shared_examples/contract_examples'

RSpec.describe RSpec::SleepingKingStudios::Contracts::Development do
  extend  RSpec::SleepingKingStudios::Concerns::ExampleConstants
  extend  RSpec::SleepingKingStudios::Concerns::WrapExamples
  include Spec::Support::SharedExamples::ContractExamples

  shared_context 'when the contract is pending' do
    before(:example) { described_class.pending }
  end

  let(:described_class) { Spec::DevelopmentContract }

  example_constant 'Spec::DevelopmentContract' do
    Module.new do
      extend RSpec::SleepingKingStudios::Contract
      extend RSpec::SleepingKingStudios::Contracts::Development
    end
  end

  describe '.fcontext' do
    let(:method_name) { :fcontext }

    it 'should define the class method' do
      expect(described_class)
        .to respond_to(:fcontext).with(1).argument
        .and_a_block
    end

    include_examples 'should validate the description and block'

    include_examples 'should define an example'
  end

  describe '.fdescribe' do
    let(:method_name) { :fdescribe }

    it 'should define the class method' do
      expect(described_class)
        .to respond_to(:fdescribe).with(1).argument
        .and_a_block
    end

    include_examples 'should validate the description and block'

    include_examples 'should define an example'
  end

  describe '.fit' do
    let(:method_name) { :fit }

    it 'should define the class method' do
      expect(described_class)
        .to respond_to(:fit).with(0..1).arguments
        .and_a_block
    end

    include_examples 'should validate the description and block',
      allow_nil: true

    include_examples 'should define an example'
  end

  describe '.included' do
    let(:example_group) do
      class_double(
        RSpec::Core::ExampleGroup,
        :<    => nil,
        pending: nil
      ).tap do |double|
        allow(double)
          .to receive(:<)
          .with(RSpec::Core::ExampleGroup)
          .and_return(true)
      end
    end

    wrap_context 'when the contract is pending' do
      it 'should mark the example group as pending' do
        described_class.send :included, example_group

        expect(example_group).to have_received(:pending).with(no_args)
      end
    end
  end

  describe '.pending' do
    it 'should define the class method' do
      expect(described_class).to respond_to(:pending).with(0).arguments
    end

    it 'should mark the contract as pending' do
      expect { described_class.pending }
        .to change(described_class, :pending?)
        .to be true
    end

    wrap_context 'when the contract is pending' do
      it 'should not change the contract' do
        expect { described_class.pending }
          .not_to change(described_class, :pending?)
      end
    end
  end

  describe '.pending?' do
    it 'should define the class predicate' do
      expect(described_class).to respond_to(:pending?).with(0).arguments
    end

    it { expect(described_class.pending?).to be false }

    wrap_context 'when the contract is pending' do
      it { expect(described_class.pending?).to be true }
    end
  end

  describe '.xcontext' do
    let(:method_name) { :xcontext }

    it 'should define the class method' do
      expect(described_class)
        .to respond_to(:xcontext).with(1).argument
        .and_a_block
    end

    include_examples 'should validate the description and block'

    include_examples 'should define an example'
  end

  describe '.xdescribe' do
    let(:method_name) { :xdescribe }

    it 'should define the class method' do
      expect(described_class)
        .to respond_to(:xdescribe).with(1).argument
        .and_a_block
    end

    include_examples 'should validate the description and block'

    include_examples 'should define an example'
  end

  describe '.xit' do
    let(:method_name) { :xit }

    it 'should define the class method' do
      expect(described_class)
        .to respond_to(:xit).with(0..1).arguments
        .and_a_block
    end

    include_examples 'should validate the description and block',
      allow_nil: true

    include_examples 'should define an example'
  end
end
