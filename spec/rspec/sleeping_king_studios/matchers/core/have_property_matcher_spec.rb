# spec/rspec/sleeping_king_studios/matchers/core/have_property_matcher_spec.rb

require 'rspec/sleeping_king_studios/examples/rspec_matcher_examples'
require 'rspec/sleeping_king_studios/matchers/built_in/respond_to'
require 'rspec/sleeping_king_studios/matchers/core/construct'
require 'rspec/sleeping_king_studios/matchers/core/have_aliased_method'
require 'rspec/sleeping_king_studios/matchers/core/have_predicate'
require 'rspec/sleeping_king_studios/matchers/core/have_property_matcher'

RSpec.describe RSpec::SleepingKingStudios::Matchers::Core::HavePropertyMatcher do
  include RSpec::SleepingKingStudios::Examples::RSpecMatcherExamples

  let(:property) { :foo }
  let(:instance) { described_class.new property }

  describe '::new' do
    it 'should define the constructor' do
      expect(described_class).
        to be_constructible.
        with(1).arguments.
        and_keywords(:allow_private)
    end # it
  end # describe

  describe '#allow_private?' do
    it { expect(instance).to have_predicate(:allow_private?).with_value(false) }

    context 'when the matcher matches private properties' do
      let(:instance) { described_class.new(property, :allow_private => true) }

      it { expect(instance.allow_private?).to be true }
    end # context
  end # describe

  describe '#description' do
    let(:expected) { "have property #{property.inspect}" }

    it { expect(instance).to respond_to(:description).with(0).arguments }

    it { expect(instance.description).to be == expected }

    context 'with a value expectation set' do
      let(:expected_value) { 12345 }
      let(:expected)       { super() << " with value #{expected_value.inspect}" }
      let(:instance)       { super().with(expected_value) }

      it { expect(instance.description).to be == expected }
    end # context
  end # describe

  describe '#matches?' do
    let(:failure_message) do
      message =
        "expected #{actual.inspect} to respond to #{property.inspect} "\
        "and #{property.inspect}="

      message << expected_string

      message
    end # let
    let(:failure_message_when_negated) do
      message =
        "expected #{actual.inspect} not to respond to #{property.inspect} "\
        "or #{property.inspect}="

      message << expected_string

      message
    end # let
    let(:expected_string) do
      return '' unless defined?(expected_value)

      message = ' and return '

      if expected_value.respond_to?(:matches?) && expected_value.respond_to?(:description)
        message << expected_value.description
      else
        message << expected_value.inspect
      end # if-else

      message
    end # let

    describe 'with an object that does not respond to :property or :property=' do
      let(:failure_message) do
        super() <<
          ", but did not respond to :#{property} or"\
          " :#{property}="
      end # let
      let(:actual) { Object.new }

      include_examples 'should fail with a positive expectation'

      include_examples 'should pass with a negative expectation'
    end # describe

    describe 'with an object that responds to :property' do
      let(:failure_message) do
        super() << ", but did not respond to #{property.inspect}="
      end # let
      let(:failure_message_when_negated) do
        super() << ", but responded to #{property.inspect}"
      end # let
      let(:actual) { Class.new.tap { |klass| klass.send :attr_reader, property }.new }

      include_examples 'should fail with a positive expectation'

      include_examples 'should fail with a negative expectation'
    end # describe

    describe 'with an object that responds to :property=' do
      let(:failure_message) do
        super() << ", but did not respond to #{property.inspect}"
      end # let
      let(:failure_message_when_negated) do
        super() << ", but responded to #{property.inspect}="
      end # let

      let(:actual) { Class.new.tap { |klass| klass.send :attr_writer, property }.new }

      include_examples 'should fail with a positive expectation'

      include_examples 'should fail with a negative expectation'
    end # describe

    describe 'with an object responding to :property and :property=' do
      let(:value) { 42 }
      let(:actual) do
        Struct.new(property) do
          def inspect
            '<struct>'
          end # method inspect
        end.
          new(value)
      end # let

      describe 'with no expected value' do
        let(:failure_message_when_negated) do
          super() << ", but responded to :#{property} and :#{property}="
        end # let

        include_examples 'should pass with a positive expectation'

        include_examples 'should fail with a negative expectation'
      end # describe

      describe 'with a correct expected value' do
        let(:failure_message_when_negated) do
          super() <<
            ", but responded to :#{property} and :#{property}="\
            " and returned #{value.inspect}"
        end # let
        let(:expected_value) { value }
        let(:instance)       { super().with(expected_value) }

        include_examples 'should pass with a positive expectation'

        include_examples 'should fail with a negative expectation'
      end # describe

      describe 'with an incorrect expected value' do
        let(:failure_message) do
          super() << ", but returned #{value.inspect}"
        end # let
        let(:failure_message_when_negated) do
          super() << ", but responded to :#{property} and :#{property}="
        end # let
        let(:expected_value) { 15151 }
        let(:instance)       { super().with(expected_value) }

        include_examples 'should fail with a positive expectation'

        include_examples 'should fail with a negative expectation'
      end # describe

      describe 'with a matcher that matches the value' do
        let(:failure_message_when_negated) do
          super() <<
            ", but responded to :#{property} and :#{property}= and "\
            "returned #{value.inspect}"
        end # let
        let(:expected_value) { a_kind_of(Integer) }
        let(:instance)       { super().with(expected_value) }

        include_examples 'should pass with a positive expectation'

        include_examples 'should fail with a negative expectation'
      end # describe

      describe 'with a matcher that does not match the value' do
        let(:failure_message) do
          super() << ", but returned #{value.inspect}"
        end # let
        let(:failure_message_when_negated) do
          super() << ", but responded to :#{property} and :#{property}="
        end # let
        let(:expected_value) { a_kind_of(String) }
        let(:instance)       { super().with(expected_value) }

        include_examples 'should fail with a positive expectation'

        include_examples 'should fail with a negative expectation'
      end # describe
    end # describe

    describe 'with an object with a private #property property' do
      let(:value) { 42 }
      let(:actual) do
        Struct.new(property) do
          def inspect
            '<struct>'
          end # method inspect
        end.
          tap do |klass|
            klass.send(:private, property)
            klass.send(:private, :"#{property}=")
          end.
          new(value)
      end # let
      let(:failure_message) do
        super() << ", but did not respond to :#{property} or :#{property}="
      end # let
      let(:failure_message_when_negated) do
        super() << ", but responded to :#{property} and :#{property}="
      end # let

      include_examples 'should fail with a positive expectation'

      include_examples 'should pass with a negative expectation'

      context 'when the matcher matches private properties' do
        let(:instance) { described_class.new(property, :allow_private => true) }

        include_examples 'should pass with a positive expectation'

        include_examples 'should fail with a negative expectation'
      end # context
    end # describe
  end # describe

  describe '#with_value' do
    it { expect(instance).to respond_to(:with_value).with(1).arguments }

    it { expect(instance).to have_aliased_method(:with_value).as(:with) }

    it { expect(instance.with_value false).to be instance }
  end # describe with
end # describe
