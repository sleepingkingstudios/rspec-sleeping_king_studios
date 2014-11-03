# spec/rspec/sleeping_king_studios/matchers/all_spec.rb

require 'rspec/sleeping_king_studios/spec_helper'
require 'rspec/sleeping_king_studios/matchers/all'

RSpec.describe RSpec::SleepingKingStudios::Matchers do
  describe '#be_boolean' do
    let(:passing_actual) { true }
    let(:failing_actual) { nil }

    it { expect(passing_actual).to be_boolean }

    it { expect(failing_actual).not_to be_boolean }
  end # describe

  describe '#be_kind_of Matcher' do
    let(:passing_actual) { "I'm a String!" }
    let(:failing_actual) { Object.new }

    describe 'with a single type' do
      it { expect(passing_actual).to be_a String }

      it { expect(failing_actual).not_to be_a String }
    end # describe

    describe 'with an array of types' do
      it { expect(passing_actual).to be_a [String, Array, nil] }

      it { expect(failing_actual).not_to be_a [String, Array, nil] }
    end # describe
  end # describe

  describe '#construct Matcher' do
    let(:passing_actual) do
      Class.new do
        def initialize a, b = nil; end
      end # class
    end # let
    let(:failing_actual) { Object.new }

    it { expect(passing_actual).to construct }

    it { expect(failing_actual).not_to construct }

    describe 'with an argument count' do
      it { expect(passing_actual).to construct.with(1).argument }

      it { expect(failing_actual).not_to construct.with(1).argument }
    end # describe

    describe 'with an argument range' do
      it { expect(passing_actual).to construct.with(1..2).arguments }

      it { expect(failing_actual).not_to construct.with(1..2).arguments }
    end # describe

    describe 'with keyword arguments' do
      let(:passing_actual) do
        Class.new do
          def initialize a, b = nil, c: nil, d: nil; end
        end # class
      end # let

      it { expect(passing_actual).to construct.with(:c, :d) }

      it { expect(failing_actual).not_to construct.with(:c, :d) }
    end # describe

    describe 'with mixed arguments' do
      let(:passing_actual) do
        Class.new do
          def initialize a, b = nil, c: nil, d: nil, &block; end
        end # class
      end # let

      it { expect(passing_actual).to construct.with(1..2, :c, :d) }
    end # describe
  end # describe

  describe '#have_errors Matcher' do
    let(:passing_actual) { FactoryGirl.build :active_model }
    let(:failing_actual) { FactoryGirl.build :active_model, :foo => '100110', :bar => 'The Fox And The Hound' }

    it { expect(passing_actual).to have_errors }

    it { expect(failing_actual).not_to have_errors }

    describe 'with an attribute' do
      let(:attribute) { :foo }

      it { expect(passing_actual).to have_errors.on(attribute) }

      it { expect(failing_actual).not_to have_errors.on(attribute) }

      describe 'with a message' do
        it { expect(passing_actual).to have_errors.on(attribute).with_message("not to be nil") }

        it { expect(failing_actual).not_to have_errors.on(attribute).with_message("not to be nil") }
      end # describe

      describe 'with multiple messages' do
        it { expect(passing_actual).to have_errors.on(attribute).with_messages("not to be nil", "to be 1s and 0s") }

        it { expect(failing_actual).not_to have_errors.on(attribute).with_messages("not to be nil", 'to be 1s and 0s') }
      end # describe
    end # describe
  end # describe

  describe '#have_property Matcher' do
    let(:passing_actual) { Struct.new(:foo).new('foo') }
    let(:failing_actual) { Object.new }

    it { expect(passing_actual).to have_property :foo }

    it { expect(failing_actual).not_to have_property :foo }

    describe 'with a value expectation' do
      it { expect(passing_actual).to have_property(:foo).with_value('foo') }

      it { expect(failing_actual).not_to have_property(:foo).with_value('foo') }
    end # describe
  end # describe

  describe '#include Matcher' do
    let(:passing_actual) { %w(foo bar baz) }
    let(:failing_actual) { %w() }

    describe 'with a value' do
      it { expect(passing_actual).to include 'foo' }

      it { expect(failing_actual).not_to include 'foo' }
    end # describe

    describe 'with a block' do
      it { expect(passing_actual).to include { |value| value.length == 3 } }

      it { expect(failing_actual).not_to include { |value| value.length == 3 } }
    end # describe
  end # describe

  describe '#respond_to Matcher' do
    let(:passing_actual) do
      Class.new do
        def foo a, b = nil; end
      end.new
    end # let
    let(:failing_actual) { Object.new }

    it { expect(passing_actual).to respond_to(:foo) }

    it { expect(failing_actual).not_to respond_to(:foo) }

    describe 'with an argument count' do
      it { expect(passing_actual).to respond_to(:foo).with(1).argument }

      it { expect(failing_actual).not_to respond_to(:foo).with(1).argument }
    end # describe

    describe 'with an argument range' do
      it { expect(passing_actual).to respond_to(:foo).with(1..2).arguments }

      it { expect(failing_actual).not_to respond_to(:foo).with(1..2).arguments }
    end # describe

    describe 'with keyword arguments' do
      let(:passing_actual) do
        Class.new do
          def foo a, b = nil, c: nil, d: nil; end
        end.new
      end # let

      it { expect(passing_actual).to respond_to(:foo).with(:c, :d) }

      it { expect(failing_actual).not_to respond_to(:foo).with(:c, :d) }
    end # describe

    describe 'with a block' do
      let(:passing_actual) do
        Class.new do
          def foo &block; end
        end.new
      end # let

      it { expect(passing_actual).to respond_to(:foo).with_a_block }

      it { expect(failing_actual).not_to respond_to(:foo).with_a_block }
    end # describe

    describe 'with mixed arguments' do
      let(:passing_actual) do
        Class.new do
          def foo a, b = nil, c: nil, d: nil, &block; end
        end.new
      end # let

      it { expect(passing_actual).to respond_to(:foo).with(1..2, :c, :d).with_a_block }
    end # describe
  end # describe
end # describe
