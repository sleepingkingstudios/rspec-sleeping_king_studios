# frozen_string_literal: true

require 'rspec/sleeping_king_studios/concerns/example_constants'
require 'rspec/sleeping_king_studios/matchers/built_in/respond_to'

require 'support/constants/example_class'
require 'support/mock_example_group'

RSpec.describe RSpec::SleepingKingStudios::Concerns::ExampleConstants do
  extend RSpec::SleepingKingStudios::Concerns::ExampleConstants # rubocop:disable RSpec/DescribedClass

  subject(:example) { described_class.new }

  let(:described_class) do
    Class.new(RSpec::Core::ExampleGroup) do
      extend RSpec::SleepingKingStudios::Concerns::ExampleConstants

      def helper_method
        :helper
      end
    end
  end

  describe '::example_class' do
    shared_examples 'should define the class' do
      def define_example_class
        described_class.example_class(class_name, *class_args, &class_proc)
      end

      before(:example) do
        allow(described_class).to receive(:prepend_before).with(:example) \
        do |&block|
          example.instance_exec(&block)
        end

        allow(example).to receive(:stub_const) # rubocop:disable RSpec/SubjectStub
      end

      it 'should delegate to #stub_const' do
        define_example_class

        expect(example) # rubocop:disable RSpec/SubjectStub
          .to have_received(:stub_const)
          .with(class_name.to_s, an_instance_of(Class))
      end

      it 'should define the class', :aggregate_failures do
        defined_class = nil

        allow(example).to receive(:stub_const) do |_, value| # rubocop:disable RSpec/SubjectStub
          defined_class = value
        end

        define_example_class

        expect(defined_class).to be_a Class
        expect(defined_class).to be < base_class
        expect(defined_class.inspect).to be == class_name.to_s
        expect(defined_class.name).to be == class_name.to_s
        expect(defined_class.to_s).to be == class_name.to_s
      end
    end

    let(:base_class) { Object }
    let(:class_name) { 'AnswerClass' }
    let(:class_args) { [] }
    let(:class_proc) { nil }

    it 'should define the class method' do
      expect(described_class)
        .to respond_to(:example_class)
        .with(1..2).arguments
    end

    describe 'with a class name as a String' do
      include_examples 'should define the class'
    end

    describe 'with a class name as a Symbol' do
      let(:class_name) { :AnswerClass }

      include_examples 'should define the class'
    end

    describe 'with a class name and a base class' do
      let(:base_class) { Spec::Support::Constants::ExampleClass }
      let(:class_args) { base_class }

      include_examples 'should define the class',
        ->(klass) { expect(klass.superclass).to be base_class }
    end

    describe 'with a class name and a base class name' do
      let(:base_class) { Spec::Support::Constants::ExampleClass }
      let(:class_args) { base_class.name }

      include_examples 'should define the class',
        ->(klass) { expect(klass.superclass).to be base_class }
    end

    describe 'with a class name and base_class: a class' do
      let(:base_class) { Spec::Support::Constants::ExampleClass }
      let(:class_args) { [{ base_class: }] }

      include_examples 'should define the class',
        ->(klass) { expect(klass.superclass).to be base_class }
    end

    describe 'with a class name and base_class: a class name' do
      let(:base_class) { Spec::Support::Constants::ExampleClass }
      let(:class_args) { [{ base_class: base_class.name }] }

      include_examples 'should define the class',
        ->(klass) { expect(klass.superclass).to be base_class }
    end

    describe 'with a class name and a block' do
      let(:class_proc) do
        ->(klass) { klass.send(:define_method, :value) { 42 } }
      end

      include_examples 'should define the class',
        ->(klass) { expect(klass.new.value).to be 42 }

      describe 'when the block references the example context' do
        let(:class_proc) do
          lambda do |klass|
            helper_value = helper_method

            klass.send(:define_method, :helper_value) { helper_value }
          end
        end

        include_examples 'should define the class',
          ->(klass) { expect(klass.new.helper_value).to be :helper }
      end
    end
  end

  describe '::example_constant' do
    shared_examples 'should define the constant' do
      before(:example) do
        allow(described_class).to receive(:prepend_before).with(:example) \
        do |&block|
          example.instance_exec(&block)
        end

        allow(example).to receive(:stub_const) # rubocop:disable RSpec/SubjectStub
      end

      it 'should delegate to #stub_const' do
        define_example_constant

        expect(example) # rubocop:disable RSpec/SubjectStub
          .to have_received(:stub_const)
          .with(constant_name, constant_value)
      end
    end

    let(:constant_name) { 'THE_ANSWER' }

    it 'should define the class method' do
      expect(described_class)
        .to respond_to(:example_constant)
        .with(1..2).arguments
        .and_keywords(:force)
    end

    describe 'with a constant name and a value' do
      let(:constant_value) { 42 }

      def define_example_constant
        described_class.example_constant(constant_name, constant_value)
      end

      include_examples 'should define the constant'
    end

    describe 'with a constant name and a block' do
      let(:constant_value) { 42 }

      before(:example) do
        value = constant_value

        described_class.send(:define_method, :answer) { value }

        allow(example).to receive(:answer).and_call_original # rubocop:disable RSpec/SubjectStub
      end

      def define_example_constant
        described_class.example_constant(constant_name) { answer }
      end

      include_examples 'should define the constant'
    end

    describe 'with a qualified constant name' do
      let(:constant_name)  { 'Spec::Constants::THE_ANSWER' }
      let(:constant_value) { 42 }

      def define_example_constant
        described_class.example_constant(constant_name, constant_value)
      end

      include_examples 'should define the constant'
    end

    describe 'with force: true' do
      let(:constant_value) { 42 }

      before(:example) do
        allow(tools.core_tools).to receive(:deprecate)
      end

      def tools
        SleepingKingStudios::Tools::Toolbelt.instance
      end

      it 'should print a deprecation warning' do
        described_class
          .example_constant(constant_name, constant_value, force: true)

        expect(tools.core_tools)
          .to have_received(:deprecate)
          .with(
            'ExampleConstants.example_constant with force: true',
            message: 'The :force parameter is no longer required.'
          )
      end
    end

    context 'when the constant is already defined' do
      let(:prior_value)    { 'Forty-two' }
      let(:constant_value) { 42 }

      def define_example_constant
        described_class.example_constant(constant_name, constant_value)
      end

      around(:example) do |example|
        Object.const_set(:THE_ANSWER, prior_value)

        example.call
      ensure
        Object.send(:remove_const, :THE_ANSWER) # rubocop:disable RSpec/RemoveConst
      end

      include_examples 'should define the constant'
    end
  end
end
