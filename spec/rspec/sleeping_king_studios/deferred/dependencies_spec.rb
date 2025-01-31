# frozen_string_literal: true

require 'sleeping_king_studios/tools/toolbox/mixin'

require 'rspec/sleeping_king_studios/concerns/example_constants'
require 'rspec/sleeping_king_studios/deferred/consumer'
require 'rspec/sleeping_king_studios/deferred/dependencies'
require 'rspec/sleeping_king_studios/deferred/provider'

RSpec.describe RSpec::SleepingKingStudios::Deferred::Dependencies do
  extend  RSpec::SleepingKingStudios::Concerns::ExampleConstants
  include RSpec::SleepingKingStudios::Deferred::Provider

  deferred_examples 'deferred group requiring #launch' do
    include RSpec::SleepingKingStudios::Deferred::Dependencies # rubocop:disable RSpec/DescribedClass

    depends_on '#launch', 'method called to launch the rocket'
  end

  deferred_examples 'deferred group requiring :rocket' do
    include RSpec::SleepingKingStudios::Deferred::Dependencies # rubocop:disable RSpec/DescribedClass

    depends_on :rocket, 'an instance of Rocket where #launched? returns false'
  end

  deferred_examples 'deferred group with met dependencies' do
    include RSpec::SleepingKingStudios::Deferred::Dependencies # rubocop:disable RSpec/DescribedClass

    depends_on :described_class, 'the class being described'
  end

  deferred_examples 'deferred group with no dependencies' do
    include RSpec::SleepingKingStudios::Deferred::Dependencies # rubocop:disable RSpec/DescribedClass
  end

  let(:described_class) { Spec::DeferredExamples }
  let(:mixin_module)    { RSpec::SleepingKingStudios::Deferred::Dependencies } # rubocop:disable RSpec/DescribedClass

  example_class 'Spec::DeferredExamples' do |klass|
    klass.include RSpec::SleepingKingStudios::Deferred::Dependencies # rubocop:disable RSpec/DescribedClass
  end

  describe '::MissingDependenciesError' do
    it 'should define the constant' do
      expect(described_class::MissingDependenciesError)
        .to be_a(Class)
        .and(be < StandardError)
    end
  end

  describe '.call' do
    let(:example_group) do
      Class.new(self.class) do
        include RSpec::SleepingKingStudios::Deferred::Consumer

        @metadata = {}
      end
    end
    let(:example) { example_group.new }

    define_method :include_deferred do
      example_group.class_eval do
        include_deferred 'deferred group with no dependencies'
      end
    end

    before(:example) do
      allow(example_group).to receive(:before)
    end

    it 'should add a before(:context) hook' do
      include_deferred

      expect(example_group).to have_received(:before).with(:context)
    end

    it 'should #call check_dependencies_for' do
      allow(example_group).to receive(:before) do |_, &block|
        # Hooks are evaluated in an instance of the example group.
        example.instance_exec(&block)
      end
      allow(mixin_module).to receive(:check_dependencies_for)

      include_deferred

      expect(mixin_module)
        .to have_received(:check_dependencies_for)
        .with(example)
    end

    context 'when the example group already defines the hook' do
      let(:example_group) do
        super().class_eval do
          include_deferred 'deferred group with met dependencies'
        end
      end

      it 'should not add another before(:context) hook' do
        include_deferred

        expect(example_group).not_to have_received(:before).with(:context)
      end
    end
  end

  describe '.check_dependencies_for' do
    let(:example_group) do
      Class.new(self.class) do
        include RSpec::SleepingKingStudios::Deferred::Consumer

        @metadata = {}
      end
    end

    define_method(:check_dependencies) do
      mixin_module.check_dependencies_for(example_group.new)
    end

    it 'should define the class method' do
      expect(mixin_module)
        .to respond_to(:check_dependencies_for)
        .with(1).argument
    end

    it { expect { check_dependencies }.not_to raise_error }

    context 'when the example group includes deferred examples' do
      let(:example_group) do
        super().class_eval do
          include_deferred 'deferred group with no dependencies'
        end
      end

      it { expect { check_dependencies }.not_to raise_error }
    end

    context 'when the example group has met dependencies' do
      let(:example_group) do
        super().class_eval do
          include_deferred 'deferred group with met dependencies'
        end
      end

      it { expect { check_dependencies }.not_to raise_error }
    end

    context 'when the example group has unmet dependencies' do
      let(:example_group) do
        super().class_eval do
          include_deferred 'deferred group requiring #launch'
          include_deferred 'deferred group requiring :rocket'
        end
      end
      let(:error_class) { mixin_module::MissingDependenciesError }
      let(:expected) do
        <<~MESSAGE.strip
          Unable to run specs with deferred example groups because the following methods are not defined in the examples:

          Missing methods for "deferred group requiring :rocket":
            #rocket: an instance of Rocket where #launched? returns false

          Missing methods for "deferred group requiring #launch":
            #launch: method called to launch the rocket

          Please define the missing methods or :let helpers.
        MESSAGE
      end

      it 'should raise an exception' do
        expect { check_dependencies }.to raise_error(error_class, expected)
      end
    end
  end

  describe '.depends_on' do
    let(:description) { nil }
    let(:method_name) { :rocket }
    let(:expected) do
      {
        deferred_group: described_class,
        description:,
        method_name:
      }
    end

    define_method(:dependent_methods) do
      described_class.dependent_methods
    end

    it 'should define the class method' do
      expect(described_class)
        .to respond_to(:depends_on)
        .with(1..2).arguments
    end

    it { expect(described_class.depends_on method_name).to be nil }

    it 'should declare the dependency', :aggregate_failures do
      expect { described_class.depends_on(method_name) }
        .to change(dependent_methods, :count).by(1)

      expect(dependent_methods.last).to be == expected
    end

    describe 'with description: value' do
      let(:description) do
        'an instance of Rocket where #launched? returns false'
      end

      it 'should declare the dependency', :aggregate_failures do
        expect { described_class.depends_on(method_name, description) }
          .to change(dependent_methods, :count).by(1)

        expect(dependent_methods.last).to be == expected
      end
    end

    describe 'with method_name: a string' do
      let(:method_name) { 'rocket' }
      let(:expected)    { super().merge(method_name: :rocket) }

      it 'should declare the dependency', :aggregate_failures do
        expect { described_class.depends_on(method_name) }
          .to change(dependent_methods, :count).by(1)

        expect(dependent_methods.last).to be == expected
      end
    end

    describe 'with method_name: a string starting with "#"' do
      let(:method_name) { '#launch' }
      let(:expected)    { super().merge(method_name: :launch) }

      it 'should declare the dependency', :aggregate_failures do
        expect { described_class.depends_on(method_name) }
          .to change(dependent_methods, :count).by(1)

        expect(dependent_methods.last).to be == expected
      end
    end
  end

  describe '.dependent_methods' do
    it 'should define the class reader' do
      expect(described_class)
        .to respond_to(:dependent_methods)
        .with(0).arguments
    end

    it { expect(described_class.dependent_methods).to be == [] }
  end
end
