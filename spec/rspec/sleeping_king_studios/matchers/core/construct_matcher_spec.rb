# spec/rspec/sleeping_king_studios/matchers/core/construct_matcher_spec.rb

require 'spec_helper'
require 'rspec/sleeping_king_studios/examples/rspec_matcher_examples'
require 'rspec/sleeping_king_studios/matchers/core/alias_method'
require 'support/shared_examples/matchers/method_signature_examples'

require 'rspec/sleeping_king_studios/matchers/core/construct_matcher'

RSpec.describe RSpec::SleepingKingStudios::Matchers::Core::ConstructMatcher do
  include RSpec::SleepingKingStudios::Examples::RSpecMatcherExamples
  include Spec::Support::SharedExamples::Matchers::MethodSignatureExamples

  let(:instance) { described_class.new }

  describe '#description' do
    let(:expected) { 'construct' }

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
      let(:expected) { super() << ' with 0 arguments and unlimited arguments' }

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
      let(:expected) { super() << " with 0 arguments and keyword #{keyword.inspect}" }

      it { expect(instance.description).to be == expected }
    end # describe

    describe 'with two keywords' do
      let(:keywords) { [:foo, :bar] }
      let(:instance) { super().with_keywords(*keywords) }
      let(:expected) do
        super() <<
          ' with 0 arguments and'\
          " keywords #{keywords.first.inspect} and "\
          "#{keywords.last.inspect}"
      end # let

      it { expect(instance.description).to be == expected }
    end # describe

    describe 'with many keywords' do
      let(:keywords) { [:foo, :bar, :baz] }
      let(:instance) { super().with_keywords(*keywords) }
      let(:expected) do
        super() <<
          ' with 0 arguments and'\
          " keywords #{keywords[0...-1].map(&:inspect).join(', ')}, and "\
          "#{keywords.last.inspect}"
      end # let

      it { expect(instance.description).to be == expected }
    end # describe

    describe 'with arbitrary keywords' do
      let(:instance) { super().with_arbitrary_keywords }
      let(:expected) { super() << ' with 0 arguments and arbitrary keywords' }

      it { expect(instance.description).to be == expected }
    end # describe

    describe 'with many keywords and arbitrary keywords' do
      let(:keywords) { [:foo, :bar, :baz] }
      let(:instance) { super().with_keywords(*keywords).and_arbitrary_keywords }
      let(:expected) do
        super() <<
          ' with 0 arguments,'\
          " keywords #{keywords[0...-1].map(&:inspect).join(', ')}, and "\
          "#{keywords.last.inspect}, and arbitrary keywords"
      end # let

      it { expect(instance.description).to be == expected }
    end # describe

    describe 'with a block' do
      let(:instance) { super().with_a_block }
      let(:expected) { super() << ' with 0 arguments and a block' }

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
    let(:failure_message) do
      "expected #{actual.inspect} to be constructible"
    end # let
    let(:failure_message_when_negated) do
      "expected #{actual.inspect} not to be constructible"
    end # let

    describe 'with an object that does not respond to :new' do
      let(:actual) { Object.new }
      let(:failure_message) do
        super() << ", but #{actual.inspect} does not respond to ::new"
      end # let

      include_examples 'should fail with a positive expectation'

      include_examples 'should pass with a negative expectation'
    end # describe

    describe 'with an object that cannot be allocated' do
      let(:actual) do
        Class.new do
          def new required:, keywords:

          end # method new
        end.new
      end # let
      let(:failure_message) do
        super() << ", but was unable to allocate an instance of #{actual.inspect} with ::allocate or ::new"
      end # let

      include_examples 'should fail with a positive expectation'

      include_examples 'should pass with a negative expectation'
    end # describe

    describe 'with an object with an inaccessible constructor' do
      let(:actual) do
        Class.new do
          def new required:, keywords:

          end # method new

          def allocate
            self
          end # method allocate

          original_verbose, $VERBOSE = $VERBOSE, nil
          undef_method :initialize
          $VERBOSE = original_verbose
        end.allocate
      end # let
      let(:failure_message) do
        super() << ", but was unable to reflect on constructor because :initialize is not a method on #{actual.inspect}"
      end # let

      include_examples 'should fail with a positive expectation'

      include_examples 'should pass with a negative expectation'
    end # describe

    describe 'with an object that can be constructed with no arguments' do
      let(:actual) do
        Class.new.tap do |klass|
          klass.send :define_method, :initialize, ->() {}
        end # class
      end # let

      include_examples 'should respond to method with signature'
    end # describe

    describe 'with an object that can be constructed with required arguments' do
      let(:actual) do
        Class.new.tap do |klass|
          klass.send :define_method, :initialize, ->(a, b, c = nil) {}
        end # class
      end # let

      include_examples 'should respond to method with signature',
        :min_arguments => 2,
        :max_arguments => 3
    end # describe

    describe 'with an object that can be constructed with variadic arguments' do
      let(:actual) do
        Class.new.tap do |klass|
          klass.send :define_method, :initialize, ->(a, b, c, *rest) {}
        end # class
      end # let

      include_examples 'should respond to method with signature',
        :min_arguments => 3,
        :unlimited_arguments => true
    end # describe

    describe 'with an object that can be constructed with optional keywords' do
      let(:actual) do
        Class.new.tap do |klass|
          klass.send :define_method, :initialize, ->(x: nil, y: nil) {}
        end # class
      end # let

      include_examples 'should respond to method with signature',
        :optional_keywords => [:x, :y]
    end # describe

    describe 'with an object that can be constructed with required keywords' do
      let(:actual) do
        Class.new.tap do |klass|
          klass.send :define_method, :initialize, ->(x:, y:, u: nil, v: nil) {}
        end # class
      end # let

      include_examples 'should respond to method with signature',
        :optional_keywords => [:u, :v],
        :required_keywords => [:x, :y]
    end # describe

    describe 'with an object that can be constructed with variadic keywords' do
      let(:actual) do
        Class.new.tap do |klass|
          klass.send :define_method, :initialize, ->(x:, y:, **kwargs) {}
        end # class
      end # let

      include_examples 'should respond to method with signature',
        :required_keywords  => [:x, :y],
        :arbitrary_keywords => true
    end # describe

    describe 'with an object that can be constructed with a block argument' do
      let(:actual) do
        Class.new.tap do |klass|
          klass.send :define_method, :initialize, ->(&block) {}
        end # class
      end # let

      include_examples 'should respond to method with signature',
        :block_argument => true
    end # describe

    describe 'with an object that can be constructed with complex parameters' do
      let(:actual) do
        Class.new.tap do |klass|
          klass.send :define_method, :initialize,
            ->(a, b, c = nil, d = nil, x:, y:, u: nil, v: nil, &block) {}
        end # class
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
