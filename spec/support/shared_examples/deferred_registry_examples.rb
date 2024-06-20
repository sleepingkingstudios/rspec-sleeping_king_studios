# frozen_string_literal: true

require 'rspec/sleeping_king_studios/concerns/shared_example_group'

require 'support/shared_examples'

module Spec::Support::SharedExamples
  module DeferredRegistryExamples
    extend RSpec::SleepingKingStudios::Concerns::SharedExampleGroup

    shared_examples 'should define a registry for deferred examples' do
      shared_context 'when the parent registry has deferred examples' do
        let(:ancestor_deferred_examples) do
          {
            'should do a thing'        => -> {},
            'should do something else' => -> {},
            'should act as expected'   => -> {}
          }
        end

        before(:example) do
          ancestor_deferred_examples.each do |description, block|
            ancestor_class.add_deferred_examples(description, &block)
          end

          ancestor_class.const_set(
            :ShouldBehaveLikeABasicObjectExamples,
            Module.new do
              include RSpec::SleepingKingStudios::Deferred::Examples
            end
          )

          ancestor_class.const_set(
            :ShouldBehaveLikeAnObjectExamples,
            Module.new do
              include RSpec::SleepingKingStudios::Deferred::Examples
            end
          )
        end
      end

      shared_context 'when the registry has deferred examples' do
        let(:expected_deferred_examples) do
          {
            'should do something'           => -> {},
            'should do something else'      => -> {},
            'should do something different' => -> {}
          }
        end

        before(:example) do
          expected_deferred_examples.each do |description, block|
            described_class.add_deferred_examples(description, &block)
          end

          described_class.const_set(
            :ShouldBehaveLikeAnObjectExamples,
            Module.new do
              include RSpec::SleepingKingStudios::Deferred::Examples
            end
          )

          described_class.const_set(
            :ShouldBehaveLikeAComplexObjectExamples,
            Module.new do
              include RSpec::SleepingKingStudios::Deferred::Examples
            end
          )

          described_class.const_set(
            :ShouldActAsExpectedExamples,
            Module.new do
              include RSpec::SleepingKingStudios::Deferred::Examples
            end
          )
        end
      end

      describe '.add_deferred_examples' do
        let(:description) { 'should do something' }
        let(:block)       { -> {} }

        it 'should define the class method' do
          expect(described_class)
            .to respond_to(:add_deferred_examples)
            .with(1).argument
            .and_a_block
        end

        describe 'with block: nil' do
          let(:error_message) do
            'block is required'
          end

          it 'should raise an exception' do
            expect { described_class.add_deferred_examples(description) }
              .to raise_error ArgumentError, error_message
          end
        end

        describe 'with description: nil' do
          let(:error_message) do
            "description can't be blank"
          end

          it 'should raise an exception' do
            expect { described_class.add_deferred_examples(nil, &block) }
              .to raise_error ArgumentError, error_message
          end
        end

        describe 'with description: an Object' do
          let(:description) { Object.new.freeze }
          let(:error_message) do
            'description is not a String or a Symbol'
          end

          it 'should raise an exception' do
            expect do
              described_class.add_deferred_examples(description, &block)
            end
              .to raise_error ArgumentError, error_message
          end
        end

        describe 'with description: an empty String' do
          let(:error_message) do
            "description can't be blank"
          end

          it 'should raise an exception' do
            expect { described_class.add_deferred_examples('', &block) }
              .to raise_error ArgumentError, error_message
          end
        end

        describe 'with description: an empty Symbol' do
          let(:error_message) do
            "description can't be blank"
          end

          it 'should raise an exception' do
            expect { described_class.add_deferred_examples(:'', &block) }
              .to raise_error ArgumentError, error_message
          end
        end

        describe 'with description: a String' do
          it 'should add the definition to the deferred examples' do
            described_class.add_deferred_examples(description, &block)

            expect(
              described_class.defined_deferred_examples.fetch(description)
            )
              .to be block
          end
        end

        describe 'with description: a Symbol' do
          let(:description) { :should_do_something }

          it 'should add the definition to the deferred examples' do
            described_class.add_deferred_examples(description, &block)

            expect(
              described_class.defined_deferred_examples.fetch(description.to_s)
            )
              .to be block
          end
        end
      end

      describe '.defined_deferred_examples' do
        it 'should define the class method' do
          expect(described_class)
            .to respond_to(:defined_deferred_examples)
            .with(0).arguments
        end

        it { expect(described_class.defined_deferred_examples).to be == {} }

        context 'when the parent registry has deferred examples' do
          include_context 'when the parent registry has deferred examples'

          it { expect(described_class.defined_deferred_examples).to be == {} }
        end

        context 'when the registry has deferred examples' do
          include_context 'when the registry has deferred examples'

          it 'should return the defined examples' do
            expect(described_class.defined_deferred_examples)
              .to be == expected_deferred_examples
          end
        end
      end

      describe '.find_deferred_examples' do
        it 'should define the class method' do
          expect(described_class)
            .to respond_to(:find_deferred_examples)
            .with(1).argument
        end

        describe 'with nil' do
          let(:error_message) do
            "description can't be blank"
          end

          it 'should raise an exception' do
            expect { described_class.find_deferred_examples(nil) }
              .to raise_error ArgumentError, error_message
          end
        end

        describe 'with an Object' do
          let(:description) { Object.new.freeze }
          let(:error_message) do
            'description is not a String or a Symbol'
          end

          it 'should raise an exception' do
            expect { described_class.find_deferred_examples(description) }
              .to raise_error ArgumentError, error_message
          end
        end

        describe 'with an empty String' do
          let(:error_message) do
            "description can't be blank"
          end

          it 'should raise an exception' do
            expect { described_class.find_deferred_examples('') }
              .to raise_error ArgumentError, error_message
          end
        end

        describe 'with empty Symbol' do
          let(:error_message) do
            "description can't be blank"
          end

          it 'should raise an exception' do
            expect { described_class.find_deferred_examples(:'') }
              .to raise_error ArgumentError, error_message
          end
        end

        describe 'with invalid String' do
          let(:description) { 'should do nothing' }
          let(:error_class) do
            namespace = RSpec::SleepingKingStudios::Deferred::Registry

            namespace::DeferredExamplesNotFoundError
          end
          let(:error_message) do
            'deferred examples not found with description ' \
              "#{description.to_s.inspect}"
          end

          it 'should raise an exception' do
            expect { described_class.find_deferred_examples(description) }
              .to raise_error error_class, error_message
          end
        end

        describe 'with invalid Symbol' do
          let(:description) { :should_do_nothing }
          let(:error_class) do
            namespace = RSpec::SleepingKingStudios::Deferred::Registry

            namespace::DeferredExamplesNotFoundError
          end
          let(:error_message) do
            'deferred examples not found with description ' \
              "#{description.to_s.inspect}"
          end

          it 'should raise an exception' do
            expect { described_class.find_deferred_examples(description) }
              .to raise_error error_class, error_message
          end
        end

        context 'when the parent registry has deferred examples' do
          include_context 'when the parent registry has deferred examples'

          describe 'with an invalid String' do
            let(:description) { 'should do nothing' }
            let(:error_class) do
              namespace = RSpec::SleepingKingStudios::Deferred::Registry

              namespace::DeferredExamplesNotFoundError
            end
            let(:error_message) do
              'deferred examples not found with description ' \
                "#{description.to_s.inspect}"
            end

            it 'should raise an exception' do
              expect { described_class.find_deferred_examples(description) }
                .to raise_error error_class, error_message
            end
          end

          describe 'with an invalid Symbol' do
            let(:description) { :should_do_nothing }
            let(:error_class) do
              namespace = RSpec::SleepingKingStudios::Deferred::Registry

              namespace::DeferredExamplesNotFoundError
            end
            let(:error_message) do
              'deferred examples not found with description ' \
                "#{description.to_s.inspect}"
            end

            it 'should raise an exception' do
              expect { described_class.find_deferred_examples(description) }
                .to raise_error error_class, error_message
            end
          end

          describe 'with examples defined on the parent as a String' do
            let(:description) { 'should do a thing' }

            it 'should return the matching definition from the parent' do
              expect(described_class.find_deferred_examples(description))
                .to be ancestor_deferred_examples[description.to_s]
            end
          end

          describe 'with examples defined on the parent as a Symbol' do
            let(:description) { :'should do a thing' }

            it 'should return the matching definition from the parent' do
              expect(described_class.find_deferred_examples(description))
                .to be ancestor_deferred_examples[description.to_s]
            end
          end

          describe 'with an exact module name defined on the parent' do
            let(:description) { 'ShouldBehaveLikeABasicObjectExamples' }

            it 'should return the matching definition from the parent' do
              expect(described_class.find_deferred_examples(description))
                .to be ancestor_class::ShouldBehaveLikeABasicObjectExamples
            end
          end

          describe 'with a partial module name defined on the parent' do
            let(:description) { 'ShouldBehaveLikeABasicObject' }

            it 'should return the matching definition from the parent' do
              expect(described_class.find_deferred_examples(description))
                .to be ancestor_class::ShouldBehaveLikeABasicObjectExamples
            end
          end

          describe 'with an equivalent module name defined on the parent' do
            let(:description) { 'should behave like a BasicObject' }

            it 'should return the matching definition from the parent' do
              expect(described_class.find_deferred_examples(description))
                .to be ancestor_class::ShouldBehaveLikeABasicObjectExamples
            end
          end
        end

        context 'when the registry has deferred examples' do
          include_context 'when the registry has deferred examples'

          describe 'with an invalid String' do
            let(:description) { 'should do nothing' }
            let(:error_class) do
              namespace = RSpec::SleepingKingStudios::Deferred::Registry

              namespace::DeferredExamplesNotFoundError
            end
            let(:error_message) do
              'deferred examples not found with description ' \
                "#{description.to_s.inspect}"
            end

            it 'should raise an exception' do
              expect { described_class.find_deferred_examples(description) }
                .to raise_error error_class, error_message
            end
          end

          describe 'with an invalid Symbol' do
            let(:description) { :should_do_nothing }
            let(:error_class) do
              namespace = RSpec::SleepingKingStudios::Deferred::Registry

              namespace::DeferredExamplesNotFoundError
            end
            let(:error_message) do
              'deferred examples not found with description ' \
                "#{description.to_s.inspect}"
            end

            it 'should raise an exception' do
              expect { described_class.find_deferred_examples(description) }
                .to raise_error error_class, error_message
            end
          end

          describe 'with examples defined on the registry as a String' do
            let(:description) { 'should do something' }

            it 'should return the matching definition from the registry' do
              expect(described_class.find_deferred_examples(description))
                .to be expected_deferred_examples[description.to_s]
            end
          end

          describe 'with examples defined on the registry as a Symbol' do
            let(:description) { :'should do something' }

            it 'should return the matching definition from the registry' do
              expect(described_class.find_deferred_examples(description))
                .to be expected_deferred_examples[description.to_s]
            end
          end

          describe 'with an exact module name defined on the registry' do
            let(:description) { 'ShouldBehaveLikeAComplexObjectExamples' }

            it 'should return the matching definition from the parent' do
              expect(described_class.find_deferred_examples(description))
                .to be described_class::ShouldBehaveLikeAComplexObjectExamples
            end
          end

          describe 'with a partial module name defined on the registry' do
            let(:description) { 'ShouldBehaveLikeAComplexObject' }

            it 'should return the matching definition from the parent' do
              expect(described_class.find_deferred_examples(description))
                .to be described_class::ShouldBehaveLikeAComplexObjectExamples
            end
          end

          describe 'with an equivalent module name defined on the registry' do
            let(:description) { 'should behave like a complex object' }

            it 'should return the matching definition from the parent' do
              expect(described_class.find_deferred_examples(description))
                .to be described_class::ShouldBehaveLikeAComplexObjectExamples
            end
          end
        end

        context 'when the registry and parent have deferred examples' do
          include_context 'when the parent registry has deferred examples'
          include_context 'when the registry has deferred examples'

          describe 'with an invalid String' do
            let(:description) { 'should do nothing' }
            let(:error_class) do
              namespace = RSpec::SleepingKingStudios::Deferred::Registry

              namespace::DeferredExamplesNotFoundError
            end
            let(:error_message) do
              'deferred examples not found with description ' \
                "#{description.to_s.inspect}"
            end

            it 'should raise an exception' do
              expect { described_class.find_deferred_examples(description) }
                .to raise_error error_class, error_message
            end
          end

          describe 'with an invalid Symbol' do
            let(:description) { :should_do_nothing }
            let(:error_class) do
              namespace = RSpec::SleepingKingStudios::Deferred::Registry

              namespace::DeferredExamplesNotFoundError
            end
            let(:error_message) do
              'deferred examples not found with description ' \
                "#{description.to_s.inspect}"
            end

            it 'should raise an exception' do
              expect { described_class.find_deferred_examples(description) }
                .to raise_error error_class, error_message
            end
          end

          describe 'with examples defined on the parent as a String' do
            let(:description) { 'should do a thing' }

            it 'should return the matching definition from the parent' do
              expect(described_class.find_deferred_examples(description))
                .to be ancestor_deferred_examples[description.to_s]
            end
          end

          describe 'with examples defined on the parent as a Symbol' do
            let(:description) { :'should do a thing' }

            it 'should return the matching definition from the parent' do
              expect(described_class.find_deferred_examples(description))
                .to be ancestor_deferred_examples[description.to_s]
            end
          end

          describe 'with examples defined on the registry as a String' do
            let(:description) { 'should do something' }

            it 'should return the matching definition from the registry' do
              expect(described_class.find_deferred_examples(description))
                .to be expected_deferred_examples[description.to_s]
            end
          end

          describe 'with examples defined on the registry as a Symbol' do
            let(:description) { :'should do something' }

            it 'should return the matching definition from the registry' do
              expect(described_class.find_deferred_examples(description))
                .to be expected_deferred_examples[description.to_s]
            end
          end

          describe 'with ambiguous examples as a String' do
            let(:description) { 'should do something else' }

            it 'should return the matching definition from the registry' do
              expect(described_class.find_deferred_examples(description))
                .to be expected_deferred_examples[description.to_s]
            end
          end

          describe 'with ambiguous examples as a Symbol' do
            let(:description) { :'should do something else' }

            it 'should return the matching definition from the registry' do
              expect(described_class.find_deferred_examples(description))
                .to be expected_deferred_examples[description.to_s]
            end
          end

          describe 'with an exact module name defined on the parent' do
            let(:description) { 'ShouldBehaveLikeABasicObjectExamples' }

            it 'should return the matching definition from the parent' do
              expect(described_class.find_deferred_examples(description))
                .to be ancestor_class::ShouldBehaveLikeABasicObjectExamples
            end
          end

          describe 'with a partial module name defined on the parent' do
            let(:description) { 'ShouldBehaveLikeABasicObject' }

            it 'should return the matching definition from the parent' do
              expect(described_class.find_deferred_examples(description))
                .to be ancestor_class::ShouldBehaveLikeABasicObjectExamples
            end
          end

          describe 'with an equivalent module name defined on the parent' do
            let(:description) { 'should behave like a BasicObject' }

            it 'should return the matching definition from the parent' do
              expect(described_class.find_deferred_examples(description))
                .to be ancestor_class::ShouldBehaveLikeABasicObjectExamples
            end
          end

          describe 'with an exact module name defined on the registry' do
            let(:description) { 'ShouldBehaveLikeAComplexObjectExamples' }

            it 'should return the matching definition from the parent' do
              expect(described_class.find_deferred_examples(description))
                .to be described_class::ShouldBehaveLikeAComplexObjectExamples
            end
          end

          describe 'with a partial module name defined on the registry' do
            let(:description) { 'ShouldBehaveLikeAComplexObject' }

            it 'should return the matching definition from the parent' do
              expect(described_class.find_deferred_examples(description))
                .to be described_class::ShouldBehaveLikeAComplexObjectExamples
            end
          end

          describe 'with an equivalent module name defined on the registry' do
            let(:description) { 'should behave like a complex object' }

            it 'should return the matching definition from the parent' do
              expect(described_class.find_deferred_examples(description))
                .to be described_class::ShouldBehaveLikeAComplexObjectExamples
            end
          end

          describe 'with a module name defined on the parent and registry' do
            let(:description) { 'ShouldBehaveLikeAnObject' }

            it 'should return the matching definition from the parent' do
              expect(described_class.find_deferred_examples(description))
                .to be described_class::ShouldBehaveLikeAnObjectExamples
            end
          end

          describe 'with a module name overriding examples on parent' do
            let(:description) { 'ShouldActAsExpected' }

            it 'should return the matching definition from the parent' do
              expect(described_class.find_deferred_examples(description))
                .to be described_class::ShouldActAsExpectedExamples
            end
          end
        end
      end
    end
  end
end
