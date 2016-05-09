# spec/rspec/sleeping_king_studios/matchers/built_in/respond_to_matcher_spec.rb

require 'spec_helper'
require 'rspec/sleeping_king_studios/examples/rspec_matcher_examples'
require 'rspec/sleeping_king_studios/matchers/core/alias_method'
require 'sleeping_king_studios/tools/array_tools'

require 'rspec/sleeping_king_studios/matchers/built_in/respond_to_matcher'

RSpec.describe RSpec::SleepingKingStudios::Matchers::BuiltIn::RespondToMatcher do
  include RSpec::SleepingKingStudios::Examples::RSpecMatcherExamples

  let(:method_name) { :foo }
  let(:instance)    { described_class.new method_name }

  describe '#description' do
    let(:expected) { "respond to ##{method_name}" }

    it { expect(instance).to respond_to(:description).with(0).arguments }

    it { expect(instance.description).to be == expected }

    describe 'with an arguments count' do
      let(:arity)    { 3 }
      let(:instance) { super().with(arity).arguments }
      let(:expected) { super() << " with #{arity} arguments" }

      it { expect(instance.description).to be == expected }
    end # describe

    describe 'with an arguments range' do
      let(:arity)    { 2..4 }
      let(:instance) { super().with(arity).arguments }
      let(:expected) { super() << " with #{arity} arguments" }

      it { expect(instance.description).to be == expected }
    end # describe

    describe 'with unlimited arguments' do
      let(:instance) { super().with_unlimited_arguments }
      let(:expected) { super() << ' with unlimited arguments' }

      it { expect(instance.description).to be == expected }
    end # describe

    describe 'with an arguments count and unlimited arguments' do
      let(:arity)    { 3 }
      let(:instance) { super().with(arity).arguments.and_unlimited_arguments }
      let(:expected) do
        super() << " with #{arity} arguments and unlimited arguments"
      end # let
    end # describe

    describe 'with one keyword' do
      let(:keyword)  { :foo }
      let(:instance) { super().with_keywords(keyword) }
      let(:expected) { super() << " with keyword #{keyword.inspect}" }

      it { expect(instance.description).to be == expected }
    end # describe

    describe 'with two keywords' do
      let(:keywords) { [:foo, :bar] }
      let(:instance) { super().with_keywords(*keywords) }
      let(:expected) do
        super() <<
          " with keywords #{keywords.first.inspect} and "\
          "#{keywords.last.inspect}"
      end # let

      it { expect(instance.description).to be == expected }
    end # describe

    describe 'with many keywords' do
      let(:keywords) { [:foo, :bar, :baz] }
      let(:instance) { super().with_keywords(*keywords) }
      let(:expected) do
        super() <<
          " with keywords #{keywords[0...-1].map(&:inspect).join(', ')}, and "\
          "#{keywords.last.inspect}"
      end # let

      it { expect(instance.description).to be == expected }
    end # describe

    describe 'with arbitrary keywords' do
      let(:instance) { super().with_arbitrary_keywords }
      let(:expected) { super() << ' with arbitrary keywords' }

      it { expect(instance.description).to be == expected }
    end # describe

    describe 'with many keywords and arbitrary keywords' do
      let(:keywords) { [:foo, :bar, :baz] }
      let(:instance) { super().with_keywords(*keywords).and_arbitrary_keywords }
      let(:expected) do
        super() <<
          " with keywords #{keywords[0...-1].map(&:inspect).join(', ')}, and "\
          "#{keywords.last.inspect} and arbitrary keywords"
      end # let

      it { expect(instance.description).to be == expected }
    end # describe

    describe 'with a block' do
      let(:instance) { super().with_a_block }
      let(:expected) { super() << ' with a block' }

      it { expect(instance.description).to be == expected }
    end # describe

    describe 'with complex parameters' do
      let(:arity)     { 3 }
      let(:keywords)  { [:foo, :bar, :baz] }
      let(:instance) do
        super().
          with(arity).arguments.
          and_unlimited_arguments.
          and_keywords(*keywords).
          and_arbitrary_keywords.
          and_a_block
      end # let
      let(:expected) do
        super() <<
          " with #{arity} arguments" <<
          ', unlimited arguments' <<
          ", keywords #{keywords[0...-1].map(&:inspect).join(', ')}" <<
          ", and #{keywords.last.inspect}" <<
          ', arbitrary keywords' <<
          ', and a block'
      end # let

      it { expect(instance.description).to be == expected }
    end # describe
  end # describe

  describe '#matches?' do
    shared_examples 'should respond to method with signature' do |**signature|
      let(:with_arguments_message) { ' with arguments:' }

      private def count_arguments arity
        "#{arity} arguments"
      end # method count_arguments

      private def list_keywords keywords
        tools  = ::SleepingKingStudios::Tools::ArrayTools
        tools.humanize_list(keywords.map(&:inspect))
      end # method list_keywords

      describe 'with no argument expectation' do
        include_examples 'should pass with a positive expectation'

        include_examples 'should fail with a negative expectation'
      end # describe

      min_arguments       = signature.fetch(:min_arguments, 0)
      max_arguments       = signature.fetch(:max_arguments, min_arguments)
      unlimited_arguments = signature.fetch(:unlimited_arguments, false)
      valid_count         = (min_arguments + max_arguments) / 2

      optional_keywords   = signature.fetch(:optional_keywords, [])
      required_keywords   = signature.fetch(:required_keywords, [])
      arbitrary_keywords  = signature.fetch(:arbitrary_keywords, false)
      allowed_keywords    = optional_keywords + required_keywords
      invalid_keywords    = [:forbidden, :disallowed]

      block_argument      = signature.fetch(:block_argument, false)

      if min_arguments > 0
        insufficient_count = [0, min_arguments - 2].min

        describe 'with not enough arguments' do
          let(:failure_message) do
            include(
              super() << with_arguments_message
            ).and include(
              "expected at least #{min_arguments} arguments, but received "\
              "#{insufficient_count}"
            ) # end include
          end # let
          let(:instance) do
            matcher = super()

            unless required_keywords.empty?
              matcher.with_keywords(*required_keywords)
            end # unless

            matcher.with(insufficient_count).arguments
          end # let

          include_examples 'should fail with a positive expectation'

          include_examples 'should pass with a negative expectation'
        end # describe
      end # if-else

      describe 'with a valid number of arguments' do
        let(:failure_message_when_negated) do
          message = super()

          message << " with #{valid_count} arguments"

          unless required_keywords.empty?
            message << " and keywords #{list_keywords required_keywords}"
          end # unless

          message
        end # let
        let(:instance) do
          matcher = super()

          unless required_keywords.empty?
            matcher.with_keywords(*required_keywords)
          end # unless

          matcher.with(valid_count).arguments
        end # let

        include_examples 'should pass with a positive expectation'

        include_examples 'should fail with a negative expectation'
      end # describe

      if unlimited_arguments
        excessive_count = 9001

        describe 'with an excessive number of arguments' do
          let(:failure_message_when_negated) do
            super() << " with #{excessive_count} arguments"
          end # let
          let(:instance) do
            matcher = super()

            unless required_keywords.empty?
              matcher.with_keywords(*required_keywords)
            end # unless

            matcher.with(excessive_count).arguments
          end # let

          include_examples 'should pass with a positive expectation'

          include_examples 'should fail with a negative expectation'
        end # describe

        describe 'with unlimited arguments' do
          let(:failure_message_when_negated) do
            super() << ' with unlimited arguments'
          end # let
          let(:instance) do
            matcher = super()

            unless required_keywords.empty?
              matcher.with_keywords(*required_keywords)
            end # unless

            matcher.with_unlimited_arguments
          end # let

          include_examples 'should pass with a positive expectation'

          include_examples 'should fail with a negative expectation'
        end # describe

        describe 'with a valid number of arguments and unlimited_arguments' do
          let(:failure_message_when_negated) do
            super() << " with #{valid_count} arguments and unlimited arguments"
          end # let
          let(:instance) do
            matcher = super()

            unless required_keywords.empty?
              matcher.with_keywords(*required_keywords)
            end # unless

            matcher.with(valid_count).arguments.and_unlimited_arguments
          end # let

          include_examples 'should pass with a positive expectation'

          include_examples 'should fail with a negative expectation'
        end # describe
      else
        excessive_count = max_arguments + 2

        describe 'with too many arguments' do
          let(:failure_message) do
            include(
              super() << ' with arguments:'
            ).and include(
              "expected at most #{max_arguments} arguments, but received "\
              "#{excessive_count}"
            ) # end include
          end # let
          let(:instance) do
            matcher = super()

            unless required_keywords.empty?
              matcher.with_keywords(*required_keywords)
            end # unless

            matcher.with(excessive_count).arguments
          end # let

          include_examples 'should fail with a positive expectation'

          include_examples 'should pass with a negative expectation'
        end # describe

        describe 'with unlimited arguments' do
          let(:failure_message) do
            include(
              super() << ' with arguments:'
            ).and include(
              "expected at most #{max_arguments} arguments, but received "\
              "unlimited arguments"
            ) # end include
          end # let
          let(:instance) do
            matcher = super()

            unless required_keywords.empty?
              matcher.with_keywords(*required_keywords)
            end # unless

            matcher.with_unlimited_arguments
          end # let

          include_examples 'should fail with a positive expectation'

          include_examples 'should pass with a negative expectation'
        end # describe

        describe 'with a valid number of arguments and unlimited_arguments' do
          let(:failure_message) do
            include(
              super() << ' with arguments:'
            ).and include(
              "expected at most #{max_arguments} arguments, but received "\
              "unlimited arguments"
            ) # end include
          end # let
          let(:instance) do
            matcher = super()

            unless required_keywords.empty?
              matcher.with_keywords(*required_keywords)
            end # unless

            matcher.with(valid_count).arguments.and_unlimited_arguments
          end # let
        end # describe
      end # if-else

      unless optional_keywords.empty?
        describe 'with valid keywords' do
          let(:keywords) { required_keywords + optional_keywords }
          let(:failure_message_when_negated) do
            message = super() << ' with'

            message << " #{min_arguments} arguments and" if min_arguments > 0

            message << " keywords #{list_keywords keywords}"

            message
          end # let
          let(:instance) do
            matcher = super()

            matcher.with(min_arguments).arguments if min_arguments > 0

            matcher.with_keywords(*keywords)
          end # let

          include_examples 'should pass with a positive expectation'

          include_examples 'should fail with a negative expectation'
        end # describe

        describe 'with valid keywords using the deprecated syntax' do
          let(:keywords) { required_keywords + optional_keywords }
          let(:failure_message_when_negated) do
            message = super() << ' with'

            message << " #{min_arguments} arguments and" if min_arguments > 0

            message << " keywords #{list_keywords keywords}"

            message
          end # let
          let(:instance) do
            matcher = super()

            matcher.with(min_arguments).arguments if min_arguments > 0

            matcher.with_keywords(*keywords)
          end # let

          include_examples 'should pass with a positive expectation'

          include_examples 'should fail with a negative expectation'
        end # describe
      end # unless

      unless required_keywords.empty?
        describe 'with required keywords' do
          let(:failure_message_when_negated) do
            message = super() << ' with'

            message << " #{min_arguments} arguments and" if min_arguments > 0

            message << " keywords #{list_keywords required_keywords}"

            message
          end # let
          let(:instance) do
            matcher = super()

            matcher.with(min_arguments).arguments if min_arguments > 0

            matcher.with_keywords(*required_keywords)
          end # let

          include_examples 'should pass with a positive expectation'

          include_examples 'should fail with a negative expectation'
        end # describe

        describe 'with required keywords using the deprecated syntax' do
          let(:failure_message_when_negated) do
            message = super() << ' with'

            message << " #{min_arguments} arguments and" if min_arguments > 0

            message << " keywords #{list_keywords required_keywords}"

            message
          end # let
          let(:instance) do
            matcher = super()

            matcher.with(min_arguments).arguments if min_arguments > 0

            matcher.with_keywords(*required_keywords)
          end # let

          include_examples 'should pass with a positive expectation'

          include_examples 'should fail with a negative expectation'
        end # describe

        describe 'with missing keywords' do
          let(:failure_message) do
            include(
              super() << with_arguments_message
            ).and include(
              "missing keywords #{list_keywords required_keywords}"
            ) # end include
          end # let
          let(:instance) do
            matcher = super()

            matcher.with(min_arguments).arguments if min_arguments > 0

            matcher.with_keywords(*optional_keywords)
          end # let

          include_examples 'should fail with a positive expectation'

          include_examples 'should pass with a negative expectation'
        end # describe
      end # unless

      if arbitrary_keywords
        describe 'with unexpected keywords' do
          let(:keywords) { required_keywords + invalid_keywords }
          let(:failure_message_when_negated) do
            super() << " with keywords #{list_keywords keywords}"
          end # let
          let(:instance) do
            matcher = super()

            matcher.with(min_arguments).arguments if min_arguments > 0

            matcher.with_keywords(*keywords)
          end # let

          include_examples 'should pass with a positive expectation'

          include_examples 'should fail with a negative expectation'
        end # describe

        describe 'with arbitrary keywords' do
          let(:failure_message_when_negated) do
            message = super() << ' with'

            unless required_keywords.empty?
              message << " keywords #{list_keywords required_keywords} and"
            end # unless

            message << ' arbitrary keywords'
          end # let
          let(:instance) do
            matcher = super()

            matcher.with(min_arguments).arguments if min_arguments > 0

            unless required_keywords.empty?
              matcher.with_keywords(*required_keywords)
            end # unless

            matcher.with_arbitrary_keywords
          end # let

          include_examples 'should pass with a positive expectation'

          include_examples 'should fail with a negative expectation'
        end # describe

        describe 'with unexpected and arbitrary keywords' do
          let(:keywords) { required_keywords + invalid_keywords }
          let(:failure_message_when_negated) do
            super() <<
              " with keywords #{list_keywords keywords} and arbitrary keywords"
          end # let
          let(:instance) do
            matcher = super()

            matcher.with(min_arguments).arguments if min_arguments > 0

            matcher.with_keywords(*keywords).and_arbitrary_keywords
          end # let

          include_examples 'should pass with a positive expectation'

          include_examples 'should fail with a negative expectation'
        end # describe
      else
        describe 'with unexpected keywords' do
          let(:keywords) { required_keywords + invalid_keywords }
          let(:failure_message) do
            include(
              super() << with_arguments_message
            ).and include(
              "unexpected keywords #{list_keywords invalid_keywords}"
            ) # end include
          end # let
          let(:instance) do
            matcher = super()

            matcher.with(min_arguments).arguments if min_arguments > 0

            matcher.with_keywords(*keywords)
          end # let

          include_examples 'should fail with a positive expectation'

          include_examples 'should pass with a negative expectation'
        end # describe

        describe 'with arbitrary keywords' do
          let(:failure_message) do
            include(
              super() << with_arguments_message
            ).and include(
              'expected arbitrary keywords'
            ) # end include
          end # let
          let(:instance) do
            matcher = super()

            matcher.with(min_arguments).arguments if min_arguments > 0

            unless required_keywords.empty?
              matcher.with_keywords(*required_keywords)
            end # unless

            matcher.with_arbitrary_keywords
          end # let

          include_examples 'should fail with a positive expectation'

          include_examples 'should pass with a negative expectation'
        end # describe

        describe 'with unexpected keywords and arbitrary keywords' do
          let(:keywords) { required_keywords + invalid_keywords }
          let(:failure_message) do
            include(
              super() << with_arguments_message
            ).and include(
              "unexpected keywords #{list_keywords invalid_keywords}"
            ).and include(
              'expected arbitrary keywords'
            ) # end include
          end # let
          let(:instance) do
            matcher = super()

            matcher.with(min_arguments).arguments if min_arguments > 0

            matcher.with_keywords(*keywords).and_arbitrary_keywords
          end # let

          include_examples 'should fail with a positive expectation'

          include_examples 'should pass with a negative expectation'
        end # describe
      end # if-else

      if block_argument
        describe 'without a block' do
          include_examples 'should pass with a positive expectation'

          include_examples 'should fail with a negative expectation'
        end # describe

        describe 'with a block' do
          let(:failure_message_when_negated) do
            super() << ' with a block'
          end # let
          let(:instance) { super().with_a_block }

          include_examples 'should pass with a positive expectation'

          include_examples 'should fail with a negative expectation'
        end # describe
      else
        describe 'with a block' do
          let(:failure_message) do
            include(
              super() << with_arguments_message
            ).and include(
              'unexpected block'
            ) # end include
          end # let
          let(:instance) { super().with_a_block }

          include_examples 'should fail with a positive expectation'

          include_examples 'should pass with a negative expectation'
        end # describe
      end # if-else
    end # shared_examples

    let(:failure_message) do
      "expected #{actual.inspect} to respond to #{method_name.inspect}"
    end # let
    let(:failure_message_when_negated) do
      "expected #{actual.inspect} not to respond to #{method_name.inspect}"
    end # let

    describe 'with no matching method' do
      let(:actual) { Object.new }

      include_examples 'should fail with a positive expectation'

      include_examples 'should pass with a negative expectation'
    end # describe

    describe 'with a matching method with no arguments' do
      let(:actual) do
        Class.new.tap do |klass|
          klass.send :define_method, method_name, ->() {}
        end.new
      end # let

      include_examples 'should respond to method with signature'
    end # describe

    describe 'with a matching private method with no arguments' do
      let(:actual) do
        Class.new.tap do |klass|
          klass.send :define_method, method_name, ->() {}
          klass.send :private, method_name
        end.new
      end # let

      describe 'with no argument expectation' do
        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end # describe

      describe 'with include_all => true' do
        let(:instance) { described_class.new method_name, true }

        include_examples 'should respond to method with signature'
      end # describe
    end # describe

    describe 'with a matching method with required arguments' do
      let(:actual) do
        Class.new.tap do |klass|
          klass.send :define_method, method_name, ->(a, b, c = nil) {}
        end.new
      end # let

      include_examples 'should respond to method with signature',
        :min_arguments => 2,
        :max_arguments => 3
    end # describe

    describe 'with a matching method with variadic arguments' do
      let(:actual) do
        Class.new.tap do |klass|
          klass.send :define_method, method_name, ->(a, b, c, *rest) {}
        end.new
      end # let

      include_examples 'should respond to method with signature',
        :min_arguments => 3,
        :unlimited_arguments => true
    end # describe

    describe 'with a matching method with optional keywords' do
      let(:actual) do
        Class.new.tap do |klass|
          klass.send :define_method, method_name, ->(x: nil, y: nil) {}
        end.new
      end # let

      include_examples 'should respond to method with signature',
        :optional_keywords => [:x, :y]
    end # describe

    describe 'with a matching method with required keywords' do
      let(:actual) do
        Class.new.tap do |klass|
          klass.send :define_method, method_name, ->(x:, y:, u: nil, v: nil) {}
        end.new
      end # let

      include_examples 'should respond to method with signature',
        :optional_keywords => [:u, :v],
        :required_keywords => [:x, :y]
    end # describe

    describe 'with a matching method with variadic keywords' do
      let(:actual) do
        Class.new.tap do |klass|
          klass.send :define_method, method_name, ->(x:, y:, **kwargs) {}
        end.new
      end # let

      include_examples 'should respond to method with signature',
        :required_keywords  => [:x, :y],
        :arbitrary_keywords => true
    end # describe

    describe 'with a matching method with a block argument' do
      let(:actual) do
        Class.new.tap do |klass|
          klass.send :define_method, method_name, ->(&block) {}
        end.new
      end # let

      include_examples 'should respond to method with signature',
        :block_argument => true
    end # describe

    describe 'with a matching method with complex parameters' do
      let(:actual) do
        Class.new.tap do |klass|
          klass.send :define_method, method_name,
            ->(a, b, c = nil, d = nil, x:, y:, u: nil, v: nil, &block) {}
        end.new
      end # let

      include_examples 'should respond to method with signature',
        :min_arguments     => 2,
        :max_arguments     => 4,
        :optional_keywords => [:u, :v],
        :required_keywords => [:x, :y],
        :block_argument    => true
    end # describe
  end # describe

  describe '#with' do
    it { expect(instance).to respond_to(:with).with(0).arguments }
    it { expect(instance).to respond_to(:with).with(2).arguments }

    it { expect(instance.with).to be instance }
  end # describe

  describe '#with_a_block' do
    it { expect(instance).to respond_to(:with_a_block).with(0).arguments }

    it { expect(instance).to alias_method(:with_a_block).as(:and_a_block) }

    it { expect(instance.with_a_block).to be instance }
  end # describe

  describe '#with_any_keywords' do
    it { expect(instance).to respond_to(:with_any_keywords).with(0).arguments }

    it { expect(instance).to alias_method(:with_any_keywords).as(:and_any_keywords) }
    it { expect(instance).to alias_method(:with_any_keywords).as(:with_arbitrary_keywords) }
    it { expect(instance).to alias_method(:with_any_keywords).as(:and_arbitrary_keywords) }

    it { expect(instance.with_any_keywords).to be instance }
  end # describe

  describe '#with_keywords' do
    it { expect(instance).to respond_to(:with_keywords).with(1).argument }
    it { expect(instance).to respond_to(:with_keywords).with(9001).arguments }

    it { expect(instance).to alias_method(:with_keywords).as(:and_keywords) }

    it { expect(instance.with_keywords :foo).to be instance }
  end # describe

  describe '#with_unlimited_arguments' do
    it { expect(instance).to respond_to(:with_unlimited_arguments).with(0).arguments }

    it { expect(instance).to alias_method(:with_unlimited_arguments).as(:and_unlimited_arguments) }

    it { expect(instance.with_unlimited_arguments).to be instance }
  end # describe
end # describe
