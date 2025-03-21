# frozen_string_literal: true

require 'rspec/sleeping_king_studios'

RSpec.describe RSpec::SleepingKingStudios::Concerns::ExampleConstants do
  extend RSpec::SleepingKingStudios::Concerns::ExampleConstants # rubocop:disable RSpec/DescribedClass

  describe '#example_class' do
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
  end

  describe '#example_constant' do
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
