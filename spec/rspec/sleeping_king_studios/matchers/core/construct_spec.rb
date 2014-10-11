# spec/rspec/sleeping_king_studios/matchers/core/construct_spec.rb

require 'rspec/sleeping_king_studios/spec_helper'
require 'rspec/sleeping_king_studios/matchers/base_matcher_helpers'
require 'rspec/sleeping_king_studios/matchers/built_in/respond_to'

require 'rspec/sleeping_king_studios/matchers/core/construct'

describe RSpec::SleepingKingStudios::Matchers::Core::ConstructMatcher do
  let(:example_group) { self }
  
  it { expect(example_group).to respond_to(:construct).with(0).arguments }
  it { expect(example_group.construct).to be_a described_class }

  let(:instance) { described_class.new }

  describe '#with' do
    it { expect(instance).to respond_to(:with).with(0..2).arguments }

    it 'returns self' do
      expect(instance.with).to be instance
    end # it
  end # describe

  describe '#argument' do
    it { expect(instance).to respond_to(:argument).with(0).arguments }

    it 'returns self' do
      expect(instance.argument).to be instance
    end # if
  end # describe

  describe '#arguments' do
    it { expect(instance).to respond_to(:arguments).with(0).arguments }

    it 'returns self' do
      expect(instance.arguments).to be instance
    end # if
  end # describe

  <<-SCENARIOS
    When there is not a ::new method,
      Evaluates to false with should message "to construct".
    When there is a ::new method,
      And there are no argument bounds,
        Evaluates to true with should_not message "not to construct".
      And there is a set of arguments,
        And the ::new method accepts that set of arguments,
          Evaluates to true with should_not message "not to construct with (count) arguments".
        And the ::new method requires more or fewer regular arguments,
          Evaluates to false with should message "to construct with (count) arguments".
      And the ruby version is 2.0.0 or higher,
        And there is a set of keywords,
          And the ::new method accepts that set of keywords,
            Evaluates to true with should_not message "not to construct with keywords".
          And the ::new method does not accept that set of arguments,
            Evaluates to false with should message "to construct with key keywords"
  SCENARIOS

  describe 'with no ::new method' do
    let(:actual) { Object.new }

    it { expect(instance).to fail_with_actual(actual).
      with_message "expected #{actual.inspect} to construct" }
  end # describe

  describe 'with a ::new method with no arguments' do
    let(:actual) { Class.new { def initialize; end } }

    it 'with no arguments' do
      expect(instance).to pass_with_actual(actual).
        with_message "expected #{actual.inspect} not to construct"
    end # it

    it 'with too many arguments' do
      failure_message = "expected #{actual.inspect} to construct with arguments:\n" +
        "  expected at most 0 arguments, but received 1"
      expect(instance.with(1).arguments).to fail_with_actual(actual).
        with_message failure_message
    end # it
  end # describe

  describe 'with a ::new method with required arguments' do
    let(:actual) { Class.new { def initialize(a, b, c = nil); end } }

    it 'with not enough arguments' do
      failure_message = "expected #{actual.inspect} to construct with arguments:\n" +
        "  expected at least 2 arguments, but received 1"
      expect(instance.with(1).arguments).to fail_with_actual(actual).
        with_message failure_message
    end # it

    it 'with enough arguments' do
      expect(instance.with(3).arguments).to pass_with_actual(actual).
        with_message "expected #{actual} not to construct with 3 arguments"
    end # it

    it 'with too many arguments' do
      failure_message = "expected #{actual.inspect} to construct with arguments:\n" +
        "  expected at most 3 arguments, but received 5"
      expect(instance.with(5).arguments).to fail_with_actual(actual).
        with_message failure_message
    end # it
  end # describe

  describe 'with a ::new method with variadic arguments' do
    let(:actual) { Class.new { def initialize(a, b, c, *rest); end } }

    it 'with not enough arguments' do
      failure_message = "expected #{actual.inspect} to construct with arguments:\n" +
        "  expected at least 3 arguments, but received 2"
      expect(instance.with(2).arguments).to fail_with_actual(actual).
        with_message failure_message
    end # it

    it 'with an excessive number of arguments' do
      expect(instance.with(9001).arguments).to pass_with_actual(actual).
        with_message "expected #{actual} not to construct with 9001 arguments"
    end # it
  end # describe

  describe 'with a ::new method with keywords' do
    let(:actual) do
      # class-eval hackery to avoid syntax errors on pre-2.0.0 systems
      Class.new.tap { |klass| klass.send :class_eval, %Q(klass.send :define_method, :initialize, lambda { |a: true, b: true| }) }
    end # let

    it 'with no keywords' do
      expect(instance).to pass_with_actual(actual).
        with_message "expected #{actual} not to construct"
    end # it

    it 'with valid keywords' do
      expect(instance.with(0, :a, :b)).to pass_with_actual(actual).
        with_message "expected #{actual} not to construct with 0 arguments and keywords :a, :b"
    end # it

    it 'with invalid keywords' do
      failure_message = "expected #{actual.inspect} to construct with arguments:\n" +
        "  unexpected keywords :c, :d"
      expect(instance.with(0, :c, :d)).to fail_with_actual(actual).
        with_message failure_message
    end # it
  end # describe

  describe 'with a matching method with variadic keywords' do
    let(:actual) do
      # class-eval hackery to avoid syntax errors on pre-2.0.0 systems
      Class.new.tap { |klass| klass.send :class_eval, %Q(klass.send :define_method, :initialize, lambda { |a: true, b: true, **params| }) }
    end # let

    it 'with no keywords' do
      expect(instance).to pass_with_actual(actual).
        with_message "expected #{actual} not to construct"
    end # it

    it 'with valid keywords' do
      expect(instance.with(0, :a, :b)).to pass_with_actual(actual).
        with_message "expected #{actual} not to construct with 0 arguments and keywords :a, :b"
    end # it

    it 'with random keywords' do
      expect(instance.with(0, :c, :d)).to pass_with_actual(actual).
        with_message "expected #{actual} not to construct with 0 arguments and keywords :c, :d"
    end # it
  end # describe

  if RUBY_VERSION >= "2.1.0"
    describe 'with a ::new method with keywords' do
      let(:actual) do
        # class-eval hackery to avoid syntax errors on pre-2.0.0 systems
        Class.new.tap { |klass| klass.send :class_eval, %Q(klass.send :define_method, :initialize, lambda { |a: true, b: true, c:, d:| }) }
      end # let

      it 'with no keywords' do
        expect(instance).to pass_with_actual(actual).
          with_message "expected #{actual} not to construct"
      end # it

      it 'with missing keywords' do
        failure_message = "expected #{actual.inspect} to construct with arguments:\n" +
          "  missing keywords :c, :d"
        expect(instance.with(0, :a, :b)).to fail_with_actual(actual).
          with_message failure_message
      end # it

      it 'with valid keywords' do
        expect(instance.with(0, :a, :b, :c, :d)).to pass_with_actual(actual).
          with_message "expected #{actual} not to construct with 0 arguments and keywords :a, :b, :c, :d"
      end # it

      it 'with invalid keywords' do
        failure_message = "expected #{actual.inspect} to construct with arguments:\n" +
          "  unexpected keywords :e, :f"
        expect(instance.with(0, :c, :d, :e, :f)).to fail_with_actual(actual).
          with_message failure_message
      end # it

      it 'with invalid and missing keywords' do
        failure_message = "expected #{actual.inspect} to construct with arguments:\n" +
          "  missing keywords :c, :d\n" +
          "  unexpected keywords :e, :f"
        expect(instance.with(0, :e, :f)).to fail_with_actual(actual).
          with_message failure_message
      end # it
    end # describe

    describe 'with a matching method with variadic keywords' do
      let(:actual) do
        # class-eval hackery to avoid syntax errors on pre-2.0.0 systems
        Class.new.tap { |klass| klass.send :class_eval, %Q(klass.send :define_method, :initialize, lambda { |a: true, b: true, c:, d:, **params| }) }
      end # let

      it 'with no keywords' do
        expect(instance).to pass_with_actual(actual).
          with_message "expected #{actual} not to construct"
      end # it

      it 'with missing keywords' do
        failure_message = "expected #{actual.inspect} to construct with arguments:\n" +
          "  missing keywords :c, :d"
        expect(instance.with(0, :a, :b)).to fail_with_actual(actual).
          with_message failure_message
      end # it

      it 'with valid keywords' do
        expect(instance.with(0, :a, :b, :c, :d)).to pass_with_actual(actual).
          with_message "expected #{actual} not to construct with 0 arguments and keywords :a, :b, :c, :d"
      end # it

      it 'with random keywords' do
        expect(instance.with(0, :a, :b, :c, :d, :e, :f)).to pass_with_actual(actual).
          with_message "expected #{actual} not to construct with 0 arguments and keywords :a, :b, :c, :d, :e, :f"
      end # it
    end # describe
  end # if
end # describe
