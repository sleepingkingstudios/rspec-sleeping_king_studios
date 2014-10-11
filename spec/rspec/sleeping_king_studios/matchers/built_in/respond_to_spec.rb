# spec/rspec/sleeping_king_studios/matchers/built_in/respond_to_spec.rb

require 'rspec/sleeping_king_studios/spec_helper'

require 'rspec/sleeping_king_studios/matchers/built_in/respond_to'

describe RSpec::SleepingKingStudios::Matchers::BuiltIn::RespondToMatcher do

  let(:example_group) { self }
  let(:identifier)    { :foo }
  
  # Paging Douglas Hofstadter, or possibly Xzibit...
  it { expect(example_group).to respond_to(:respond_to).with(1).arguments }
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
    let(:actual) { Object.new }

    it { expect(instance).to fail_with_actual(actual).
      with_message "expected #{actual.inspect} to respond to #{identifier.inspect}" }
  end # describe

  describe 'with a matching method with no arguments' do
    let(:actual) do
      Class.new.tap { |klass| klass.send :define_method, identifier, lambda {} }.new
    end # let

    it 'with no arguments' do
      expect(instance.with(0).arguments).to pass_with_actual(actual).
        with_message "expected #{actual} not to respond to :#{identifier} with 0 arguments"
    end # it

    it 'with too many arguments' do
      failure_message = "expected #{actual.inspect} to respond to " +
        "#{identifier.inspect} with arguments:\n" +
        "  expected at most 0 arguments, but received 1"
      expect(instance.with(1).arguments).to fail_with_actual(actual).
        with_message failure_message
    end # it

    it 'with a block' do
      failure_message = "expected #{actual.inspect} to respond to " +
        "#{identifier.inspect} with arguments:\n" +
        "  unexpected block"
      expect(instance.with_a_block).to fail_with_actual(actual).
        with_message failure_message
    end # it
  end # describe

  describe 'with a matching method with required arguments' do
    let(:actual) do
      Class.new.tap { |klass| klass.send :define_method, identifier, lambda { |a, b, c = nil| } }.new
    end # let

    it 'with not enough arguments' do
      failure_message = "expected #{actual.inspect} to respond to " +
        "#{identifier.inspect} with arguments:\n" +
        "  expected at least 2 arguments, but received 1"
      expect(instance.with(1).arguments).to fail_with_actual(actual).
        with_message failure_message
    end # it

    it 'with enough arguments' do
      expect(instance.with(3).arguments).to pass_with_actual(actual).
        with_message "expected #{actual} not to respond to :#{identifier} with 3 arguments"
    end # it

    it 'with too many arguments' do
      failure_message = "expected #{actual.inspect} to respond to " +
        "#{identifier.inspect} with arguments:\n" +
        "  expected at most 3 arguments, but received 5"
      expect(instance.with(5).arguments).to fail_with_actual(actual).
        with_message failure_message
    end # it
  end # describe

  describe 'with a matching method with variadic arguments' do
    let(:actual) do
      Class.new.tap { |klass| klass.send :define_method, identifier, lambda { |a, b, c, *rest| } }.new
    end # let

    it 'with not enough arguments' do
      failure_message = "expected #{actual.inspect} to respond to " +
        "#{identifier.inspect} with arguments:\n" +
        "  expected at least 3 arguments, but received 2"
      expect(instance.with(2).arguments).to fail_with_actual(actual).
        with_message failure_message
    end # it

    it 'with an excessive number of arguments' do
      expect(instance.with(9001).arguments).to pass_with_actual(actual).
        with_message "expected #{actual} not to respond to :#{identifier} with 9001 arguments"
    end # it
  end # describe

  describe 'with no matching method' do
    let(:actual) { Object.new }

    it { expect(instance).to fail_with_actual(actual).
      with_message "expected #{actual.inspect} to respond to #{identifier.inspect}" }
  end # describe
  
  describe 'with a matching method with keywords' do
    let(:actual) do
      # class-eval hackery to avoid syntax errors on pre-2.0.0 systems
      Class.new.tap { |klass| klass.send :class_eval, %Q(klass.send :define_method, :#{identifier}, lambda { |a: true, b: true| }) }.new
    end # let

    it 'with no keywords' do
      expect(instance).to pass_with_actual(actual).
        with_message "expected #{actual} not to respond to :#{identifier}"
    end # it

    it 'with valid keywords' do
      expect(instance.with(0, :a, :b)).to pass_with_actual(actual).
        with_message "expected #{actual} not to respond to :#{identifier} with 0 arguments and keywords :a, :b"
    end # it

    it 'with invalid keywords' do
      failure_message = "expected #{actual.inspect} to respond to " +
        "#{identifier.inspect} with arguments:\n" +
        "  unexpected keywords :c, :d"
      expect(instance.with(0, :c, :d)).to fail_with_actual(actual).
        with_message failure_message
    end # it

    it 'with valid keywords and unspecified arguments' do
      expect(instance.with(:a, :b)).to pass_with_actual(actual).
        with_message "expected #{actual} not to respond to :#{identifier} with keywords :a, :b"
    end # it

    it 'with invalid keywords and unspecified arguments' do
      failure_message = "expected #{actual.inspect} to respond to " +
        "#{identifier.inspect} with arguments:\n" +
        "  unexpected keywords :c, :d"
      expect(instance.with(:c, :d)).to fail_with_actual(actual).
        with_message failure_message
    end # it
  end # describe

  describe 'with a matching method with variadic keywords' do
    let(:actual) do
      # class-eval hackery to avoid syntax errors on pre-2.0.0 systems
      Class.new.tap { |klass| klass.send :class_eval, %Q(klass.send :define_method, :#{identifier}, lambda { |a: true, b: true, **params| }) }.new
    end # let

    it 'with no keywords' do
      expect(instance).to pass_with_actual(actual).
        with_message "expected #{actual} not to respond to :#{identifier}"
    end # it

    it 'with valid keywords' do
      expect(instance.with(0, :a, :b)).to pass_with_actual(actual).
        with_message "expected #{actual} not to respond to :#{identifier} with 0 arguments and keywords :a, :b"
    end # it

    it 'with random keywords' do
      expect(instance.with(0, :c, :d)).to pass_with_actual(actual).
        with_message "expected #{actual} not to respond to :#{identifier} with 0 arguments and keywords :c, :d"
    end # it
  end # describe

  if RUBY_VERSION >= "2.1.0"
    describe 'with no matching method' do
      let(:actual) { Object.new }

      it { expect(instance).to fail_with_actual(actual).
        with_message "expected #{actual.inspect} to respond to #{identifier.inspect}" }
    end # describe

    describe 'with a matching method with optional and required keywords' do
      let(:actual) do
        # class-eval hackery to avoid syntax errors on pre-2.1.0 systems
        Class.new.tap { |klass| klass.send :class_eval, %Q(klass.send :define_method, :#{identifier}, lambda { |a: true, b: true, c:, d:| }) }.new
      end # let

      it 'with no keywords' do
        expect(instance).to pass_with_actual(actual).
          with_message "expected #{actual} not to respond to :#{identifier}"
      end # it

      it 'with missing keywords' do
        failure_message = "expected #{actual} to respond to :#{identifier} " +
          "with arguments:\n  missing keywords :c, :d"
        expect(instance.with(0, :a, :b)).to fail_with_actual(actual).
          with_message failure_message
      end # it

      it 'with valid keywords' do
        expect(instance.with(0, :a, :b, :c, :d)).to pass_with_actual(actual).
          with_message "expected #{actual} not to respond to :#{identifier} with 0 arguments and keywords :a, :b, :c, :d"
      end # it

      it 'with invalid keywords' do
        failure_message = "expected #{actual.inspect} to respond to " +
          "#{identifier.inspect} with arguments:\n" +
          "  unexpected keywords :e, :f"
        expect(instance.with(0, :c, :d, :e, :f)).to fail_with_actual(actual).
          with_message failure_message
      end # it

      it 'with invalid and missing keywords' do
        failure_message = "expected #{actual.inspect} to respond to " +
          "#{identifier.inspect} with arguments:\n" +
          "  missing keywords :c, :d\n" +
          "  unexpected keywords :e, :f"
        expect(instance.with(0, :e, :f)).to fail_with_actual(actual).
          with_message failure_message
      end # it

      it 'with valid keywords and unspecified arguments' do
        expect(instance.with(:a, :b, :c, :d)).to pass_with_actual(actual).
          with_message "expected #{actual} not to respond to :#{identifier} with keywords :a, :b, :c, :d"
      end # it

      it 'with missing keywords and unspecified arguments' do
        failure_message = "expected #{actual.inspect} to respond to " +
          "#{identifier.inspect} with arguments:\n" +
          "  missing keywords :c, :d"
        expect(instance.with(:a, :b)).to fail_with_actual(actual).
          with_message failure_message
      end # it

      it 'with invalid keywords and unspecified arguments' do
        failure_message = "expected #{actual.inspect} to respond to " +
          "#{identifier.inspect} with arguments:\n" +
          "  unexpected keywords :e, :f"
        expect(instance.with(:c, :d, :e, :f)).to fail_with_actual(actual).
          with_message failure_message
      end # it

      it 'with invalid and missing keywords and unspecified arguments' do
        failure_message = "expected #{actual.inspect} to respond to " +
          "#{identifier.inspect} with arguments:\n" +
          "  missing keywords :c, :d\n" +
          "  unexpected keywords :e, :f"
        expect(instance.with(:e, :f)).to fail_with_actual(actual).
          with_message failure_message
      end # it
    end # describe

    describe 'with a matching method with variadic keywords' do
      let(:actual) do
        # class-eval hackery to avoid syntax errors on pre-2.1.0 systems
        Class.new.tap { |klass| klass.send :class_eval, %Q(klass.send :define_method, :#{identifier}, lambda { |a: true, b: true, c:, d:, **params| }) }.new
      end # let

      it 'with no keywords' do
        expect(instance).to pass_with_actual(actual).
          with_message "expected #{actual} not to respond to :#{identifier}"
      end # it

      it 'with missing keywords' do
        failure_message = "expected #{actual} to respond to :#{identifier} " +
          "with arguments:\n  missing keywords :c, :d"
        expect(instance.with(0, :a, :b)).to fail_with_actual(actual).
          with_message failure_message
      end # it

      it 'with valid keywords' do
        expect(instance.with(0, :a, :b, :c, :d)).to pass_with_actual(actual).
          with_message "expected #{actual} not to respond to :#{identifier} with 0 arguments and keywords :a, :b, :c, :d"
      end # it

      it 'with random keywords' do
        expect(instance.with(0, :c, :d, :e, :f)).to pass_with_actual(actual).
          with_message "expected #{actual} not to respond to :#{identifier} with 0 arguments and keywords :c, :d, :e, :f"
      end # it
    end # describe
  end # if

  describe 'with a matching method that expects a block' do
    let(:actual) do
      Class.new.tap { |klass| klass.send :define_method, identifier, lambda { |&block| yield } }.new
    end # let

    it 'with no block' do
      expect(instance).to pass_with_actual(actual).
        with_message "expected #{actual} not to respond to :#{identifier}"
    end # it

    it 'with a block' do
      expect(instance.with_a_block).to pass_with_actual(actual).
        with_message "expected #{actual} not to respond to :#{identifier} with a block"
    end # it
  end # describe
end # describe
