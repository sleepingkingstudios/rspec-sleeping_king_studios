# frozen_string_literal: true

require 'rspec/sleeping_king_studios/concerns/shared_example_group'

require 'support/shared_examples'

module Spec::Support::SharedExamples
  module DeferredRegistryExamples
    extend RSpec::SleepingKingStudios::Concerns::SharedExampleGroup

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
          ancestor_class.deferred_examples(description, &block)
        end

        ancestor_class.const_set(
          :ShouldBehaveLikeABasicObjectExamples,
          Module.new do
            include RSpec::SleepingKingStudios::Deferred::Examples

            self.description = 'should behave like a BasicObject'
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
          described_class.deferred_examples(description, &block)
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

    shared_examples 'should define a registry for deferred examples' do
      describe '.deferred_examples' do
        let(:description) { 'should do something' }
        let(:block)       { -> {} }

        it 'should define the class method' do
          expect(described_class)
            .to respond_to(:deferred_examples)
            .with(1).argument
            .and_a_block
        end

        describe 'with block: nil' do
          let(:error_message) do
            'block is required'
          end

          it 'should raise an exception' do
            expect { described_class.deferred_examples(description) }
              .to raise_error ArgumentError, error_message
          end
        end

        describe 'with description: nil' do
          let(:error_message) do
            "description can't be blank"
          end

          it 'should raise an exception' do
            expect { described_class.deferred_examples(nil, &block) }
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
              described_class.deferred_examples(description, &block)
            end
              .to raise_error ArgumentError, error_message
          end
        end

        describe 'with description: an empty String' do
          let(:error_message) do
            "description can't be blank"
          end

          it 'should raise an exception' do
            expect { described_class.deferred_examples('', &block) }
              .to raise_error ArgumentError, error_message
          end
        end

        describe 'with description: an empty Symbol' do
          let(:error_message) do
            "description can't be blank"
          end

          it 'should raise an exception' do
            expect { described_class.deferred_examples(:'', &block) }
              .to raise_error ArgumentError, error_message
          end
        end

        describe 'with description: a String' do
          it 'should add the definition to the deferred examples' do
            described_class.deferred_examples(description, &block)

            expect(
              described_class.defined_deferred_examples.fetch(description)
            )
              .to be block
          end
        end

        describe 'with description: a Symbol' do
          let(:description) { :should_do_something }

          it 'should add the definition to the deferred examples' do
            described_class.deferred_examples(description, &block)

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

        describe 'with an empty Symbol' do
          let(:error_message) do
            "description can't be blank"
          end

          it 'should raise an exception' do
            expect { described_class.find_deferred_examples(:'') }
              .to raise_error ArgumentError, error_message
          end
        end

        describe 'with an invalid String' do
          let(:description) { 'should do nothing' }
          let(:error_class) do
            namespace = RSpec::SleepingKingStudios::Deferred::Provider

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
            namespace = RSpec::SleepingKingStudios::Deferred::Provider

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
              namespace = RSpec::SleepingKingStudios::Deferred::Provider

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
              namespace = RSpec::SleepingKingStudios::Deferred::Provider

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

          describe 'with the description of a module defined on the parent' do
            let(:description) { 'should behave like a BasicObject' }

            it 'should return the matching definition from the parent' do
              expect(described_class.find_deferred_examples(description))
                .to be ancestor_class::ShouldBehaveLikeABasicObjectExamples
            end
          end

          describe 'with a module that is shadowed on the child' do
            let(:description) { 'should behave like a BasicObject' }

            before(:example) do
              included_examples = Module.new do
                include RSpec::SleepingKingStudios::Deferred::Examples

                self.description = description
              end

              described_class.const_set(
                :ShouldBehaveLikeABasicObjectExamples,
                Class.new do
                  include(included_examples)

                  define_singleton_method :description do
                    'should behave like a BasicObject'
                  end
                end
              )
            end

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
              namespace = RSpec::SleepingKingStudios::Deferred::Provider

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
              namespace = RSpec::SleepingKingStudios::Deferred::Provider

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

          describe 'with the description of a module defined on the registry' do
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
              namespace = RSpec::SleepingKingStudios::Deferred::Provider

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
              namespace = RSpec::SleepingKingStudios::Deferred::Provider

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

          describe 'with the description of a module defined on the parent' do
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

          describe 'with the description of a module defined on the registry' do
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

    shared_examples 'should implement including deferred examples' do
      shared_examples 'should wrap the deferred examples' \
      do |example_group_method:, example_group_name:, method_name:|
        let(:description) { 'should do something' }
        let(:child_example_group) do
          Spec::Support.isolated_example_group do
            include RSpec::SleepingKingStudios::Deferred::Consumer
          end
        end

        before(:example) do
          allow(described_class).to receive(example_group_method) do |_, &block|
            child_example_group.instance_exec(&block)
          end

          allow(child_example_group).to receive(:include_deferred)
        end

        it 'should wrap the deferred examples in a focused example group',
          :aggregate_failures \
        do
          described_class.public_send(method_name, description)

          expect(described_class)
            .to have_received(example_group_method)
            .with(example_group_name.gsub(':description', description))
          expect(child_example_group)
            .to have_received(:include_deferred)
            .with(description)
        end
      end

      describe '.finclude_deferred' do
        it 'should define the class method' do
          expect(described_class)
            .to respond_to(:finclude_deferred)
            .with(1).argument
            .and_unlimited_arguments
            .and_any_keywords
            .and_a_block
        end

        include_examples 'should wrap the deferred examples',
          example_group_method: :fdescribe,
          example_group_name:   '(focused)',
          method_name:          :finclude_deferred
      end

      describe '.fwrap_deferred' do
        it 'should define the class method' do
          expect(described_class)
            .to respond_to(:fwrap_deferred)
            .with(1).argument
            .and_unlimited_arguments
            .and_any_keywords
            .and_a_block
        end

        include_examples 'should wrap the deferred examples',
          example_group_method: :fdescribe,
          example_group_name:   '(focused) :description',
          method_name:          :fwrap_deferred
      end

      describe '.include_deferred' do
        let(:description) { 'should do something' }
        let(:deferred_module) do
          described_class.ancestors.find do |ancestor|
            next false unless ancestor.is_a?(Module)

            unless ancestor < RSpec::SleepingKingStudios::Deferred::Examples
              next false
            end

            ancestor.respond_to?(:description) &&
              ancestor.description == description
          end
        end

        it 'should define the class method' do
          expect(described_class)
            .to respond_to(:include_deferred)
            .with(1).argument
            .and_unlimited_arguments
            .and_any_keywords
            .and_a_block
        end

        describe 'with nil' do
          let(:error_message) do
            "description can't be blank"
          end

          it 'should raise an exception' do
            expect { described_class.include_deferred(nil) }
              .to raise_error ArgumentError, error_message
          end
        end

        describe 'with an Object' do
          let(:error_message) do
            'description is not a String or a Symbol'
          end

          it 'should raise an exception' do
            expect { described_class.include_deferred(Object.new.freeze) }
              .to raise_error ArgumentError, error_message
          end
        end

        describe 'with an empty String' do
          let(:error_message) do
            "description can't be blank"
          end

          it 'should raise an exception' do
            expect { described_class.include_deferred('') }
              .to raise_error ArgumentError, error_message
          end
        end

        describe 'with an empty Symbol' do
          let(:error_message) do
            "description can't be blank"
          end

          it 'should raise an exception' do
            expect { described_class.include_deferred(:'') }
              .to raise_error ArgumentError, error_message
          end
        end

        describe 'with an invalid String' do
          let(:description) { 'should do nothing' }
          let(:error_class) do
            namespace = RSpec::SleepingKingStudios::Deferred::Provider

            namespace::DeferredExamplesNotFoundError
          end
          let(:error_message) do
            'deferred examples not found with description ' \
              "#{description.to_s.inspect}"
          end

          it 'should raise an exception' do
            expect { described_class.include_deferred(description) }
              .to raise_error error_class, error_message
          end
        end

        describe 'with an invalid Symbol' do
          let(:description) { :should_do_nothing }
          let(:error_class) do
            namespace = RSpec::SleepingKingStudios::Deferred::Provider

            namespace::DeferredExamplesNotFoundError
          end
          let(:error_message) do
            'deferred examples not found with description ' \
              "#{description.to_s.inspect}"
          end

          it 'should raise an exception' do
            expect { described_class.include_deferred(description) }
              .to raise_error error_class, error_message
          end
        end

        describe 'with a module name defined on the registry' do
          before(:example) do
            described_class.const_set(
              :ShouldDoSomething,
              Module.new do
                include RSpec::SleepingKingStudios::Deferred::Examples

                define_singleton_method(:deferred_parameters) { [] }
              end
            )
          end

          it 'should include the deferred examples', :aggregate_failures do
            described_class.include_deferred(description)

            expect(deferred_module).to be_a Module
            expect(deferred_module.deferred_parameters).to be == []
          end
        end

        describe 'with defined examples with no parameters' do
          let(:implementation) do
            -> { define_singleton_method(:deferred_parameters) { [] } }
          end

          before(:example) do
            described_class.deferred_examples(description, &implementation)
          end

          it 'should include the deferred examples', :aggregate_failures do
            described_class.include_deferred(description)

            expect(deferred_module).to be_a Module
            expect(deferred_module.deferred_parameters).to be == []
          end
        end

        describe 'with defined examples with parameters' do
          let(:implementation) do
            lambda do |*args, **kwargs, &block|
              define_singleton_method(:deferred_parameters) do
                [args, kwargs, block]
              end
            end
          end

          before(:example) do
            described_class.deferred_examples(description, &implementation)
          end

          it 'should include the deferred examples', :aggregate_failures do
            described_class.include_deferred(description)

            expect(deferred_module).to be_a Module
            expect(deferred_module.deferred_parameters).to be == [[], {}, nil]
          end

          describe 'with parameters' do
            let(:arguments) { %i[ichi ni san] }
            let(:keywords)  { { option: 'value' } }
            let(:block)     { -> { { ok: true } } }
            let(:expected_parameters) do
              [arguments, keywords, block]
            end

            it 'should include the deferred examples' do
              described_class.include_deferred(
                description,
                *arguments,
                **keywords,
                &block
              )

              expect(deferred_module.deferred_parameters)
                .to be == expected_parameters
            end
          end
        end
      end

      describe '.wrap_deferred' do
        it 'should define the class method' do
          expect(described_class)
            .to respond_to(:wrap_deferred)
            .with(1).argument
            .and_unlimited_arguments
            .and_any_keywords
            .and_a_block
        end

        include_examples 'should wrap the deferred examples',
          example_group_method: :describe,
          example_group_name:   ':description',
          method_name:          :wrap_deferred
      end

      describe '.xinclude_deferred' do
        it 'should define the class method' do
          expect(described_class)
            .to respond_to(:xinclude_deferred)
            .with(1).argument
            .and_unlimited_arguments
            .and_any_keywords
            .and_a_block
        end

        include_examples 'should wrap the deferred examples',
          example_group_method: :xdescribe,
          example_group_name:   '(skipped)',
          method_name:          :xinclude_deferred
      end

      describe '.xwrap_deferred' do
        it 'should define the class method' do
          expect(described_class)
            .to respond_to(:xwrap_deferred)
            .with(1).argument
            .and_unlimited_arguments
            .and_any_keywords
            .and_a_block
        end

        include_examples 'should wrap the deferred examples',
          example_group_method: :xdescribe,
          example_group_name:   '(skipped) :description',
          method_name:          :xwrap_deferred
      end
    end
  end
end
