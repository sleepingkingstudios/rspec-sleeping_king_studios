# frozen_string_literal: true

require 'rspec/sleeping_king_studios/concerns/example_constants'
require 'rspec/sleeping_king_studios/matchers/built_in/respond_to'

require 'support/constants/example_class'
require 'support/mock_example_group'

RSpec.describe RSpec::SleepingKingStudios::Concerns::ExampleConstants do
  let(:described_class) do
    Class.new(Spec::Support::MockExampleGroup) do
      extend RSpec::SleepingKingStudios::Concerns::ExampleConstants

      def helper_method
        :helper
      end
    end
  end

  describe '::example_class' do
    shared_examples 'should define the class' do |proc = nil|
      def define_example_class
        described_class.example_class(class_name, *class_args, &class_proc)
      end

      context 'before the example is run' do # rubocop:disable RSpec/ContextWording
        it 'should not define the class' do
          define_example_class

          expect { Object.const_get(class_name) }.to raise_error NameError
        end
      end

      context 'while the example is running' do # rubocop:disable RSpec/ContextWording
        it 'should define the class', :aggregate_failures do # rubocop:disable RSpec/ExampleLength
          defined_class = nil

          define_example_class

          allow(described_class.example).to receive(:call) do
            defined_class = Object.const_get(class_name)
          end

          described_class.run_example

          expect(defined_class).to be_a Class
          expect(defined_class.inspect).to be == class_name.to_s
          expect(defined_class.name).to be == class_name.to_s
          expect(defined_class.to_s).to be == class_name.to_s

          instance_exec(defined_class, &proc) unless proc.nil?
        end
      end

      context 'after the example has run' do # rubocop:disable RSpec/ContextWording
        it 'should not define the class' do
          define_example_class

          described_class.run_example

          expect { Object.const_get(class_name) }.to raise_error NameError
        end
      end
    end

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
      context 'before the example is run' do # rubocop:disable RSpec/ContextWording
        it 'should not define the constant' do
          define_example_constant

          expect { Object.const_get(class_name) }.to raise_error NameError
        end
      end

      context 'while the example is running' do # rubocop:disable RSpec/ContextWording
        it 'should define the constant' do
          defined_constant = nil

          define_example_constant

          allow(described_class.example).to receive(:call) do
            defined_constant = Object.const_get(constant_name)
          end

          described_class.run_example

          expect(defined_constant).to be constant_value
        end
      end

      context 'after the example has run' do # rubocop:disable RSpec/ContextWording
        it 'should not define the constant' do
          define_example_constant

          described_class.run_example

          expect { Object.const_get(constant_name) }.to raise_error NameError
        end
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

      context 'when the constant is already defined' do
        let(:prior_value) { 'Forty-two' }
        let(:error_message) do
          "constant #{constant_name} is already defined with value " \
            "#{prior_value.inspect}"
        end

        around(:example) do |example|
          Object.const_set(:THE_ANSWER, prior_value)

          example.call
        ensure
          Object.send(:remove_const, :THE_ANSWER) # rubocop:disable RSpec/RemoveConst
        end

        it 'should raise an error' do
          described_class.example_constant(constant_name, constant_value)

          expect { described_class.run_example }
            .to raise_error(NameError, error_message)
            .and(output.to_stderr)
        end

        describe 'with force: true' do
          let(:expected_warning) do
            /warning: already initialized constant THE_ANSWER/
          end

          def define_example_constant
            described_class
              .example_constant(constant_name, constant_value, force: true)
          end

          # rubocop:disable RSpec/NestedGroups
          context 'before the example is run' do # rubocop:disable RSpec/ContextWording
            it 'should define the constant with the prior value' do
              define_example_constant

              expect(Object.const_get(constant_name)).to be == prior_value
            end
          end

          context 'while the example is running' do # rubocop:disable RSpec/ContextWording
            it 'should define the constant', :aggregate_failures do
              defined_constant = nil

              define_example_constant

              allow(described_class.example).to receive(:call) do
                defined_constant = Object.const_get(constant_name)
              end

              expect { described_class.run_example }
                .to output(expected_warning)
                .to_stderr

              expect(defined_constant).to be constant_value
            end
          end

          context 'after the example has run' do # rubocop:disable RSpec/ContextWording
            it 'should define the constant with the prior value',
              :aggregate_failures \
            do
              define_example_constant

              expect { described_class.run_example }
                .to output
                .to_stderr

              expect(Object.const_get(constant_name)).to be == prior_value
            end
          end
          # rubocop:enable RSpec/NestedGroups
        end
      end
    end

    describe 'with a constant name and a block' do
      let(:constant_value) { 42 }

      before(:example) do
        value = constant_value

        described_class.send(:define_method, :answer) { value }

        allow(described_class.example)
          .to receive(:answer)
          .and_call_original
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

      context 'when the namespace is undefined' do
        let(:constant_name) { 'Examples::Constants::THE_ANSWER' }

        include_examples 'should define the constant'

        context 'before the example is run' do # rubocop:disable RSpec/ContextWording
          it 'should not define the namespace' do
            define_example_constant

            expect { Object.const_get('Examples') }.to raise_error NameError
          end
        end

        context 'after the example has run' do # rubocop:disable RSpec/ContextWording
          it 'should not define the namespace' do
            define_example_constant

            described_class.run_example

            expect { Object.const_get('Examples') }.to raise_error NameError
          end
        end
      end
    end
  end
end
