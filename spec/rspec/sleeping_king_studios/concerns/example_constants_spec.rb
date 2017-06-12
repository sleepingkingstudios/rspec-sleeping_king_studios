# spec/rspec/sleeping_king_studios/concerns/example_constants_spec.rb

require 'spec_helper'

require 'rspec/sleeping_king_studios/concerns/example_constants'

require 'support/mock_example_group'

module Spec
  module Constants
    class ExampleClass; end
  end # module
end # module

RSpec.describe RSpec::SleepingKingStudios::Concerns::ExampleConstants do
  let(:described_class) do
    Class.new(Spec::Support::MockExampleGroup) do
      extend RSpec::SleepingKingStudios::Concerns::ExampleConstants
    end # class
  end # let

  describe '::example_class' do
    let(:class_name) { 'AnswerClass' }

    it 'should define the class method' do
      expect(described_class).
        to respond_to(:example_class).
        with(1).argument.
        and_keywords(:base_class)
    end # it

    describe 'with a class name' do
      it 'should define the class' do
        expect(described_class).
          to receive(:example_constant) do |constant_name, &block|
            expect(constant_name).to be == class_name

            constant_value = block.call

            expect(constant_value).to be_a Class
            expect(constant_value.name).to be == class_name
            expect(constant_value.name).to be == class_name
            expect(constant_value.to_s).to be == class_name
          end # receive

        described_class.example_class class_name
      end # it
    end # describe

    describe 'with a class name and a base class' do
      let(:base_class) { Spec::Constants::ExampleClass }

      it 'should define the class' do
        expect(described_class).
          to receive(:example_constant) do |constant_name, &block|
            expect(constant_name).to be == class_name

            constant_value = block.call

            expect(constant_value).to be_a Class
            expect(constant_value.inspect).to be == class_name
            expect(constant_value.name).to be == class_name
            expect(constant_value.to_s).to be == class_name
            expect(constant_value.superclass).to be base_class
          end # receive

        described_class.example_class class_name, :base_class => base_class
      end # it
    end # describe

    describe 'with a class name and a base class name' do
      let(:base_class) { Spec::Constants::ExampleClass }

      it 'should define the class' do
        expect(described_class).
          to receive(:example_constant) do |constant_name, &block|
            expect(constant_name).to be == class_name

            constant_value = block.call

            expect(constant_value).to be_a Class
            expect(constant_value.inspect).to be == class_name
            expect(constant_value.name).to be == class_name
            expect(constant_value.to_s).to be == class_name
            expect(constant_value.superclass).to be base_class
          end # receive

        described_class.example_class class_name, :base_class => base_class.name
      end # it
    end # describe

    describe 'with a class name and a block' do
      it 'should yield the class' do
        expect(described_class).
          to receive(:example_constant) do |constant_name, &block|
            expect(constant_name).to be == class_name

            constant_value = block.call

            expect(constant_value).to be_a Class
            expect(constant_value.inspect).to be == class_name
            expect(constant_value.name).to be == class_name
            expect(constant_value.to_s).to be == class_name
            expect(constant_value.new.value).to be 42
          end # receive

        described_class.example_class(class_name) do |klass|
          klass.send(:define_method, :value) { 42 }
        end # described_class
      end # it
    end # describe
  end # describe

  describe '::example_constant' do
    let(:constant_name) { 'THE_ANSWER' }

    it 'should define the class method' do
      expect(described_class).
        to respond_to(:example_constant).
        with(1..2).arguments.
        and_keywords(:force)
    end # it

    describe 'with a constant name and a value' do
      let(:constant_value) { 42 }

      it 'should set the constant' do
        described_class.example_constant constant_name, constant_value

        expect { Object.const_get constant_name }.to raise_error NameError

        expect(described_class.example).to receive(:call) do
          expect(Object.const_get constant_name).to be constant_value
        end # receive

        described_class.run_example

        expect { Object.const_get constant_name }.to raise_error NameError
      end # it

      context 'when the constant is already defined' do
        let(:prior_value) { 'Forty-two' }

        around(:example) do |example|
          begin
            Object.const_set(:THE_ANSWER, prior_value)

            example.call
          ensure
            Object.send(:remove_const, :THE_ANSWER)
          end # begin-ensure
        end # around example

        it 'should raise an error' do
          message =
            "constant #{constant_name} is already defined with value "\
            "#{prior_value.inspect}"

          described_class.example_constant constant_name, constant_value

          expect { described_class.run_example }.
            to raise_error NameError, message
        end # it

        describe 'with :force => true' do
          it 'should override the constant' do
            described_class.example_constant constant_name, constant_value, :force => true

            expect(Object.const_get constant_name).to be == prior_value

            expect(described_class.example).to receive(:call) do
              expect(Object.const_get constant_name).to be constant_value
            end # receive

            described_class.run_example

            expect(Object.const_get constant_name).to be == prior_value
          end # it
        end # describe
      end # context
    end # describe

    describe 'with a constant name and a block' do
      let(:constant_value) { 42 }

      before(:example) do
        described_class.send(:define_method, :answer) {}

        allow(described_class.example).
          to receive(:answer).
          and_return(constant_value)
      end # before example

      it 'should set the constant' do
        described_class.example_constant(constant_name) { answer }

        expect { Object.const_get constant_name }.to raise_error NameError

        expect(described_class.example).to receive(:call) do
          expect(Object.const_get constant_name).to be constant_value
        end # receive

        described_class.run_example

        expect { Object.const_get constant_name }.to raise_error NameError
      end # it
    end # describe

    describe 'with a qualified constant name' do
      let(:constant_name)  { 'Spec::Constants::THE_ANSWER' }
      let(:constant_value) { 42 }

      it 'should set the constant' do
        described_class.example_constant constant_name, constant_value

        expect { Object.const_get constant_name }.to raise_error NameError

        expect(described_class.example).to receive(:call) do
          expect(Object.const_get constant_name).to be constant_value
        end # receive

        described_class.run_example

        expect { Object.const_get constant_name }.to raise_error NameError
      end # it

      context 'when the namespace is undefined' do
        let(:constant_name) { 'Examples::Constants::THE_ANSWER' }

        it 'should set the constant' do
          described_class.example_constant constant_name, constant_value

          expect { Object.const_get 'Examples' }.to raise_error NameError

          expect { Object.const_get constant_name }.to raise_error NameError

          expect(described_class.example).to receive(:call) do
            expect(Object.const_get constant_name).to be constant_value
          end # receive

          described_class.run_example

          expect { Object.const_get 'Examples' }.to raise_error NameError

          expect { Object.const_get constant_name }.to raise_error NameError
        end # it
      end # context
    end # describe
  end # describe
end # describe
