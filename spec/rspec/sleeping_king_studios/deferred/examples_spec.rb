# frozen_string_literal: true

require 'rspec/sleeping_king_studios/concerns/example_constants'
require 'rspec/sleeping_king_studios/deferred/examples'
require 'rspec/sleeping_king_studios/matchers/built_in/respond_to'

RSpec.describe RSpec::SleepingKingStudios::Deferred::Examples do
  extend RSpec::SleepingKingStudios::Concerns::ExampleConstants

  # rubocop:disable RSpec/ExpectActual, RSpec/IdenticalEqualityAssertion
  shared_context 'when there are deferred examples' do
    example_implementations = [
      -> { expect(nil).to be nil },
      -> { expect(Object.new.freeze).to be_a Object }
    ]

    let(:expected_examples) do
      [
        RSpec::SleepingKingStudios::Deferred::Example.new(
          :specify,
          'should be nil',
          &example_implementations[0]
        ),
        RSpec::SleepingKingStudios::Deferred::Example.new(
          :specify,
          'should be an Object',
          &example_implementations[1]
        )
      ]
    end

    before(:example) do
      described_class.specify(
        'should be nil',
        &example_implementations[0]
      )

      described_class.specify(
        'should be an Object',
        &example_implementations[1]
      )
    end
  end

  shared_context 'when there are deferred example groups' do
    example_group_implementations = [
      lambda do
        it { expect(false).to be false }

        it { expect(true).to be true }
      end
    ]

    let(:expected_example_groups) do
      [
        RSpec::SleepingKingStudios::Deferred::ExampleGroup.new(
          :example_group,
          'should be booleans',
          &example_group_implementations[0]
        )
      ]
    end

    before(:example) do
      described_class.example_group(
        'should be booleans',
        &example_group_implementations[0]
      )
    end
  end

  shared_context 'when there are deferred calls' do
    include_context 'when there are deferred examples'
    include_context 'when there are deferred example groups'
  end

  shared_context 'when there are inherited calls' do
    example_implementations = [
      lambda do
        it { expect([]).to be_a Array }

        it { expect({}).to be_a Hash }
      end,
      -> { expect('a string').to be_a String },
      -> { expect(:a_symbol).to be_a Symbol }
    ]

    let(:inherited_examples) do
      [
        RSpec::SleepingKingStudios::Deferred::Example.new(
          :specify,
          'should be a String',
          &example_implementations[1]
        ),
        RSpec::SleepingKingStudios::Deferred::Example.new(
          :specify,
          'should be a Symbol',
          &example_implementations[2]
        )
      ]
    end
    let(:inherited_example_groups) do
      [
        RSpec::SleepingKingStudios::Deferred::ExampleGroup.new(
          :example_group,
          'should be collections',
          &example_implementations[0]
        )
      ]
    end

    example_constant 'Spec::InheritedExamples' do
      Module.new do
        include RSpec::SleepingKingStudios::Deferred::Examples
      end
    end

    before(:example) do
      Spec::DeferredExamples.include(Spec::InheritedExamples)

      Spec::InheritedExamples.example_group(
        'should be collections',
        &example_implementations[0]
      )

      Spec::InheritedExamples.specify(
        'should be a String',
        &example_implementations[1]
      )

      Spec::InheritedExamples.specify(
        'should be a Symbol',
        &example_implementations[2]
      )
    end
  end
  # rubocop:enable RSpec/ExpectActual, RSpec/IdenticalEqualityAssertion

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
        .to change(described_class, :ordered_deferred_calls)
    end

    it 'should define a deferred example', :aggregate_failures do
      described_class.send(method_name, *arguments, **keywords, &block)

      deferred = described_class.send(:ordered_deferred_calls).last

      expect(deferred).to be_a(RSpec::SleepingKingStudios::Deferred::Example)
      expect(deferred.method_name).to be method_name
      expect(deferred.arguments).to be == arguments
      expect(deferred.keywords).to be == keywords
      expect(deferred.block).to be == block
    end

    context 'when the deferred examples are called' do
      let(:example_group) { instance_double(RSpec::Core::ExampleGroup) }

      it 'should call the deferred example' do
        described_class.send(method_name, *arguments, **keywords, &block)

        deferred = described_class.send(:ordered_deferred_calls).last

        allow(deferred).to receive(:call)

        described_class.call(example_group)

        expect(deferred).to have_received(:call).with(example_group)
      end
    end
  end

  shared_examples 'should define an example group macro' do |method_name|
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

    it 'should add a deferred example group to the class' do
      expect do
        described_class.send(method_name, *arguments, **keywords, &block)
      end
        .to change(described_class, :ordered_deferred_calls)
    end

    it 'should define a deferred example group', :aggregate_failures do
      described_class.send(method_name, *arguments, **keywords, &block)

      deferred =
        described_class.send(:ordered_deferred_calls).last

      expect(deferred)
        .to be_a(RSpec::SleepingKingStudios::Deferred::ExampleGroup)
      expect(deferred.method_name).to be method_name
      expect(deferred.arguments).to be == arguments
      expect(deferred.keywords).to be == keywords
      expect(deferred.block).to be == block
    end

    context 'when the deferred examples are called' do
      let(:example_group) { instance_double(RSpec::Core::ExampleGroup) }

      it 'should call the deferred example group' do
        described_class.send(method_name, *arguments, **keywords, &block)

        deferred = described_class.send(:ordered_deferred_calls).last

        allow(deferred).to receive(:call)

        described_class.call(example_group)

        expect(deferred).to have_received(:call).with(example_group)
      end
    end
  end

  let(:described_class) { Spec::DeferredExamples }

  example_constant 'Spec::DeferredExamples' do
    Module.new do
      include RSpec::SleepingKingStudios::Deferred::Examples
    end
  end

  describe '.call' do
    shared_examples 'should call the deferred calls' do
      let(:deferred_calls) do
        described_class.send(:ordered_deferred_calls)
      end
      let(:example_group) do
        instance_double(RSpec::Core::ExampleGroup)
      end

      before(:example) do
        deferred_calls.each { |deferred| allow(deferred).to receive(:call) }
      end

      it 'should call the deferred calls in order' do
        described_class.call(example_group)

        expect(deferred_calls).to all have_received(:call).with(example_group)
      end
    end

    it 'should define the class method' do
      expect(described_class).to respond_to(:call).with(1).argument
    end

    context 'when there are deferred examples' do
      include_context 'when there are deferred examples'

      include_examples 'should call the deferred calls'
    end

    context 'when there are deferred example groups' do
      include_context 'when there are deferred example groups'

      include_examples 'should call the deferred calls'
    end

    context 'when there are deferred calls' do
      include_context 'when there are deferred calls'

      include_examples 'should call the deferred calls'
    end
  end

  describe '.context' do
    include_examples 'should define an example group macro', :context
  end

  describe '.describe' do
    include_examples 'should define an example group macro', :describe
  end

  describe '.example' do
    include_examples 'should define an example macro', :example
  end

  describe '.example_group' do
    include_examples 'should define an example group macro', :example_group
  end

  describe '.fcontext' do
    include_examples 'should define an example group macro', :fcontext
  end

  describe '.fdescribe' do
    include_examples 'should define an example group macro', :fdescribe
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

  describe '.included' do
    shared_examples 'should call the deferred calls' do
      let(:deferred_calls) do
        described_class.send(:ordered_deferred_calls)
      end
      let(:example_group) do
        Class.new(RSpec::Core::ExampleGroup)
      end

      before(:example) do
        deferred_calls.each { |deferred| allow(deferred).to receive(:call) }
      end

      it 'should call the deferred calls in order' do
        example_group.include(described_class)

        expect(deferred_calls).to all have_received(:call).with(example_group)
      end
    end

    context 'when there are deferred examples' do
      include_context 'when there are deferred examples'

      include_examples 'should call the deferred calls'
    end

    context 'when there are deferred example groups' do
      include_context 'when there are deferred example groups'

      include_examples 'should call the deferred calls'
    end

    context 'when there are deferred calls' do
      include_context 'when there are deferred calls'

      include_examples 'should call the deferred calls'
    end

    context 'when there are inherited calls' do
      include_context 'when there are inherited calls'

      include_examples 'should call the deferred calls'
    end

    context 'when there are deferred and inherited calls' do
      include_context 'when there are deferred calls'
      include_context 'when there are inherited calls'

      include_examples 'should call the deferred calls'
    end
  end

  describe '.it' do
    include_examples 'should define an example macro', :it
  end

  describe '.ordered_deferred_calls' do
    let(:expected) { [] }

    it 'should define the private class reader' do
      expect(described_class)
        .to respond_to(:ordered_deferred_calls, true)
        .with(0).arguments
    end

    it 'should not define any deferred calls' do
      expect(described_class.send(:ordered_deferred_calls)).to be == expected
    end

    context 'when there are deferred examples' do
      include_context 'when there are deferred examples'

      let(:expected) { expected_examples }

      it 'should define the deferred examples' do
        expect(described_class.send(:ordered_deferred_calls)).to be == expected
      end
    end

    context 'when there are deferred example groups' do
      include_context 'when there are deferred example groups'

      let(:expected) { expected_example_groups }

      it 'should define the deferred example_groups' do
        expect(described_class.send(:ordered_deferred_calls)).to be == expected
      end
    end

    context 'when there are deferred calls' do
      include_context 'when there are deferred calls'

      let(:expected) do
        expected_examples + expected_example_groups
      end

      it 'should define the deferred calls' do
        expect(described_class.send(:ordered_deferred_calls)).to be == expected
      end
    end

    context 'when there are inherited calls' do
      include_context 'when there are inherited calls'

      let(:expected) do
        inherited_examples + inherited_example_groups
      end

      it 'should define the deferred calls' do
        expect(described_class.send(:ordered_deferred_calls)).to be == expected
      end
    end

    context 'when there are deferred and inherited calls' do
      include_context 'when there are deferred calls'
      include_context 'when there are inherited calls'

      let(:expected) do
        expected_examples +
          inherited_examples +
          expected_example_groups +
          inherited_example_groups
      end

      it 'should define the deferred calls' do
        expect(described_class.send(:ordered_deferred_calls)).to be == expected
      end
    end
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