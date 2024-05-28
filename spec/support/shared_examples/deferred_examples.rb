# frozen_string_literal: true

require 'rspec/sleeping_king_studios/concerns/shared_example_group'
require 'rspec/sleeping_king_studios/matchers/built_in/respond_to'

require 'support/isolated_example_group'
require 'support/shared_examples'

module Spec::Support::SharedExamples
  module DeferredExamples
    extend RSpec::SleepingKingStudios::Concerns::SharedExampleGroup

    shared_examples 'should define deferred examples' do
      shared_examples 'should define an example macro' do |method_name|
        let(:arguments) { %w[tag_0 tag_1] }
        let(:keywords)  { { option: 'value' } }
        let(:block)     { -> {} }

        it 'should define the class method' do
          expect(described_class)
            .to respond_to(method_name)
            .with(0).arguments
            .and_unlimited_arguments
            .and_any_keywords
            .and_a_block
        end

        it 'should add a deferred example to the class' do
          expect do
            described_class.send(method_name, *arguments, **keywords, &block)
          end
            .to change(described_class, :deferred_calls)
        end

        it 'should define a deferred example', :aggregate_failures do
          described_class.send(method_name, *arguments, **keywords, &block)

          deferred = described_class.deferred_calls.last

          expect(deferred)
            .to be_a(RSpec::SleepingKingStudios::Deferred::Calls::Example)
          expect(deferred.method_name).to be method_name
          expect(deferred.arguments).to be == arguments
          expect(deferred.keywords).to be == keywords
          expect(deferred.block).to be == block
        end

        context 'when the deferred examples are called' do
          let(:example_group) { instance_double(RSpec::Core::ExampleGroup) }

          it 'should call the deferred example' do
            described_class.send(method_name, *arguments, **keywords, &block)

            deferred = described_class.deferred_calls.last

            allow(deferred).to receive(:call)

            described_class.call(example_group)

            expect(deferred).to have_received(:call).with(example_group)
          end
        end
      end

      describe '.example' do
        include_examples 'should define an example macro', :example
      end

      describe '.fexample' do
        include_examples 'should define an example macro', :fexample
      end

      describe '.fit' do
        include_examples 'should define an example macro', :fit
      end

      describe '.focus' do
        include_examples 'should define an example macro', :focus
      end

      describe '.fspecify' do
        include_examples 'should define an example macro', :fspecify
      end

      describe '.it' do
        include_examples 'should define an example macro', :it
      end

      describe '.pending' do
        include_examples 'should define an example macro', :pending
      end

      describe '.skip' do
        include_examples 'should define an example macro', :skip
      end

      describe '.specify' do
        include_examples 'should define an example macro', :specify
      end

      describe '.xexample' do
        include_examples 'should define an example macro', :xexample
      end

      describe '.xit' do
        include_examples 'should define an example macro', :xit
      end

      describe '.xspecify' do
        include_examples 'should define an example macro', :xspecify
      end
    end
  end
end
