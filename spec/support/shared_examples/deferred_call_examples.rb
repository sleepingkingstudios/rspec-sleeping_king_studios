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
      let(:block) { -> {} }
    end

    shared_context 'when initialized with arguments' do
      let(:arguments) { ['KSC', 'Launchpad 3'] }
    end

    shared_context 'when initialized with keywords' do
      let(:keywords) { { payload: :satellite } }
    end

    shared_examples 'should be a deferred call' do
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
          expect(deferred).to define_reader(:block).with_value(nil)
        end

        wrap_context 'when initialized with a block' do
          it { expect(deferred.block).to be == block }
        end
      end

      describe '#call' do
        let(:empty_parameters) do
          RUBY_VERSION < '3.0.0' ? {} : no_args
        end
        let(:receiver) do
          instance_double(Spec::Rocket, launch: nil)
        end

        example_class 'Spec::Rocket' do |klass|
          klass.define_method(:launch) { |*, **| nil }
        end

        before(:example) do
          allow(receiver).to receive(method_name) do |*, **, &block|
            block&.call

            { ok: true }
          end
        end

        it { expect(deferred).to respond_to(:call).with(1).argument }

        it 'should call the deferred method' do
          deferred.call(receiver)

          expect(receiver).to have_received(method_name).with(empty_parameters)
        end

        it 'should return the value' do
          expect(deferred.call(receiver)).to be == { ok: true }
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

            expect(receiver).to have_received(method_name).with(**keywords)
          end
        end

        wrap_context 'when initialized with a block' do
          it 'should call the deferred method' do
            deferred.call(receiver)

            expect(receiver)
              .to have_received(method_name)
              .with(empty_parameters)
          end

          it 'should yield the block' do
            expect do |block|
              deferred = described_class.new(method_name, &block)

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
              deferred = described_class.new(method_name, &block)

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
