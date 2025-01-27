# frozen_string_literal: true

require 'rspec/sleeping_king_studios/concerns/example_constants'
require 'rspec/sleeping_king_studios/concerns/shared_example_group'
require 'rspec/sleeping_king_studios/concerns/wrap_examples'
require 'rspec/sleeping_king_studios/matchers/core/construct'
require 'rspec/sleeping_king_studios/matchers/core/have_reader'

require 'support/shared_examples'

module Spec::Support::SharedExamples
  module DeferredCallExamples
    extend RSpec::SleepingKingStudios::Concerns::SharedExampleGroup

    shared_context 'when initialized with a block' do
      let(:block) { super() || -> {} }
    end

    shared_context 'when initialized with arguments' do
      let(:arguments) { super() + ['KSC', 'Launchpad 3'] }
    end

    shared_context 'when initialized with keywords' do
      let(:keywords) { super().merge(payload: :satellite) }
    end

    shared_examples 'should be a deferred call' do |**examples_options|
      extend RSpec::SleepingKingStudios::Concerns::ExampleConstants
      extend RSpec::SleepingKingStudios::Concerns::WrapExamples

      describe '.new' do
        it 'should define the constructor' do
          expect(described_class)
            .to be_constructible
            .with(1).argument
            .and_unlimited_arguments
            .and_any_keywords
            .and_a_block
        end

        describe 'with method_name: nil' do
          let(:error_message) { "method_name can't be blank" }

          it 'should raise an exception' do
            expect { described_class.new(nil) }
              .to raise_error ArgumentError, error_message
          end
        end

        describe 'with method_name: an Object' do
          let(:error_message) { 'method_name is not a String or a Symbol' }

          it 'should raise an exception' do
            expect { described_class.new(Object.new.freeze) }
              .to raise_error ArgumentError, error_message
          end
        end

        describe 'with method_name: an empty String' do
          let(:error_message) { "method_name can't be blank" }

          it 'should raise an exception' do
            expect { described_class.new('') }
              .to raise_error ArgumentError, error_message
          end
        end

        describe 'with method_name: an empty Symbol' do
          let(:error_message) { "method_name can't be blank" }

          it 'should raise an exception' do
            expect { described_class.new(:'') }
              .to raise_error ArgumentError, error_message
          end
        end
      end

      describe '#==' do
        let(:other_mname)  { method_name }
        let(:other_args)   { arguments }
        let(:other_kwargs) { keywords }
        let(:other_block)  { block }
        let(:other) do
          described_class
            .new(other_mname, *other_args, **other_kwargs, &other_block)
        end

        describe 'with nil' do
          it { expect(deferred == nil).to be false } # rubocop:disable Style/NilComparison
        end

        describe 'with an Object' do
          it { expect(deferred == Object.new.freeze).to be false }
        end

        describe 'with a deferred call with non-matching type' do
          let(:other) do
            Spec::CustomDeferredCall
              .new(other_mname, *other_args, **other_kwargs, &other_block)
          end

          example_class 'Spec::CustomDeferredCall',
            RSpec::SleepingKingStudios::Deferred::Call

          it { expect(deferred == other).to be false }
        end

        describe 'with a deferred call with matching type' do
          it { expect(deferred == other).to be true }

          describe 'with a non-matching method name' do
            let(:other_mname) do
              examples_options.fetch(:other_method_name, :other_method)
            end

            it { expect(deferred == other).to be false }
          end

          describe 'with non-matching arguments' do
            let(:other_args) do
              examples_options.fetch(
                :other_arguments,
                %i[other arguments array]
              )
            end

            it { expect(deferred == other).to be false }
          end

          describe 'with non-matching keywords' do
            let(:other_kwargs) { { other: 'value', kwargs: 'value' } }

            it { expect(deferred == other).to be false }
          end

          describe 'with a non-matching block' do
            let(:other_block) { -> { false } }

            it { expect(deferred == other).to be false }
          end
        end

        wrap_context 'when initialized with arguments' do
          describe 'with a deferred call with matching type' do
            it { expect(deferred == other).to be true }

            describe 'with non-matching arguments' do
              let(:other_args) do
                examples_options.fetch(
                  :other_arguments,
                  %i[other arguments array]
                )
              end

              it { expect(deferred == other).to be false }
            end
          end
        end

        wrap_context 'when initialized with a block' do
          describe 'with a deferred call with matching type' do
            it { expect(deferred == other).to be true }

            describe 'with a non-matching block' do
              let(:other_block) { -> { false } }

              it { expect(deferred == other).to be false }
            end
          end
        end

        wrap_context 'when initialized with keywords' do
          describe 'with a deferred call with matching type' do
            it { expect(deferred == other).to be true }

            describe 'with non-matching keywords' do
              let(:other_kwargs) { { other: 'value', kwargs: 'value' } }

              it { expect(deferred == other).to be false }
            end
          end
        end
      end

      describe '#arguments' do
        it 'should define the reader method' do
          expect(deferred).to define_reader(:arguments).with_value(arguments)
        end

        wrap_context 'when initialized with arguments' do
          it { expect(deferred.arguments).to be == arguments }
        end
      end

      describe '#block' do
        it 'should define the reader method' do
          expect(deferred).to define_reader(:block).with_value(block)
        end

        wrap_context 'when initialized with a block' do
          it { expect(deferred.block).to be == block }
        end
      end

      describe '#call' do
        let(:empty_parameters) do
          RUBY_VERSION < '3.0.0' ? [{}] : no_args
        end
        let(:expected_arguments) do
          next empty_parameters if arguments.empty?

          RUBY_VERSION < '3.0.0' ? [*arguments, {}] : arguments
        end
        let(:return_value) do
          next { ok: true } unless examples_options.key?(:return_value)

          value = examples_options[:return_value]

          value = instance_exec(&value) if value.is_a?(Proc)

          value
        end

        before(:example) do
          allow(receiver).to receive(method_name) do |*, **, &block|
            block&.call

            return_value
          end
        end

        it { expect(deferred).to respond_to(:call).with(1).argument }

        it 'should call the deferred method' do
          deferred.call(receiver)

          expect(receiver)
            .to have_received(method_name)
            .with(*expected_arguments)
        end

        it 'should return the value' do
          expect(deferred.call(receiver)).to be == return_value
        end

        wrap_context 'when initialized with arguments' do
          let(:expected_arguments) do
            RUBY_VERSION < '3.0.0' ? [*arguments, {}] : arguments
          end

          it 'should call the deferred method' do
            deferred.call(receiver)

            expect(receiver)
              .to have_received(method_name)
              .with(*expected_arguments)
          end
        end

        wrap_context 'when initialized with keywords' do
          it 'should call the deferred method' do
            deferred.call(receiver)

            expect(receiver)
              .to have_received(method_name)
              .with(*arguments, **keywords)
          end
        end

        wrap_context 'when initialized with a block' do
          it 'should call the deferred method' do
            deferred.call(receiver)

            expect(receiver)
              .to have_received(method_name)
              .with(*expected_arguments)
          end

          it 'should yield the block' do
            expect do |block|
              deferred = described_class.new(method_name, *arguments, &block)

              deferred.call(receiver)
            end
              .to yield_control
          end
        end

        context 'when initialized with mixed parameters' do
          include_context 'when initialized with arguments'
          include_context 'when initialized with keywords'
          include_context 'when initialized with a block'

          it 'should call the deferred method' do
            deferred.call(receiver)

            expect(receiver)
              .to have_received(method_name)
              .with(*arguments, **keywords)
          end

          it 'should yield the block' do
            expect do |block|
              deferred = described_class.new(method_name, *arguments, &block)

              deferred.call(receiver)
            end
              .to yield_control
          end
        end
      end

      describe '#keywords' do
        it 'should define the reader method' do
          expect(deferred).to define_reader(:keywords).with_value(keywords)
        end

        wrap_context 'when initialized with keywords' do
          it { expect(deferred.keywords).to be == keywords }
        end
      end

      describe '#method_name' do
        it 'should define the reader method' do
          expect(deferred)
            .to define_reader(:method_name)
            .with_value(method_name)
        end
      end
    end
  end
end
