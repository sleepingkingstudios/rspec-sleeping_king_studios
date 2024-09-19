# frozen_string_literal: true

require 'rspec/sleeping_king_studios'

RSpec.describe RSpec::SleepingKingStudios::Concerns::ExampleConstants do
  extend RSpec::SleepingKingStudios::Concerns::ExampleConstants # rubocop:disable RSpec/DescribedClass

  describe '.example_class' do
    let(:described_class) { ExampleClass }

    describe 'with a class name' do
      example_class 'ExampleClass'

      it { expect(described_class).to be_a Class }
    end

    describe 'with a namespaced class name' do
      let(:described_class) { Spec::Namespace::ExampleClass }

      example_class 'Spec::Namespace::ExampleClass'

      it { expect(described_class).to be_a Class }
    end

    describe 'with a class name and base class: a Class' do
      example_class 'ExampleClass', StandardError

      it { expect(described_class).to be_a Class }

      it { expect(described_class).to be < StandardError }
    end

    describe 'with a class name and base class: a Hash' do
      example_class 'ExampleClass', base_class: StandardError

      it { expect(described_class).to be_a Class }

      it { expect(described_class).to be < StandardError }
    end

    describe 'with a class name and base class: a String' do
      example_class 'ExampleClass', 'StandardError'

      it { expect(described_class).to be_a Class }

      it { expect(described_class).to be < StandardError }
    end

    describe 'with a class name and base class: an example class name' do
      example_class 'ExampleError', StandardError

      example_class 'ExampleClass', 'ExampleError'

      it { expect(described_class).to be_a Class }

      it { expect(described_class).to be < StandardError }

      it { expect(described_class).to be < ExampleError }
    end

    describe 'with a class name and a block' do
      subject(:instance) { described_class.new }

      example_class 'ExampleClass' do |klass|
        klass.define_method(:ok) { true }
      end

      it { expect(described_class).to be_a Class }

      it { expect(instance.ok).to be true }
    end

    describe 'hooks' do
      let(:ref) { Struct.new(:value).new }

      example_class 'ExampleClass'

      before(:example) do
        ref.value = ExampleClass
      end

      it { expect(ref.value).to be_a Class }
    end

    describe 'inheritance' do
      example_class 'Spec::Grandparent'

      it { expect(Spec::Grandparent).to be_a Class }

      describe 'with a child example group' do
        example_class 'Spec::Parent', 'Spec::Grandparent'

        it { expect(Spec::Grandparent).to be_a Class }

        it { expect(Spec::Parent).to be_a Class }

        describe 'with a grandchild example group' do
          example_class 'Spec::Child', 'Spec::Parent'

          it { expect(Spec::Grandparent).to be_a Class }

          it { expect(Spec::Parent).to be_a Class }

          it { expect(Spec::Child).to be_a Class }
        end
      end
    end

    describe 'precedence' do
      let(:options) { {} }

      before(:example) do
        options[:modified] = true
      end

      it { expect(options[:modified]).to be true }

      describe 'with an example constant defined in a child example group' do
        let(:options) { super().merge(value: Spec::Value.new) }

        example_class 'Spec::Value'

        it { expect(options[:modified]).to be true }
      end
    end
  end

  describe '.example_constant' do
    describe 'with a constant name and a block' do
      let(:the_answer) { 42 }

      example_constant 'THE_ANSWER' do
        the_answer
      end

      it { expect(THE_ANSWER).to be 42 }
    end

    describe 'with a constant name and a value' do
      example_constant 'THE_ANSWER', 42

      it { expect(THE_ANSWER).to be 42 }
    end

    describe 'with a namespaced constant name' do
      example_constant 'Spec::Constants::THE_ANSWER', 42

      it { expect(Spec::Constants::THE_ANSWER).to be 42 }
    end
  end
end
