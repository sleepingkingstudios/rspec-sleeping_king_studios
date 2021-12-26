# frozen_string_literal: true

require 'spec_helper'

require 'rspec/sleeping_king_studios/concerns/example_constants'
require 'rspec/sleeping_king_studios/concerns/include_contract'
require 'rspec/sleeping_king_studios/concerns/wrap_examples'
require 'rspec/sleeping_king_studios/contract'
require 'rspec/sleeping_king_studios/matchers/built_in/respond_to'

RSpec.describe RSpec::SleepingKingStudios::Concerns::IncludeContract do
  extend RSpec::SleepingKingStudios::Concerns::ExampleConstants
  extend RSpec::SleepingKingStudios::Concerns::WrapExamples

  subject(:example_group) { Spec::ExampleGroup }

  example_class 'Spec::ExampleGroup' do |klass|
    klass.extend RSpec::SleepingKingStudios::Concerns::IncludeContract

    klass.singleton_class.attr_reader \
      :called,
      :called_args,
      :called_block,
      :called_kwargs,
      :focused,
      :skipped

    klass.define_singleton_method(:example_group_method) \
    do |*args, **kwargs, &block|
      @called        = true
      @called_args   = args
      @called_kwargs = kwargs
      @called_block  = block
    end

    klass.define_singleton_method(:fdescribe) do |_name, &block|
      @focused = true

      block.call

      @focused = false
    end

    klass.define_singleton_method(:xdescribe) do |_name, &block|
      @skipped = true

      block.call

      @skipped = false
    end
  end

  describe '.finclude_contract' do
    let(:contract) { -> { :contract } }

    it 'should define the method' do
      expect(example_group)
        .to respond_to(:finclude_contract)
        .with(1).argument
        .and_unlimited_arguments
        .and_arbitrary_keywords
        .and_a_block
    end

    it 'should wrap the contract in an fdescribe block' do
      allow(example_group).to receive(:fdescribe)

      example_group.finclude_contract(contract)

      expect(example_group).to have_received(:fdescribe).with('(focused)')
    end

    it 'should focus the contract', :aggregate_failures do
      allow(example_group).to receive(:include_contract) do
        expect(example_group.focused).to be true
      end

      example_group.finclude_contract(contract)

      expect(example_group)
        .to have_received(:include_contract)
        .with(contract)
    end

    describe 'with arguments' do
      let(:arguments) { %i[ichi ni san] }

      it 'should pass the parameters to the contract' do
        allow(example_group).to receive(:include_contract)

        example_group.finclude_contract(contract, *arguments)

        expect(example_group)
          .to have_received(:include_contract)
          .with(contract, *arguments)
      end
    end

    describe 'with keywords' do
      let(:keywords) { { one: 1, two: 2, three: 3 } }

      it 'should pass the parameters to the contract' do
        allow(example_group).to receive(:include_contract)

        example_group.finclude_contract(contract, **keywords)

        expect(example_group)
          .to have_received(:include_contract)
          .with(contract, **keywords)
      end
    end

    describe 'with a block' do
      let(:block) { -> { :ok } }

      it 'should pass the parameters to the contract', :aggregate_failures do
        received_block = nil

        allow(example_group).to receive(:include_contract) do |&received|
          received_block = received
        end

        example_group.finclude_contract(contract, &block)

        expect(example_group)
          .to have_received(:include_contract)
          .with(contract)

        expect(received_block).to be == block
      end
    end

    describe 'with arguments and keywords' do
      let(:arguments) { %i[ichi ni san] }
      let(:keywords)  { { one: 1, two: 2, three: 3 } }

      it 'should pass the parameters to the contract' do
        allow(example_group).to receive(:include_contract)

        example_group.finclude_contract(contract, *arguments, **keywords)

        expect(example_group)
          .to have_received(:include_contract)
          .with(contract, *arguments, **keywords)
      end
    end

    describe 'with arguments, keywords, and a block' do
      let(:arguments) { %i[ichi ni san] }
      let(:keywords)  { { one: 1, two: 2, three: 3 } }
      let(:block)     { -> { :ok } }

      it 'should pass the parameters to the contract', :aggregate_failures do
        received_block = nil

        allow(example_group).to receive(:include_contract) do |&received|
          received_block = received
        end

        example_group
          .finclude_contract(contract, *arguments, **keywords, &block)

        expect(example_group)
          .to have_received(:include_contract)
          .with(contract, *arguments, **keywords)

        expect(received_block).to be == block
      end
    end
  end

  describe '.include_contract' do
    shared_context 'when the contract is a proc' do
      let(:contract) { implementation }
    end

    shared_context 'when the contract responds to #to_proc' do
      let(:contract) { Spec::Contract.new(implementation) }

      example_class 'Spec::Contract', Struct.new(:block) do |klass|
        klass.alias_method :to_proc, :block
      end
    end

    shared_context 'when the contract is a contract object' do
      let(:contract) { Spec::Contract }

      example_class 'Spec::Contract', RSpec::SleepingKingStudios::Contract \
      do |klass|
        klass.contract(&implementation)
      end
    end

    shared_examples 'should pass the parameters to the contract' do
      it 'should pass the arguments to the contract' do
        include_contract_in_example_group

        expect(example_group.called_args).to be == arguments
      end

      it 'should pass the keywords to the contract' do
        include_contract_in_example_group

        expect(example_group.called_kwargs).to be == keywords
      end

      it 'should pass the block to the contract' do
        include_contract_in_example_group

        expect(example_group.called_block).to be == block
      end
    end

    shared_examples 'should include the contract in the example group' do
      let(:arguments) { [] }
      let(:keywords)  { {} }
      let(:block)     { nil }

      def include_contract_in_example_group
        if keywords.empty?
          example_group.include_contract(contract_or_name, *arguments, &block)
        else
          example_group
            .include_contract(contract_or_name, *arguments, **keywords, &block)
        end
      end

      it 'should include the contract' do
        include_contract_in_example_group

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

    shared_examples 'should resolve and include the contract' do
      wrap_context 'when the contract is a proc' do
        include_examples 'should include the contract in the example group'
      end

      wrap_context 'when the contract responds to #to_proc' do
        include_examples 'should include the contract in the example group'
      end

      wrap_context 'when the contract is a contract object' do
        include_examples 'should include the contract in the example group'
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
      expect(example_group)
        .to respond_to(:include_contract)
        .with(1).argument
        .and_unlimited_arguments
        .and_arbitrary_keywords
        .and_a_block
    end

    describe 'with nil' do
      let(:error_message) { "contract can't be blank" }

      it 'should raise an exception' do
        expect { example_group.include_contract(nil) }
          .to raise_error ArgumentError, error_message
      end
    end

    describe 'with an object' do
      let(:error_message) { 'contract must be a name or respond to #to_proc' }

      it 'should raise an exception' do
        expect { example_group.include_contract(Object.new.freeze) }
          .to raise_error ArgumentError, error_message
      end
    end

    describe 'with an empty string' do
      let(:error_message) { "contract can't be blank" }

      it 'should raise an exception' do
        expect { example_group.include_contract('') }
          .to raise_error ArgumentError, error_message
      end
    end

    describe 'with an empty symbol' do
      let(:error_message) { "contract can't be blank" }

      it 'should raise an exception' do
        expect { example_group.include_contract(:'') }
          .to raise_error ArgumentError, error_message
      end
    end

    describe 'with an invalid string' do
      let(:error_message) { 'undefined contract "invalid contract name"' }

      it 'should raise an exception' do
        expect { example_group.include_contract('invalid contract name') }
          .to raise_error ArgumentError, error_message
      end
    end

    describe 'with an invalid symbol' do
      let(:error_message) { 'undefined contract :invalid_contract_name' }

      it 'should raise an exception' do
        expect { example_group.include_contract(:invalid_contract_name) }
          .to raise_error ArgumentError, error_message
      end
    end

    describe 'with a contract' do
      let(:contract_or_name) { contract }

      include_examples 'should resolve and include the contract'
    end

    describe 'with a class name as a string' do
      let(:contract_or_name) { 'contract to include' }

      before(:example) do
        Spec::ExampleGroup.const_set('ContractToInclude', contract)
      end

      include_examples 'should resolve and include the contract'
    end

    describe 'with a constant name as a string' do
      let(:contract_or_name) { 'contract to include' }

      before(:example) do
        Spec::ExampleGroup.const_set('CONTRACT_TO_INCLUDE', contract)
      end

      include_examples 'should resolve and include the contract'
    end

    describe 'with a class name as a symbol' do
      let(:contract_or_name) { :contract_to_include }

      before(:example) do
        Spec::ExampleGroup.const_set('ContractToInclude', contract)
      end

      include_examples 'should resolve and include the contract'
    end

    describe 'with a constant name as a symbol' do
      let(:contract_or_name) { :contract_to_include }

      before(:example) do
        Spec::ExampleGroup.const_set('CONTRACT_TO_INCLUDE', contract)
      end

      include_examples 'should resolve and include the contract'
    end

    describe 'with a suffixed class name as a string' do
      let(:contract_or_name) { 'contract to include' }

      before(:example) do
        Spec::ExampleGroup.const_set('ContractToIncludeContract', contract)
      end

      include_examples 'should resolve and include the contract'
    end

    describe 'with a suffixed constant name as a string' do
      let(:contract_or_name) { 'contract to include' }

      before(:example) do
        Spec::ExampleGroup.const_set('CONTRACT_TO_INCLUDE_CONTRACT', contract)
      end

      include_examples 'should resolve and include the contract'
    end

    describe 'with a suffixed class name as a symbol' do
      let(:contract_or_name) { :contract_to_include }

      before(:example) do
        Spec::ExampleGroup.const_set('ContractToIncludeContract', contract)
      end

      include_examples 'should resolve and include the contract'
    end

    describe 'with a suffixed constant name as a symbol' do
      let(:contract_or_name) { :contract_to_include }

      before(:example) do
        Spec::ExampleGroup.const_set('CONTRACT_TO_INCLUDE_CONTRACT', contract)
      end

      include_examples 'should resolve and include the contract'
    end
  end

  describe '.xinclude_contract' do
    let(:contract) { -> { :contract } }

    it 'should define the method' do
      expect(example_group)
        .to respond_to(:xinclude_contract)
        .with(1).argument
        .and_unlimited_arguments
        .and_arbitrary_keywords
        .and_a_block
    end

    it 'should wrap the contract in an xdescribe block' do
      allow(example_group).to receive(:xdescribe)

      example_group.xinclude_contract(contract)

      expect(example_group).to have_received(:xdescribe).with('(skipped)')
    end

    it 'should skip the contract', :aggregate_failures do
      allow(example_group).to receive(:include_contract) do
        expect(example_group.skipped).to be true
      end

      example_group.xinclude_contract(contract)

      expect(example_group)
        .to have_received(:include_contract)
        .with(contract)
    end

    describe 'with arguments' do
      let(:arguments) { %i[ichi ni san] }

      it 'should pass the parameters to the contract' do
        allow(example_group).to receive(:include_contract)

        example_group.xinclude_contract(contract, *arguments)

        expect(example_group)
          .to have_received(:include_contract)
          .with(contract, *arguments)
      end
    end

    describe 'with keywords' do
      let(:keywords) { { one: 1, two: 2, three: 3 } }

      it 'should pass the parameters to the contract' do
        allow(example_group).to receive(:include_contract)

        example_group.xinclude_contract(contract, **keywords)

        expect(example_group)
          .to have_received(:include_contract)
          .with(contract, **keywords)
      end
    end

    describe 'with a block' do
      let(:block) { -> { :ok } }

      it 'should pass the parameters to the contract', :aggregate_failures do
        received_block = nil

        allow(example_group).to receive(:include_contract) do |&received|
          received_block = received
        end

        example_group.xinclude_contract(contract, &block)

        expect(example_group)
          .to have_received(:include_contract)
          .with(contract)

        expect(received_block).to be == block
      end
    end

    describe 'with arguments and keywords' do
      let(:arguments) { %i[ichi ni san] }
      let(:keywords)  { { one: 1, two: 2, three: 3 } }

      it 'should pass the parameters to the contract' do
        allow(example_group).to receive(:include_contract)

        example_group.xinclude_contract(contract, *arguments, **keywords)

        expect(example_group)
          .to have_received(:include_contract)
          .with(contract, *arguments, **keywords)
      end
    end

    describe 'with arguments, keywords, and a block' do
      let(:arguments) { %i[ichi ni san] }
      let(:keywords)  { { one: 1, two: 2, three: 3 } }
      let(:block)     { -> { :ok } }

      it 'should pass the parameters to the contract', :aggregate_failures do
        received_block = nil

        allow(example_group).to receive(:include_contract) do |&received|
          received_block = received
        end

        example_group
          .xinclude_contract(contract, *arguments, **keywords, &block)

        expect(example_group)
          .to have_received(:include_contract)
          .with(contract, *arguments, **keywords)

        expect(received_block).to be == block
      end
    end
  end
end
