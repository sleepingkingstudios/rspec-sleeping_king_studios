# spec/rspec/sleeping_king_studios/matchers/description_spec.rb

require 'spec_helper'

require 'rspec/sleeping_king_studios/matchers/description'

RSpec.describe RSpec::SleepingKingStudios::Matchers::Description do
  let(:concern)  { RSpec::SleepingKingStudios::Matchers::Description }
  let(:described_class) do
    klass = Class.new do
      def self.name
        'DescribeMatcher'
      end # class method name
    end # class
    klass.send :include, concern
    klass
  end # let
  let(:instance) { described_class.new }

  describe '#description' do
    it { expect(instance).to respond_to(:description).with(0).arguments }

    it { expect(instance.description).to be == 'describe' }

    context 'with one expected item' do
      let(:described_class) do
        super().tap do |klass|
          klass.class_eval do
            def initialize expected
              @expected = expected
            end # method initialize
          end # instance_eval
        end # tap
      end # let
      let(:expected) { :foo }
      let(:instance) { described_class.new expected }

      it { expect(instance.description).to be == 'describe :foo' }
    end # context

    context 'with many expected items' do
      let(:described_class) do
        super().tap do |klass|
          klass.class_eval do
            def initialize expected
              @expected = expected
            end # method initialize
          end # instance_eval
        end # tap
      end # let
      let(:expected)    { [:foo, :bar, :baz] }
      let(:instance)    { described_class.new expected }
      let(:description) { 'describe :foo, :bar, and :baz' }

      it { expect(instance.description).to be == description }
    end # context

    context 'with a custom class name' do
      before(:each) do
        allow(described_class).to receive(:name).
          and_return 'MyGem::MyModule::BeSillyMatcher'
      end # before each

      it { expect(instance.description).to be == 'be silly' }
    end # context
  end # describe
end # describe
