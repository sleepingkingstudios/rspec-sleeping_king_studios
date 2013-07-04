# spec/rspec/sleeping_king_studios/matchers/core/construct_spec.rb

require 'rspec/sleeping_king_studios/spec_helper'
require 'rspec/sleeping_king_studios/matchers/built_in/respond_to'

require 'rspec/sleeping_king_studios/matchers/core/construct'

describe "construct matcher" do
  def self.ruby_version
    RSpec::SleepingKingStudios::Util::Version.new ::RUBY_VERSION
  end # class method ruby_version

  let(:example_group) { RSpec::Core::ExampleGroup.new }
  let(:instance)      { example_group.construct }
  let(:ruby_version)  { Version.new *RUBY_VERSION.split(".") }

  specify { expect(example_group).to respond_to(:construct).with(0).arguments }

  describe '#with' do
    specify { expect(instance).to respond_to(:with).with(0..2).arguments }
    specify { expect(instance.with).to be instance }
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

    specify { expect(instance).to fail_with_actual(actual).
      with_message "expected #{actual.inspect} to construct" }
  end # describe

  describe 'with a ::new method with no arguments' do
    let(:actual) { Class.new { def initialize; end } }

    specify 'with no arguments' do
      expect(instance).to pass_with_actual(actual).
        with_message "expected #{actual.inspect} not to construct"
    end # specify

    specify 'with too many arguments' do
      failure_message = "expected #{actual.inspect} to construct with arguments:\n" +
        "  expected at most 0 arguments, but received 1"
      expect(instance.with(1).arguments).to fail_with_actual(actual).
        with_message failure_message
    end # specify
  end # describe

  describe 'with a ::new method with required arguments' do
    let(:actual) { Class.new { def initialize(a, b, c = nil); end } }

    specify 'with not enough arguments' do
      failure_message = "expected #{actual.inspect} to construct with arguments:\n" +
        "  expected at least 2 arguments, but received 1"
      expect(instance.with(1).arguments).to fail_with_actual(actual).
        with_message failure_message
    end # specify

    specify 'with enough arguments' do
      expect(instance.with(3).arguments).to pass_with_actual(actual).
        with_message "expected #{actual} not to construct with 3 arguments"
    end # specify

    specify 'with too many arguments' do
      failure_message = "expected #{actual.inspect} to construct with arguments:\n" +
        "  expected at most 3 arguments, but received 5"
      expect(instance.with(5).arguments).to fail_with_actual(actual).
        with_message failure_message
    end # specify
  end # describe

  describe 'with a ::new method with variadic arguments' do
    let(:actual) { Class.new { def initialize(a, b, c, *rest); end } }

    specify 'with not enough arguments' do
      failure_message = "expected #{actual.inspect} to construct with arguments:\n" +
        "  expected at least 3 arguments, but received 2"
      expect(instance.with(2).arguments).to fail_with_actual(actual).
        with_message failure_message
    end # specify

    specify 'with an excessive number of arguments' do
      expect(instance.with(9001).arguments).to pass_with_actual(actual).
        with_message "expected #{actual} not to construct with 9001 arguments"
    end # specify
  end # describe

  if ruby_version >= "2.0.0"
    describe 'with a ::new method with keywords' do
      let(:actual) do
        # class-eval hackery to avoid syntax errors on pre-2.0.0 systems
        Class.new.tap { |klass| klass.send :class_eval, %Q(klass.send :define_method, :initialize, lambda { |a: true, b: true| }) }
      end # let

      specify 'with no keywords' do
        expect(instance).to pass_with_actual(actual).
          with_message "expected #{actual} not to construct"
      end # specify

      specify 'with valid keywords' do
        expect(instance.with(0, :a, :b)).to pass_with_actual(actual).
          with_message "expected #{actual} not to construct with 0 arguments and keywords :a, :b"
      end # specify

      specify 'with invalid keywords' do
        failure_message = "expected #{actual.inspect} to construct with arguments:\n" +
          "  unexpected keywords :c, :d"
        expect(instance.with(0, :c, :d)).to fail_with_actual(actual).
          with_message failure_message
      end # specify
    end # describe

    describe 'with a matching method with variadic keywords' do
      let(:actual) do
        # class-eval hackery to avoid syntax errors on pre-2.0.0 systems
        Class.new.tap { |klass| klass.send :class_eval, %Q(klass.send :define_method, :initialize, lambda { |a: true, b: true, **params| }) }
      end # let

      specify 'with no keywords' do
        expect(instance).to pass_with_actual(actual).
          with_message "expected #{actual} not to construct"
      end # specify

      specify 'with valid keywords' do
        expect(instance.with(0, :a, :b)).to pass_with_actual(actual).
          with_message "expected #{actual} not to construct with 0 arguments and keywords :a, :b"
      end # specify

      specify 'with random keywords' do
        expect(instance.with(0, :c, :d)).to pass_with_actual(actual).
          with_message "expected #{actual} not to construct with 0 arguments and keywords :c, :d"
      end # specify
    end # describe
  end # if
end # describe
