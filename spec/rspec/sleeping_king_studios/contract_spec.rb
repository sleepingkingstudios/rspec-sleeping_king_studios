# frozen_string_literal: true

require 'spec_helper'

require 'rspec/sleeping_king_studios/concerns/example_constants'
require 'rspec/sleeping_king_studios/contract'
require 'rspec/sleeping_king_studios/matchers/built_in/respond_to'

require 'support/shared_examples/contract_examples'

RSpec.describe RSpec::SleepingKingStudios::Contract do
  extend  RSpec::SleepingKingStudios::Concerns::ExampleConstants
  include Spec::Support::SharedExamples::ContractExamples

  shared_context 'when the contract defines examples' do
    let(:examples) do
      [
        {
          block:       -> {},
          description: 'when a context applies',
          method_name: :context
        },
        {
          block:       -> {},
          description: '#some_method',
          method_name: :describe
        },
        {
          block:       -> {},
          description: 'should do something',
          method_name: :it
        }
      ]
    end

    before(:example) do
      examples.each do |example|
        described_class.send(
          example[:method_name],
          example[:description],
          &example[:block]
        )
      end
    end
  end

  shared_context 'when the contract includes another contract' do
    let(:other_contract) {}
    let(:other_examples) do
      [
        {
          block:       -> {},
          description: 'when an included context applies',
          method_name: :context
        }
      ]
    end

    before(:example) do
      described_class.send :include, Spec::IncludedContract

      other_examples.each do |example|
        Spec::IncludedContract.send(
          example[:method_name],
          example[:description],
          &example[:block]
        )
      end
    end

    example_constant 'Spec::IncludedContract' do
      Module.new do
        extend RSpec::SleepingKingStudios::Contract
      end
    end
  end

  let(:described_class) { Spec::ExampleContract }

  example_constant 'Spec::ExampleContract' do
    Module.new do
      extend RSpec::SleepingKingStudios::Contract
    end
  end

  describe '.context' do
    let(:method_name) { :context }

    it 'should define the class method' do
      expect(described_class)
        .to respond_to(:context).with(1).argument
        .and_a_block
    end

    include_examples 'should validate the description and block'

    include_examples 'should define an example'
  end

  describe '.describe' do
    let(:method_name) { :describe }

    it 'should define the class method' do
      expect(described_class)
        .to respond_to(:describe).with(1).argument
        .and_a_block
    end

    include_examples 'should validate the description and block'

    include_examples 'should define an example'
  end

  describe '.examples' do
    it 'should define the class reader' do
      expect(described_class).to respond_to(:examples).with(0).arguments
    end

    it { expect(described_class.examples).to be == [] }

    it 'should return a frozen copy' do
      expect(described_class.examples.frozen?).to be true
    end

    context 'when the contract defines examples' do
      include_context 'when the contract defines examples'

      it { expect(described_class.examples).to be == examples }
    end

    context 'when the contract includes another contract' do
      include_context 'when the contract includes another contract'

      it { expect(described_class.examples).to be == other_examples }

      context 'when the contract defines examples' do
        include_context 'when the contract defines examples'

        it 'should include the other contract\'s examples' do
          expect(described_class.examples).to be == other_examples + examples
        end
      end
    end
  end

  describe '.included' do
    shared_examples 'should apply the examples to the example group' do
      it 'should apply the examples to the example group',
         :aggregate_failures \
      do
        described_class.send :included, example_group

        expected_examples.each do |example|
          expect(example_group)
            .to have_received(example[:method_name])
            .with(example[:description])
        end
      end
    end

    let(:example_group) do
      class_double(
        RSpec::Core::ExampleGroup,
        :<     => nil,
        context:  nil,
        describe: nil,
        it:       nil
      ).tap do |double|
        allow(double)
          .to receive(:<)
          .with(RSpec::Core::ExampleGroup)
          .and_return(true)
      end
    end

    context 'when the contract defines examples' do
      include_context 'when the contract defines examples'

      let(:expected_examples) { examples }

      include_examples 'should apply the examples to the example group'
    end

    context 'when the contract includes another contract' do
      include_context 'when the contract includes another contract'

      let(:expected_examples) { other_examples }

      include_examples 'should apply the examples to the example group'

      context 'when the contract defines examples' do
        include_context 'when the contract defines examples'

        let(:expected_examples) { super() + examples }

        include_examples 'should apply the examples to the example group'
      end
    end
  end

  describe '.it' do
    let(:method_name) { :it }

    it 'should define the class method' do
      expect(described_class)
        .to respond_to(:it).with(0..1).arguments
        .and_a_block
    end

    include_examples 'should validate the description and block',
      allow_nil: true

    include_examples 'should define an example'
  end

  describe '.shared_context' do
    let(:method_name) { :shared_context }

    it 'should define the class method' do
      expect(described_class)
        .to respond_to(:shared_context).with(1).argument
        .and_a_block
    end

    include_examples 'should validate the description and block'

    include_examples 'should define an example'
  end

  describe '.shared_examples' do
    let(:method_name) { :shared_examples }

    it 'should define the class method' do
      expect(described_class)
        .to respond_to(:shared_examples).with(1).argument
        .and_a_block
    end

    include_examples 'should validate the description and block'

    include_examples 'should define an example'
  end
end
