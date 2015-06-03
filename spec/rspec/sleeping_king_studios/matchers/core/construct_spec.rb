# spec/rspec/sleeping_king_studios/matchers/core/construct_spec.rb

require 'rspec/sleeping_king_studios/spec_helper'
require 'rspec/sleeping_king_studios/examples/rspec_matcher_examples'
require 'rspec/sleeping_king_studios/matchers/built_in/respond_to'

require 'rspec/sleeping_king_studios/matchers/core/construct'

describe RSpec::SleepingKingStudios::Matchers::Core::ConstructMatcher do
  include RSpec::SleepingKingStudios::Examples::RSpecMatcherExamples

  let(:example_group) { self }

  it { expect(example_group).to respond_to(:construct).with(0).arguments }
  it { expect(example_group.construct).to be_a described_class }

  it { expect(example_group).to respond_to(:be_constructible).with(0).arguments }
  it { expect(example_group.be_constructible).to be_a described_class }

  let(:instance) { described_class.new }

  describe '#with' do
    it { expect(instance).to respond_to(:with).with(0..2).arguments }

    it 'returns self' do
      expect(instance.with).to be instance
    end # it
  end # describe

  describe '#with_unlimited_arguments' do
    it { expect(instance).to respond_to(:with_unlimited_arguments).with(0).arguments }
    it { expect(instance.with_unlimited_arguments).to be instance }
  end # describe

  describe '#and_unlimited_arguments' do
    it { expect(instance).to respond_to(:and_unlimited_arguments).with(0).arguments }
    it { expect(instance.and_unlimited_arguments).to be instance }
  end # describe

  describe '#with_keywords' do
    it { expect(instance).to respond_to(:with_keywords).with(1..9001).arguments }
    it { expect(instance.with_keywords :foo).to be instance }
  end # describe

  describe '#and_keywords' do
    it { expect(instance).to respond_to(:and_keywords).with(1..9001).arguments }
    it { expect(instance.and_keywords :foo).to be instance }
  end # describe

  describe '#with_arbitrary_keywords' do
    it { expect(instance).to respond_to(:with_arbitrary_keywords).with(0).arguments }
    it { expect(instance.with_arbitrary_keywords).to be instance }
  end # describe

  describe '#and_arbitrary_keywords' do
    it { expect(instance).to respond_to(:and_arbitrary_keywords).with(0).arguments }
    it { expect(instance.and_arbitrary_keywords).to be instance }
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
      Evaluates to false with should message "to be constructible".
    When there is a ::new method,
      And there are no argument bounds,
        Evaluates to true with should_not message "not to be constructible".
      And there is a set of arguments,
        And the ::new method accepts that set of arguments,
          Evaluates to true with should_not message "not to be constructible with (count) arguments".
        And the ::new method requires more or fewer regular arguments,
          Evaluates to false with should message "to be constructible with (count) arguments".
      And the ruby version is 2.0.0 or higher,
        And there is a set of keywords,
          And the ::new method accepts that set of keywords,
            Evaluates to true with should_not message "not to be constructible with keywords".
          And the ::new method does not accept that set of arguments,
            Evaluates to false with should message "to be constructible with key keywords"
  SCENARIOS

  describe 'with no ::new method' do
    let(:failure_message) { "expected #{actual.inspect} to be constructible" }
    let(:actual) { Object.new }

    include_examples 'fails with a positive expectation'

    include_examples 'passes with a negative expectation'
  end # describe

  describe 'with a ::new method with no arguments' do
    let(:actual) { Class.new { def initialize; end } }

    describe 'with no arguments' do
      let(:failure_message_when_negated) { "expected #{actual.inspect} not to be constructible" }

      include_examples 'passes with a positive expectation'

      include_examples 'fails with a negative expectation'
    end # describe

    describe 'with too many arguments' do
      let(:failure_message) do
        "expected #{actual.inspect} to be constructible with arguments:\n  expected"\
        " at most 0 arguments, but received 1"
      end # let
      let(:instance) { super().with(1).arguments }

      include_examples 'fails with a positive expectation'

      include_examples 'passes with a negative expectation'
    end # describe
  end # describe

  describe 'with a ::new method with required arguments' do
    let(:actual) { Class.new { def initialize(a, b, c = nil); end } }

    describe 'with not enough arguments' do
      let(:failure_message) do
        "expected #{actual.inspect} to be constructible with arguments:\n  expected"\
        " at least 2 arguments, but received 1"
      end # let
      let(:instance) { super().with(1).argument }

      include_examples 'fails with a positive expectation'

      include_examples 'passes with a negative expectation'
    end # describe

    describe 'with a valid number of arguments' do
      let(:failure_message_when_negated) { "expected #{actual.inspect} not to be constructible with 3 arguments" }
      let(:instance) { super().with(3).arguments }

      include_examples 'passes with a positive expectation'

      include_examples 'fails with a negative expectation'
    end # describe

    describe 'with too many arguments' do
      let(:failure_message) do
        "expected #{actual.inspect} to be constructible with arguments:\n  expected"\
        " at most 3 arguments, but received 5"
      end # let
      let(:instance) { super().with(5).arguments }

      include_examples 'fails with a positive expectation'

      include_examples 'passes with a negative expectation'
    end # describe

    describe 'with unlimited arguments' do
      let(:failure_message) do
        "expected #{actual.inspect} to be constructible with arguments:\n  "\
        "expected at most 3 arguments, but received unlimited arguments"
      end # let
      let(:instance) { super().with_unlimited_arguments }

      include_examples 'fails with a positive expectation'

      include_examples 'passes with a negative expectation'
    end # describe
  end # describe

  describe 'with a ::new method with variadic arguments' do
    let(:actual) { Class.new { def initialize(a, b, c, *rest); end } }

    describe 'with not enough arguments' do
      let(:failure_message) do
        "expected #{actual.inspect} to be constructible with arguments:\n  expected"\
        " at least 3 arguments, but received 2"
      end # let
      let(:instance) { super().with(2).arguments }

      include_examples 'fails with a positive expectation'

      include_examples 'passes with a negative expectation'
    end # describe

    describe 'with an excessive number of arguments' do
      let(:failure_message_when_negated) { "expected #{actual.inspect} not to be constructible with 9001 arguments" }
      let(:instance) { super().with(9001).arguments }

      include_examples 'passes with a positive expectation'

      include_examples 'fails with a negative expectation'
    end # describe

    describe 'with unlimited arguments' do
      let(:failure_message_when_negated) do
        "expected #{actual.inspect} not to be constructible with unlimited arguments"
      end # let
      let(:instance) { super().with_unlimited_arguments }

      include_examples 'passes with a positive expectation'

      include_examples 'fails with a negative expectation'
    end # describe
  end # describe

  describe 'with a ::new method with keywords' do
    let(:actual) do
      Class.new.tap { |klass| klass.send :define_method, :initialize, lambda { |a: true, b: true| } }
    end # let

    describe 'with no keywords' do
      let(:failure_message_when_negated) { "expected #{actual.inspect} not to be constructible" }

      include_examples 'passes with a positive expectation'

      include_examples 'fails with a negative expectation'
    end # describe

    describe 'with valid keywords' do
      let(:failure_message_when_negated) do
        "expected #{actual.inspect} not to be constructible with 0 arguments and keywords :a and :b"
      end # let
      let(:instance) { super().with(0).arguments.and_keywords(:a, :b) }

      include_examples 'passes with a positive expectation'

      include_examples 'fails with a negative expectation'
    end # describe

    describe 'with valid keywords using the deprecated syntax' do
      let(:failure_message_when_negated) do
        "expected #{actual.inspect} not to be constructible with 0 arguments and keywords :a and :b"
      end # let
      let(:instance) { super().with(0, :a, :b) }

      include_examples 'passes with a positive expectation'

      include_examples 'fails with a negative expectation'
    end # describe

    describe 'with invalid keywords' do
      let(:failure_message) do
        "expected #{actual.inspect} to be constructible with arguments:"\
        "\n  unexpected keywords :c and :d"
      end # let
      let(:instance) { super().with(0).arguments.and_keywords(:c, :d) }

      include_examples 'fails with a positive expectation'

      include_examples 'passes with a negative expectation'
    end # describe

    describe 'with invalid keywords using the deprecated syntax' do
      let(:failure_message) do
        "expected #{actual.inspect} to be constructible with arguments:"\
        "\n  unexpected keywords :c and :d"
      end # let
      let(:instance) { super().with(0, :c, :d) }

      include_examples 'fails with a positive expectation'

      include_examples 'passes with a negative expectation'
    end # describe

    describe 'with arbitrary keywords' do
      let(:failure_message) do
        "expected #{actual.inspect} to be constructible with"\
        " arguments:\n  expected arbitrary keywords"
      end # let
      let(:instance) { super().with_arbitrary_keywords }

      include_examples 'fails with a positive expectation'

      include_examples 'passes with a negative expectation'
    end # describe
  end # describe

  describe 'with a ::new method with variadic keywords' do
    let(:actual) do
      Class.new.tap { |klass| klass.send :define_method, :initialize, lambda { |a: true, b: true, **params| } }
    end # let

    describe 'with no keywords' do
      let(:failure_message_when_negated) { "expected #{actual.inspect} not to be constructible" }

      include_examples 'passes with a positive expectation'

      include_examples 'fails with a negative expectation'
    end # describe

    describe 'with valid keywords' do
      let(:failure_message_when_negated) { "expected #{actual.inspect} not to be constructible with 0 arguments and keywords :a and :b" }
      let(:instance) { super().with(0).arguments.and_keywords(:a, :b) }

      include_examples 'passes with a positive expectation'

      include_examples 'fails with a negative expectation'
    end # describe

    describe 'with valid keywords using the deprecated syntax' do
      let(:failure_message_when_negated) { "expected #{actual.inspect} not to be constructible with 0 arguments and keywords :a and :b" }
      let(:instance) { super().with(0, :a, :b) }

      include_examples 'passes with a positive expectation'

      include_examples 'fails with a negative expectation'
    end # describe

    describe 'with random keywords' do
      let(:failure_message_when_negated) { "expected #{actual.inspect} not to be constructible with 0 arguments and keywords :c and :d" }
      let(:instance) { super().with(0).arguments.and_keywords(:c, :d) }

      include_examples 'passes with a positive expectation'

      include_examples 'fails with a negative expectation'
    end # describe

    describe 'with random keywords using the deprecated syntax' do
      let(:failure_message_when_negated) { "expected #{actual.inspect} not to be constructible with 0 arguments and keywords :c and :d" }
      let(:instance) { super().with(0, :c, :d) }

      include_examples 'passes with a positive expectation'

      include_examples 'fails with a negative expectation'
    end # describe

    describe 'with arbitrary keywords' do
      let(:failure_message_when_negated) do
        "expected #{actual.inspect} not to be constructible with"\
        " arbitrary keywords"
      end # let
      let(:instance) { super().with_arbitrary_keywords }

      include_examples 'passes with a positive expectation'

      include_examples 'fails with a negative expectation'
    end # describe
  end # describe

  if RUBY_VERSION >= "2.1.0"
    describe 'with a ::new method with keywords' do
      let(:actual) do
        # class-eval hackery to avoid syntax errors on pre-2.0.0 systems
        Class.new.tap { |klass| klass.send :class_eval, %Q(klass.send :define_method, :initialize, lambda { |a: true, b: true, c:, d:| }) }
      end # let

      describe 'with no keywords' do
        let(:failure_message_when_negated) { "expected #{actual.inspect} not to be constructible" }

        include_examples 'passes with a positive expectation'

        include_examples 'fails with a negative expectation'
      end # describe

      describe 'with missing keywords' do
        let(:failure_message) do
          "expected #{actual.inspect} to be constructible with arguments:"\
          "\n  missing keywords :c and :d"
        end # let
        let(:instance) { super().with(0).arguments.and_keywords(:a, :b) }

        include_examples 'fails with a positive expectation'

        include_examples 'passes with a negative expectation'
      end # describe

      describe 'with missing keywords using the deprecated syntax' do
        let(:failure_message) do
          "expected #{actual.inspect} to be constructible with arguments:"\
          "\n  missing keywords :c and :d"
        end # let
        let(:instance) { super().with(0, :a, :b) }

        include_examples 'fails with a positive expectation'

        include_examples 'passes with a negative expectation'
      end # describe

      describe 'with valid keywords' do
        let(:failure_message_when_negated) do
          "expected #{actual.inspect} not to be constructible with 0 arguments and keywords :a, :b, :c, and :d"
        end # let
        let(:instance) { super().with(0).arguments.and_keywords(:a, :b, :c, :d) }

        include_examples 'passes with a positive expectation'

        include_examples 'fails with a negative expectation'
      end # describe

      describe 'with valid keywords using the deprecated syntax' do
        let(:failure_message_when_negated) do
          "expected #{actual.inspect} not to be constructible with 0 arguments and keywords :a, :b, :c, and :d"
        end # let
        let(:instance) { super().with(0, :a, :b, :c, :d) }

        include_examples 'passes with a positive expectation'

        include_examples 'fails with a negative expectation'
      end # describe

      describe 'with invalid keywords' do
        let(:failure_message) do
          "expected #{actual.inspect} to be constructible with arguments:"\
          "\n  unexpected keywords :e and :f"
        end # let
        let(:instance) { super().with_keywords(:c, :d, :e, :f) }

        include_examples 'fails with a positive expectation'

        include_examples 'passes with a negative expectation'
      end # describe

      describe 'with invalid keywords using the deprecated syntax' do
        let(:failure_message) do
          "expected #{actual.inspect} to be constructible with arguments:"\
          "\n  unexpected keywords :e and :f"
        end # let
        let(:instance) { super().with(:c, :d, :e, :f) }

        include_examples 'fails with a positive expectation'

        include_examples 'passes with a negative expectation'
      end # describe

      describe 'with invalid and missing keywords' do
        let(:failure_message) do
          "expected #{actual.inspect} to be constructible with arguments:"\
          "\n  missing keywords :c and :d"\
          "\n  unexpected keywords :e and :f"
        end # let
        let(:instance) { super().with(0).arguments.and_keywords(:e, :f) }

        include_examples 'fails with a positive expectation'

        include_examples 'passes with a negative expectation'
      end # describe

      describe 'with invalid and missing keywords using the deprecated syntax' do
        let(:failure_message) do
          "expected #{actual.inspect} to be constructible with arguments:"\
          "\n  missing keywords :c and :d"\
          "\n  unexpected keywords :e and :f"
        end # let
        let(:instance) { super().with(0, :e, :f) }

        include_examples 'fails with a positive expectation'

        include_examples 'passes with a negative expectation'
      end # describe

      describe 'with arbitrary keywords' do
        let(:failure_message) do
          "expected #{actual.inspect} to be constructible with"\
          " arguments:\n  expected arbitrary keywords"
        end # let
        let(:instance) { super().with_keywords(:c, :d).and_arbitrary_keywords }

        include_examples 'fails with a positive expectation'

        include_examples 'passes with a negative expectation'
      end # describe
    end # describe

    describe 'with a ::new method with variadic keywords' do
      let(:actual) do
        # class-eval hackery to avoid syntax errors on pre-2.0.0 systems
        Class.new.tap { |klass| klass.send :class_eval, %Q(klass.send :define_method, :initialize, lambda { |a: true, b: true, c:, d:, **params| }) }
      end # let

      describe 'with no keywords' do
        let(:failure_message_when_negated) { "expected #{actual.inspect} not to be constructible" }

        include_examples 'passes with a positive expectation'

        include_examples 'fails with a negative expectation'
      end # describe

      describe 'with missing keywords' do
        let(:failure_message) do
          "expected #{actual.inspect} to be constructible with arguments:"\
          "\n  missing keywords :c and :d"
        end # let
        let(:instance) { super().with(0).arguments.and_keywords(:a, :b) }

        include_examples 'fails with a positive expectation'

        include_examples 'passes with a negative expectation'
      end # describe

      describe 'with missing keywords using the deprecated syntax' do
        let(:failure_message) do
          "expected #{actual.inspect} to be constructible with arguments:"\
          "\n  missing keywords :c and :d"
        end # let
        let(:instance) { super().with(0, :a, :b) }

        include_examples 'fails with a positive expectation'

        include_examples 'passes with a negative expectation'
      end # describe

      describe 'with valid keywords' do
        let(:failure_message_when_negated) do
          "expected #{actual.inspect} not to be constructible with 0 arguments and keywords :a, :b, :c, and :d"
        end # let
        let(:instance) { super().with(0).arguments.and_keywords(:a, :b, :c, :d) }

        include_examples 'passes with a positive expectation'

        include_examples 'fails with a negative expectation'
      end # describe

      describe 'with valid keywords using the deprecated syntax' do
        let(:failure_message_when_negated) do
          "expected #{actual.inspect} not to be constructible with 0 arguments and keywords :a, :b, :c, and :d"
        end # let
        let(:instance) { super().with(0, :a, :b, :c, :d) }

        include_examples 'passes with a positive expectation'

        include_examples 'fails with a negative expectation'
      end # describe

      describe 'with random keywords' do
        let(:failure_message_when_negated) do
          "expected #{actual.inspect} not to be constructible with 0 arguments and keywords :a, :b, :c, :d, :e, and :f"
        end # let
        let(:instance) { super().with(0).arguments.and_keywords(:a, :b, :c, :d, :e, :f) }

        include_examples 'passes with a positive expectation'

        include_examples 'fails with a negative expectation'
      end # describe

      describe 'with random keywords using the deprecated syntax' do
        let(:failure_message_when_negated) do
          "expected #{actual.inspect} not to be constructible with 0 arguments and keywords :a, :b, :c, :d, :e, and :f"
        end # let
        let(:instance) { super().with(0, :a, :b, :c, :d, :e, :f) }

        include_examples 'passes with a positive expectation'

        include_examples 'fails with a negative expectation'
      end # describe

      describe 'with arbitrary keywords' do
        let(:failure_message_when_negated) do
          "expected #{actual.inspect} not to be constructible with"\
          " keywords :c and :d and arbitrary keywords"
        end # let
        let(:instance) { super().with_keywords(:c, :d).and_arbitrary_keywords }

        include_examples 'passes with a positive expectation'

        include_examples 'fails with a negative expectation'
      end # describe
    end # describe
  end # if
end # describe
