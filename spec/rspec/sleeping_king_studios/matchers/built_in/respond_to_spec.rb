# spec/rspec/sleeping_king_studios/matchers/built_in/respond_to_spec.rb

require 'rspec/sleeping_king_studios/spec_helper'
require 'rspec/sleeping_king_studios/examples/rspec_matcher_examples'
require 'rspec/sleeping_king_studios/matchers/core/construct'

require 'rspec/sleeping_king_studios/matchers/built_in/respond_to'

describe RSpec::SleepingKingStudios::Matchers::BuiltIn::RespondToMatcher do
  include RSpec::SleepingKingStudios::Examples::RSpecMatcherExamples

  it { expect(described_class).to construct.with(1..9001).arguments }

  let(:example_group) { self }
  let(:identifier)    { :foo }

  # Paging Douglas Hofstadter, or possibly Xzibit...
  it { expect(example_group).to respond_to(:respond_to).with(1..9001).arguments }
  it { expect(example_group.respond_to identifier).to be_a described_class }

  let(:instance) { described_class.new identifier }

  describe "#with" do
    it { expect(instance).to respond_to(:with).with(0..2).arguments }
    it { expect(instance.with).to be instance }
  end # describe

  describe "#with_a_block" do
    it { expect(instance).to respond_to(:with_a_block).with(0).arguments }
    it { expect(instance.with_a_block).to be instance }
  end # describe

  describe '#and_a_block' do
    it { expect(instance).to respond_to(:and_a_block).with(0).arguments }
    it { expect(instance.and_a_block).to be instance }
  end # describe

  <<-SCENARIOS
    When there is no matching method,
      Evaluates to false with should message "to respond to".
    When there is a matching method,
      And there are no argument bounds,
        Evaluates to true with should_not message "not to respond to".
      And there is a set of arguments,
        And the method accepts that set of arguments,
          Evaluates to true with should_not message "not to respond to with (count) arguments".
        And the method requires more or fewer regular arguments,
          Evaluates to false with should message "to respond to with (count) arguments".
      And the ruby version is 2.0.0 or higher,
        And there is a set of keywords,
          And the method accepts that set of keywords,
            Evaluates to true with should_not message "not to respond to with keywords".
          And the method does not accept that set of arguments,
            Evaluates to false with should message "to respond to with key keywords"
      And there is a block provided,
        And the method expects a block,
          Evaluates to true with should_not message "not to respond to with a block".
        And the method does not expect a block,
          Evaluates to false with should message "to respond_to with a block".
  SCENARIOS

  describe 'with no matching method' do
    let(:failure_message) { "expected #{actual.inspect} to respond to #{identifier.inspect}" }
    let(:actual) { Object.new }

    include_examples 'fails with a positive expectation'

    include_examples 'passes with a negative expectation'
  end # describe

  describe 'with a matching method with no arguments' do
    let(:actual) do
      Class.new.tap { |klass| klass.send :define_method, identifier, lambda {} }.new
    end # let

    describe 'with zero arguments expected' do
      let(:failure_message_when_negated) { "expected #{actual} not to respond to :#{identifier} with 0 arguments" }
      let(:instance) { super().with(0).arguments }

      include_examples 'passes with a positive expectation'

      include_examples 'fails with a negative expectation'
    end # describe

    describe 'with too many arguments expected' do
      let(:failure_message) do
        "expected #{actual.inspect} to respond to #{identifier.inspect} with"\
        " arguments:\n  expected at most 0 arguments, but received 1"
      end # let
      let(:instance) { super().with(1).arguments }

      include_examples 'fails with a positive expectation'

      include_examples 'passes with a negative expectation'
    end # describe

    describe 'with a block' do
      let(:failure_message) do
        "expected #{actual.inspect} to respond to #{identifier.inspect} with"\
        " arguments:\n  unexpected block"
      end # let
      let(:instance) { super().with_a_block }

      include_examples 'fails with a positive expectation'

      include_examples 'passes with a negative expectation'
    end # describe
  end # describe

  describe 'with a matching method with required arguments' do
    let(:actual) do
      Class.new.tap { |klass| klass.send :define_method, identifier, lambda { |a, b, c = nil| } }.new
    end # let

    describe 'with not enough arguments' do
      let(:failure_message) do
        "expected #{actual.inspect} to respond to #{identifier.inspect} with"\
        " arguments:\n  expected at least 2 arguments, but received 1"
      end # let
      let(:instance) { super().with(1).arguments }

      include_examples 'fails with a positive expectation'

      include_examples 'passes with a negative expectation'
    end # describe

    describe 'with a valid number of arguments' do
      let(:failure_message_when_negated) do
        "expected #{actual} not to respond to :#{identifier} with 3 arguments"
      end # let
      let(:instance) { super().with(3).arguments }

      include_examples 'passes with a positive expectation'

      include_examples 'fails with a negative expectation'
    end # describe

    describe 'with too many arguments' do
      let(:failure_message) do
        "expected #{actual.inspect} to respond to #{identifier.inspect} with"\
        " arguments:\n  expected at most 3 arguments, but received 5"
      end # let
      let(:instance) { super().with(5).arguments }

      include_examples 'fails with a positive expectation'

      include_examples 'passes with a negative expectation'
    end # describe
  end # describe

  describe 'with a matching method with variadic arguments' do
    let(:actual) do
      Class.new.tap { |klass| klass.send :define_method, identifier, lambda { |a, b, c, *rest| } }.new
    end # let

    describe 'with not enough arguments' do
      let(:failure_message) do
        "expected #{actual.inspect} to respond to #{identifier.inspect} with"\
        " arguments:\n  expected at least 3 arguments, but received 2"
      end # let
      let(:instance) { super().with(2).arguments }

      include_examples 'fails with a positive expectation'

      include_examples 'passes with a negative expectation'
    end # describe

    describe 'with an excessive number of arguments' do
      let(:failure_message_when_negated) do
        "expected #{actual} not to respond to :#{identifier} with 9001 arguments"
      end # let
      let(:instance) { super().with(9001).arguments }

      include_examples 'passes with a positive expectation'

      include_examples 'fails with a negative expectation'
    end # describe
  end # describe

  describe 'with a matching method with keywords' do
    let(:actual) do
      Class.new.tap { |klass| klass.send :define_method, identifier, lambda { |a: true, b: true| } }.new
    end # let

    describe 'with no keywords' do
      let(:failure_message_when_negated) do
        "expected #{actual} not to respond to :#{identifier}"
      end # let

      include_examples 'passes with a positive expectation'

      include_examples 'fails with a negative expectation'
    end # describe

    describe 'with valid keywords' do
      let(:failure_message_when_negated) do
        "expected #{actual} not to respond to :#{identifier} with 0 arguments and keywords :a and :b"
      end # let
      let(:instance) { super().with(0, :a, :b) }

      include_examples 'passes with a positive expectation'

      include_examples 'fails with a negative expectation'
    end # describe

    describe 'with invalid keywords' do
      let(:failure_message) do
        "expected #{actual.inspect} to respond to #{identifier.inspect} with"\
        " arguments:\n  unexpected keywords :c and :d"
      end # let
      let(:instance) { super().with(0, :c, :d) }

      include_examples 'fails with a positive expectation'

      include_examples 'passes with a negative expectation'
    end # describe

    describe 'with valid keywords and unspecified arguments' do
      let(:failure_message_when_negated) do
        "expected #{actual} not to respond to :#{identifier} with keywords :a and :b"
      end # let
      let(:instance) { super().with(:a, :b) }

      include_examples 'passes with a positive expectation'

      include_examples 'fails with a negative expectation'
    end # describe

    describe 'with invalid keywords and unspecified arguments' do
      let(:failure_message) do
        "expected #{actual.inspect} to respond to #{identifier.inspect} with"\
        " arguments:\n  unexpected keywords :c and :d"
      end # let
      let(:instance) { super().with(:c, :d) }

      include_examples 'fails with a positive expectation'

      include_examples 'passes with a negative expectation'
    end # describe
  end # describe

  describe 'with a matching method with variadic keywords' do
    let(:actual) do
      Class.new.tap { |klass| klass.send :define_method, identifier, lambda { |a: true, b: true, **params| } }.new
    end # let

    describe 'with no keywords' do
      let(:failure_message_when_negated) do
        "expected #{actual} not to respond to :#{identifier}"
      end # let

      include_examples 'passes with a positive expectation'

      include_examples 'fails with a negative expectation'
    end # describe

    describe 'with valid keywords' do
      let(:failure_message_when_negated) do
        "expected #{actual} not to respond to :#{identifier} with 0 arguments and keywords :a and :b"
      end # let
      let(:instance) { super().with(0, :a, :b) }

      include_examples 'passes with a positive expectation'

      include_examples 'fails with a negative expectation'
    end # describe

    describe 'with random keywords' do
      let(:failure_message_when_negated) do
        "expected #{actual} not to respond to :#{identifier} with 0 arguments and keywords :c and :d"
      end # let
      let(:instance) { super().with(0, :c, :d) }

      include_examples 'passes with a positive expectation'

      include_examples 'fails with a negative expectation'
    end # describe
  end # describe

  describe 'with a matching method that expects a block' do
    let(:actual) do
      Class.new.tap { |klass| klass.send :define_method, identifier, lambda { |&block| yield } }.new
    end # let

    describe 'with no block' do
      let(:failure_message_when_negated) do
        "expected #{actual} not to respond to :#{identifier}"
      end # let

      include_examples 'passes with a positive expectation'

      include_examples 'fails with a negative expectation'
    end # describe

    describe 'with a block' do
      let(:failure_message_when_negated) do
        "expected #{actual} not to respond to :#{identifier} with a block"
      end # let
      let(:instance) { super().with_a_block }

      include_examples 'passes with a positive expectation'

      include_examples 'fails with a negative expectation'
    end # describe
  end # describe

  describe 'with a matching private method with no arguments' do
    let(:failure_message) { "expected #{actual.inspect} to respond to #{identifier.inspect}" }
    let(:actual) do
      Class.new.tap do |klass|
        klass.send :define_method, identifier, lambda {}
        klass.send :private, identifier
      end.new
    end # let

    include_examples 'fails with a positive expectation'

    include_examples 'passes with a negative expectation'

    describe 'with include_all => true' do
      let(:instance) { described_class.new identifier, true }

      describe 'with zero arguments expected' do
        let(:failure_message_when_negated) { "expected #{actual} not to respond to :#{identifier} with 0 arguments" }
        let(:instance) { super().with(0).arguments }

        include_examples 'passes with a positive expectation'

        include_examples 'fails with a negative expectation'
      end # describe

      describe 'with too many arguments expected' do
        let(:failure_message) do
          "expected #{actual.inspect} to respond to #{identifier.inspect} with"\
          " arguments:\n  expected at most 0 arguments, but received 1"
        end # let
        let(:instance) { super().with(1).arguments }

        include_examples 'fails with a positive expectation'

        include_examples 'passes with a negative expectation'
      end # describe

      describe 'with a block' do
        let(:failure_message) do
          "expected #{actual.inspect} to respond to #{identifier.inspect} with"\
          " arguments:\n  unexpected block"
        end # let
        let(:instance) { super().with_a_block }

        include_examples 'fails with a positive expectation'

        include_examples 'passes with a negative expectation'
      end # describe
    end # describe
  end # describe

  if RUBY_VERSION >= "2.1.0"
    describe 'with a matching method with optional and required keywords' do
      let(:actual) do
        # class-eval hackery to avoid syntax errors on pre-2.1.0 systems
        Class.new.tap { |klass| klass.send :class_eval, %Q(klass.send :define_method, :#{identifier}, lambda { |a: true, b: true, c:, d:| }) }.new
      end # let

      describe 'with no keywords' do
        let(:failure_message_when_negated) do
          "expected #{actual} not to respond to :#{identifier}"
        end # let

        include_examples 'passes with a positive expectation'

        include_examples 'fails with a negative expectation'
      end # describe

      describe 'with missing keywords' do
        let(:failure_message) do
          "expected #{actual} to respond to :#{identifier} with arguments:"\
          "\n  missing keywords :c and :d"
        end # let
        let(:instance) { super().with(0, :a, :b) }

        include_examples 'fails with a positive expectation'

        include_examples 'passes with a negative expectation'
      end # describe

      describe 'with valid keywords' do
        let(:failure_message_when_negated) do
          "expected #{actual} not to respond to :#{identifier} with 0 arguments"\
          " and keywords :a, :b, :c, and :d"
        end # let
        let(:instance) { super().with(0, :a, :b, :c, :d) }

        # include_examples 'passes with a positive expectation'

        include_examples 'fails with a negative expectation'
      end # describe

      describe 'with invalid keywords' do
        let(:failure_message) do
          "expected #{actual.inspect} to respond to #{identifier.inspect} with"\
          " arguments:\n  unexpected keywords :e and :f"
        end # let
        let(:instance) { super().with(0, :c, :d, :e, :f) }

        include_examples 'fails with a positive expectation'

        include_examples 'passes with a negative expectation'
      end # describe

      describe 'with invalid and missing keywords' do
        let(:failure_message) do
          "expected #{actual.inspect} to respond to #{identifier.inspect} with"\
          " arguments:\n  missing keywords :c and :d\n  unexpected keywords :e and :f"
        end # let
        let(:instance) { super().with(0, :e, :f) }

        include_examples 'fails with a positive expectation'

        include_examples 'passes with a negative expectation'
      end # describe

      describe 'with valid keywords and unspecified arguments' do
        let(:failure_message_when_negated) do
          "expected #{actual} not to respond to :#{identifier} with keywords"\
          " :a, :b, :c, and :d"
        end # let
        let(:instance) { super().with(:a, :b, :c, :d) }

        include_examples 'passes with a positive expectation'

        include_examples 'fails with a negative expectation'
      end # describe

      describe 'with missing keywords and unspecified arguments' do
        let(:failure_message) do
          "expected #{actual.inspect} to respond to #{identifier.inspect} with"\
          " arguments:\n  missing keywords :c and :d"
        end # let
        let(:instance) { super().with(:a, :b) }

        include_examples 'fails with a positive expectation'

        include_examples 'passes with a negative expectation'
      end # describe

      describe 'with invalid keywords and unspecified arguments' do
        let(:failure_message) do
          "expected #{actual.inspect} to respond to #{identifier.inspect} with"\
          " arguments:\n  unexpected keywords :e and :f"
        end # let
        let(:instance) { super().with(:c, :d, :e, :f) }

        include_examples 'fails with a positive expectation'

        include_examples 'passes with a negative expectation'
      end # describe

      describe 'with invalid and missing keywords and unspecified arguments' do
        let(:failure_message) do
          "expected #{actual.inspect} to respond to #{identifier.inspect} with"\
          " arguments:\n  missing keywords :c and :d\n  unexpected keywords :e and :f"
        end # let
        let(:instance) { super().with(:e, :f) }

        include_examples 'fails with a positive expectation'

        include_examples 'passes with a negative expectation'
      end # describe
    end # describe

    describe 'with a matching method with variadic keywords' do
      let(:actual) do
        # class-eval hackery to avoid syntax errors on pre-2.1.0 systems
        Class.new.tap { |klass| klass.send :class_eval, %Q(klass.send :define_method, :#{identifier}, lambda { |a: true, b: true, c:, d:, **params| }) }.new
      end # let

      describe 'with no keywords' do
        let(:failure_message_when_negated) do
          "expected #{actual} not to respond to :#{identifier}"
        end # let

        include_examples 'passes with a positive expectation'

        include_examples 'fails with a negative expectation'
      end # describe

      describe 'with missing keywords' do
        let(:failure_message) do
          "expected #{actual} to respond to :#{identifier} with arguments:"\
          "\n  missing keywords :c and :d"
        end # let
        let(:instance) { super().with(0, :a, :b) }

        include_examples 'fails with a positive expectation'

        include_examples 'passes with a negative expectation'
      end # describe

      describe 'with valid keywords' do
        let(:failure_message_when_negated) do
          "expected #{actual} not to respond to :#{identifier} with 0"\
          " arguments and keywords :a, :b, :c, and :d"
        end # let
        let(:instance) { super().with(0, :a, :b, :c, :d) }

        include_examples 'passes with a positive expectation'

        include_examples 'fails with a negative expectation'
      end # describe

      describe 'with random keywords' do
        let(:failure_message_when_negated) do
          "expected #{actual} not to respond to :#{identifier} with 0"\
          " arguments and keywords :c, :d, :e, and :f"
        end # let
        let(:instance) { super().with(0, :c, :d, :e, :f) }

        include_examples 'passes with a positive expectation'

        include_examples 'fails with a negative expectation'
      end # describe
    end # describe
  end # if
end # describe
