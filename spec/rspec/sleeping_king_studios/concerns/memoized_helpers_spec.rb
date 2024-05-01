# frozen_string_literal: true

require 'rspec/sleeping_king_studios/concerns/example_constants'
require 'rspec/sleeping_king_studios/concerns/memoized_helpers'
require 'rspec/sleeping_king_studios/matchers/built_in/respond_to'

RSpec.describe RSpec::SleepingKingStudios::Concerns::MemoizedHelpers do
  extend RSpec::SleepingKingStudios::Concerns::ExampleConstants

  subject(:example_group) { described_class.new }

  let(:described_class) { Spec::ExampleGroup }

  describe '#let?' do
    shared_examples 'should not define the memoized helper' do
      it 'should return the helper name' do
        expect(described_class.let?(helper_name) { nil }).to be == helper_name
      end

      it 'should not delegate to .let' do
        allow(described_class).to receive(:let)

        described_class.let?(helper_name)

        expect(described_class).not_to have_received(:let)
      end

      it 'should return the previously defined value' do
        define_helper

        3.times do
          expect(example_group.send(helper_name)).to be(-1)
        end
      end
    end

    let(:helper_name) { :helper_method }
    let(:enumerator) do
      Enumerator.new do |yielder|
        value = 0

        loop do
          yielder << value

          value += 1
        end
      end
    end

    def define_helper
      enum = enumerator

      described_class.let?(helper_name) { enum.next }
    end

    example_class 'Spec::ParentGroup', RSpec::Core::ExampleGroup do |klass|
      klass.extend RSpec::SleepingKingStudios::Concerns::MemoizedHelpers # rubocop:disable RSpec/DescribedClass

      RSpec::Core::MemoizedHelpers.define_helpers_on(klass)
    end

    example_class 'Spec::ExampleGroup', 'Spec::ParentGroup' do |klass|
      RSpec::Core::MemoizedHelpers.define_helpers_on(klass)
    end

    it 'should define the class method' do
      expect(described_class)
        .to respond_to(:let?)
        .with(1).argument
        .and_a_block
    end

    context 'when there is not an existing method' do
      it 'should return the helper name' do
        expect(described_class.let?(helper_name) { nil }).to be == helper_name
      end

      it 'should delegate to .let' do
        allow(described_class).to receive(:let)

        described_class.let?(helper_name)

        expect(described_class).to have_received(:let).with(helper_name)
      end

      it 'should define the helper' do
        define_helper

        expect(example_group).to respond_to(helper_name).with(0).arguments
      end

      it 'should memoize the value', :aggregate_failures do
        define_helper

        3.times do
          expect(example_group.send(helper_name)).to be 0
        end
      end
    end

    context 'when there is an existing method' do
      before(:example) do
        Spec::ExampleGroup.define_method(helper_name) { -1 }
      end

      include_examples 'should not define the memoized helper'
    end

    context 'when there is an existing method on an ancestor' do
      before(:example) do
        Spec::ParentGroup.define_method(helper_name) { -1 }
      end

      include_examples 'should not define the memoized helper'
    end

    context 'when there is an existing helper' do
      before(:example) do
        Spec::ExampleGroup.instance_eval do
          let(:helper_method) { -1 }
        end
      end

      include_examples 'should not define the memoized helper'
    end

    context 'when there is an existing helper on an ancestor' do
      before(:example) do
        Spec::ParentGroup.instance_eval do
          let(:helper_method) { -1 }
        end
      end

      include_examples 'should not define the memoized helper'
    end

    context 'when there is an existing optional helper' do
      before(:example) do
        Spec::ExampleGroup.instance_eval do
          let?(:helper_method) { -1 }
        end
      end

      include_examples 'should not define the memoized helper'
    end

    context 'when there is an existing optional helper on an ancestor' do
      before(:example) do
        Spec::ParentGroup.instance_eval do
          let?(:helper_method) { -1 }
        end
      end

      include_examples 'should not define the memoized helper'
    end
  end
end
