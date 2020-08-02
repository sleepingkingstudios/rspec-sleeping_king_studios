# spec/rspec/sleeping_king_studios/matchers/built_in/respond_to_matcher_spec.rb

require 'spec_helper'
require 'rspec/sleeping_king_studios/examples/rspec_matcher_examples'
require 'rspec/sleeping_king_studios/matchers/core/alias_method'
require 'support/shared_examples/matchers/method_signature_examples'

require 'rspec/sleeping_king_studios/matchers/built_in/respond_to_matcher'

RSpec.describe RSpec::SleepingKingStudios::Matchers::BuiltIn::RespondToMatcher do
  include RSpec::SleepingKingStudios::Examples::RSpecMatcherExamples
  include Spec::Support::SharedExamples::Matchers::MethodSignatureExamples

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
    shared_examples 'should match a private method' do
      context 'when the method is private' do
        before(:example) do
          actual.class.send(:private, method_name)
        end

        describe 'with include_all => false' do
          let(:failure_message) do
            super() << ", but #{actual.inspect} does not respond to #{method_name.inspect}"
          end # let

          include_examples 'should fail with a positive expectation'

          include_examples 'should pass with a negative expectation'
        end # describe

        describe 'with include_all => true' do
          let(:instance) { described_class.new method_name, true }

          include_examples 'should respond to method with signature'
        end # describe
      end # describe
    end

    shared_examples 'should validate the method signature' do
      describe 'when the method takes no arguments' do
        let(:implementation) { -> {} }

        include_examples 'should respond to method with signature'
      end # describe

      describe 'when the method takes required arguments' do
        let(:implementation) { ->(a, b, c = nil) {} }

        include_examples 'should respond to method with signature',
          :min_arguments => 2,
          :max_arguments => 3
      end # describe

      describe 'when the method takes variadic arguments' do
        let(:implementation) { ->(a, b, c, *rest) {} }

        include_examples 'should respond to method with signature',
          :min_arguments => 3,
          :unlimited_arguments => true
      end # describe

      describe 'when the method takes optional keywords' do
        let(:implementation) { ->(x: nil, y: nil) {} }

        include_examples 'should respond to method with signature',
          :optional_keywords => [:x, :y]
      end # describe

      describe 'when the method takes required keywords' do
        let(:implementation) { ->(x:, y:, u: nil, v: nil) {} }

        include_examples 'should respond to method with signature',
          :optional_keywords => [:u, :v],
          :required_keywords => [:x, :y]
      end # describe

      describe 'when the method takes variadic keywords' do
        let(:implementation) { ->(x:, y:, **kwargs) {} }

        include_examples 'should respond to method with signature',
          :required_keywords  => [:x, :y],
          :arbitrary_keywords => true
      end # describe

      describe 'when the method takes a block argument' do
        let(:implementation) { ->(&block) {} }

        include_examples 'should respond to method with signature',
          :block_argument => true
      end # describe

      describe 'when the method takes complex parameters' do
        let(:implementation) do
          ->(a, b, c = nil, d = nil, x:, y:, u: nil, v: nil, &block) {}
        end

        include_examples 'should respond to method with signature',
          :min_arguments     => 2,
          :max_arguments     => 4,
          :optional_keywords => [:u, :v],
          :required_keywords => [:x, :y],
          :block_argument    => true
      end # describe
    end

    let(:failure_message) do
      "expected #{actual.inspect} to respond to #{method_name.inspect}"
    end # let
    let(:failure_message_when_negated) do
      "expected #{actual.inspect} not to respond to #{method_name.inspect}"
    end # let

    describe 'with an object that does not respond to the method' do
      let(:actual) { Object.new }
      let(:failure_message) do
        super() << ", but #{actual.inspect} does not respond to #{method_name.inspect}"
      end # let

      include_examples 'should fail with a positive expectation'

      include_examples 'should pass with a negative expectation'
    end # describe

    describe 'with an object that does not define the method' do
      let(:actual) do
        Class.new.tap do |klass|
          klass.send :define_method, :respond_to?, ->(method_name, allow_private = false) { true }
        end.new
      end # let
      let(:failure_message) do
        super() << ", but #{actual.inspect} does not define a method at #{method_name.inspect}"
      end # let

      include_examples 'should fail with a positive expectation'

      include_examples 'should pass with a negative expectation'
    end # describe

    describe 'with an object with a matching method' do
      let(:implementation) { -> {} }
      let(:actual) do
        Class.new.tap do |klass|
          klass.send :define_method, method_name, implementation
        end.new
      end

      include_examples 'should match a private method'

      include_examples 'should validate the method signature'
    end

    describe 'with an object with a :new method' do
      let(:method_name) { :new }
      let(:implementation) { -> {} }
      let(:actual) do
        Class.new.tap do |klass|
          klass.send :define_method, method_name, implementation
        end.new
      end

      include_examples 'should match a private method'

      include_examples 'should validate the method signature'
    end

    describe 'with a class and method_name: :new' do
      let(:method_name) { :new }
      let(:implementation) { -> {} }
      let(:actual) do
        Class.new.tap do |klass|
          klass.send :define_method, :initialize, implementation
        end
      end

      include_examples 'should validate the method signature'

      context 'when the method is private' do
        before(:example) do
          actual.singleton_class.send(:private, :new)
        end

        describe 'with include_all => false' do
          let(:failure_message) do
            super() << ", but #{actual.inspect} does not respond to #{method_name.inspect}"
          end # let

          include_examples 'should fail with a positive expectation'

          include_examples 'should pass with a negative expectation'
        end # describe

        describe 'with include_all => true' do
          let(:instance) { described_class.new method_name, true }

          include_examples 'should respond to method with signature'
        end # describe
      end # describe
    end
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
