require 'spec_helper'

require 'rspec/sleeping_king_studios/concerns/example_constants'
require 'rspec/sleeping_king_studios/matchers/built_in/respond_to'
require 'rspec/sleeping_king_studios/matchers/core/have_changed'

RSpec.describe RSpec::SleepingKingStudios::Matchers::Macros do
  extend RSpec::SleepingKingStudios::Concerns::ExampleConstants

  let(:matcher_class) do
    RSpec::SleepingKingStudios::Matchers::Core::HaveChangedMatcher
  end
  let(:example_group) { self }

  describe '#have_reader' do
    let(:matcher) { example_group.have_changed }

    it 'should define the macro' do
      expect(example_group).to respond_to(:have_changed).with(0).arguments
    end

    it { expect(matcher).to be_a matcher_class }
  end

  describe '#watch_value' do
    let(:spy_class) do
      RSpec::SleepingKingStudios::Support::ValueSpy
    end
    let(:spy)           { example_group.watch_value object, method_name }
    let(:method_name)   { :value }
    let(:initial_value) { 'initial value'.freeze }
    let(:object_class)  { Spec::CustomStruct }
    let(:object)        { object_class.new(initial_value) }

    example_constant 'Spec::CustomStruct' do
      Struct.new(method_name).tap do |struct|
        struct.send(:define_method, :to_s) { 'Spec::CustomStruct' }
      end
    end

    it 'should define the macro' do
      expect(example_group)
        .to respond_to(:watch_value)
        .with(0..2).arguments
        .and_a_block
    end

    it { expect(spy).to be_a spy_class }

    it { expect(spy.description).to be == "Spec::CustomStruct##{method_name}" }

    describe 'with a block' do
      let(:spy) { example_group.watch_value { object.value } }

      it { expect(spy).to be_a spy_class }

      it { expect(spy.description).to be == 'result' }
    end
  end
end
