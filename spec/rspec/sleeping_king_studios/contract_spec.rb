# frozen_string_literal: true

require 'spec_helper'

require 'rspec/sleeping_king_studios/concerns/example_constants'
require 'rspec/sleeping_king_studios/concerns/wrap_examples'
require 'rspec/sleeping_king_studios/contract'
require 'rspec/sleeping_king_studios/matchers/built_in/respond_to'

RSpec.describe RSpec::SleepingKingStudios::Contract do
  extend RSpec::SleepingKingStudios::Concerns::ExampleConstants
  extend RSpec::SleepingKingStudios::Concerns::IncludeContract
  extend RSpec::SleepingKingStudios::Concerns::WrapExamples

  subject(:contract) { described_class.new }

  let(:described_class) { Spec::Contract }
  let(:example_group) do
    Spec::ExampleGroup.tap do |group|
      allow(group).to receive(:custom_hook)

      allow(group).to receive(:describe)
    end
  end

  example_class 'Spec::Contract' do |klass|
    klass.extend RSpec::SleepingKingStudios::Contract
  end

  example_class 'Spec::ExampleGroup' do |klass|
    klass.extend RSpec::SleepingKingStudios::Concerns::IncludeContract

    klass.singleton_class.attr_reader \
      :called,
      :called_args,
      :called_block,
      :called_kwargs

    klass.define_singleton_method(:example_group_method) \
    do |*args, **kwargs, &block|
      @called        = true
      @called_args   = args
      @called_kwargs = kwargs
      @called_block  = block
    end

    klass.define_singleton_method(:custom_hook) { |*_args, **_opts| }

    klass.define_singleton_method(:describe) { |_description, &_block| }
  end

  describe '.apply' do
    shared_examples 'should pass the parameters to the contract' do
      it 'should pass the arguments to the contract' do
        apply_contract

        expect(example_group.called_args).to be == arguments
      end

      it 'should pass the keywords to the contract' do
        apply_contract

        expect(example_group.called_kwargs).to be == keywords
      end

      it 'should pass the block to the contract' do
        apply_contract

        expect(example_group.called_block).to be == block
      end
    end

    shared_examples 'should include the contract in the example group' do
      let(:arguments) { [] }
      let(:keywords)  { {} }
      let(:block)     { nil }

      def apply_contract
        if keywords.empty?
          described_class.apply(example_group, *arguments, &block)
        else
          described_class.apply(example_group, *arguments, **keywords, &block)
        end
      end

      it 'should include the contract' do
        apply_contract

        expect(example_group.called).to be true
      end

      include_examples 'should pass the parameters to the contract'

      describe 'with arguments' do
        let(:arguments) { %i[ichi ni san] }

        include_examples 'should pass the parameters to the contract'
      end

      describe 'with keywords' do
        let(:keywords) { { one: 1, two: 2, three: 3 } }

        include_examples 'should pass the parameters to the contract'
      end

      describe 'with a block' do
        let(:block) { -> { :ok } }

        include_examples 'should pass the parameters to the contract'
      end

      describe 'with arguments and keywords' do
        let(:arguments) { %i[ichi ni san] }
        let(:keywords)  { { one: 1, two: 2, three: 3 } }

        include_examples 'should pass the parameters to the contract'
      end

      describe 'with arguments, keywords, and a block' do
        let(:arguments) { %i[ichi ni san] }
        let(:keywords)  { { one: 1, two: 2, three: 3 } }
        let(:block)     { -> { :ok } }

        include_examples 'should pass the parameters to the contract'
      end
    end

    let(:implementation) do
      lambda do |*args, **kwargs, &block|
        if kwargs.empty?
          example_group_method(*args, &block)
        else
          example_group_method(*args, **kwargs, &block)
        end
      end
    end

    it 'should define the class method' do
      expect(described_class)
        .to respond_to(:apply)
        .with(1).argument
        .and_unlimited_arguments
        .and_arbitrary_keywords
        .and_a_block
    end

    context 'when the class has a contract' do
      before(:example) { described_class.contract(&implementation) }

      include_examples 'should include the contract in the example group'
    end
  end

  describe '.contract' do
    it 'should define the class method' do
      expect(described_class)
        .to respond_to(:contract)
        .with(0).arguments
        .and_a_block
    end

    it { expect(described_class.contract).to be nil }

    describe 'with a block' do
      let(:implementation) { -> {} }

      it 'should set the contract' do
        expect { described_class.contract(&implementation) }
          .to change(described_class, :contract)
          .to be == implementation
      end
    end

    context 'when the class has a contract' do
      let(:previous_implementation) { -> { :old } }

      before(:example) { described_class.contract(&previous_implementation) }

      it { expect(described_class.contract).to be == previous_implementation }

      describe 'with a block' do
        let(:implementation) { -> {} }

        it 'should set the contract' do
          expect { described_class.contract(&implementation) }
            .to change(described_class, :contract)
            .to be == implementation
        end
      end
    end
  end

  describe '.to_proc' do
    it { expect(described_class).to respond_to(:to_proc).with(0).arguments }

    it { expect(described_class.to_proc).to be nil }

    context 'when the class has a contract' do
      let(:implementation) { -> { :old } }

      before(:example) { described_class.contract(&implementation) }

      it { expect(described_class.to_proc).to be == implementation }
    end
  end
end
