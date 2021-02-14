# spec/rspec/sleeping_king_studios/matchers/built_in/include_matcher_spec.rb

require 'spec_helper'
require 'rspec/sleeping_king_studios/examples/rspec_matcher_examples'
require 'sleeping_king_studios/tools/array_tools'

require 'rspec/sleeping_king_studios/matchers/built_in/include_matcher'

RSpec.describe RSpec::SleepingKingStudios::Matchers::BuiltIn::IncludeMatcher do
  include RSpec::SleepingKingStudios::Examples::RSpecMatcherExamples

  let(:expectations)   { "String" }
  let(:instance)       { described_class.new *expected_items }
  let(:actual_string)  { actual.inspect }
  let(:expected_items) do
    expectations.is_a?(Array) ? expectations : [expectations]
  end # let
  let(:matching_items) { expected_items }
  let(:missing_items)  { expected_items }
  let(:failure_message) do
    expected = format_expected_items(missing_items)

    "expected #{actual_string} to include #{expected}"
  end # let
  let(:failure_message_when_negated) do
    expected = format_expected_items(matching_items)

    "expected #{actual_string} not to include #{expected}"
  end # let

  def format_expected_items items
    items = (Spec::RSPEC_VERSION < "3.3.0") ? expected_items : items
    items = items.map do |item|
      case item
      when Proc
        'an item matching the block'
      when Hash
        item.inspect.gsub(/(\S)=>(\S)/, '\1 => \2')
      when ->(item) { item.respond_to?(:description) && item.respond_to?(:matches?) }
        (Spec::RSPEC_VERSION < "3.3.0") ? item.description : "(#{item.description})"
      else
        item.inspect
      end # case
    end # each

    ::SleepingKingStudios::Tools::ArrayTools.humanize_list(items)
  end # method format_expected_items

  def sort_keys hash
    Hash[hash.to_a.sort_by { |(key, _)| key }]
  end # method sort_keys

  describe '::new' do
    describe 'with no arguments' do
      context 'when the configuration option is set to true' do
        around(:each) do |example|
          begin
            config      = RSpec.configure { |config| config.sleeping_king_studios.matchers }
            prior_value = config.allow_empty_include_matchers

            config.allow_empty_include_matchers = true

            example.call
          ensure
            config.allow_empty_include_matchers = prior_value
          end # begin-ensure
        end # around each

        it 'should not raise an error' do
          expect { described_class.new }.not_to raise_error
        end # it
      end # context

      context 'when the configuration option is set to false' do
        around(:each) do |example|
          begin
            config      = RSpec.configure { |config| config.sleeping_king_studios.matchers }
            prior_value = config.allow_empty_include_matchers

            config.allow_empty_include_matchers = false

            example.call
          ensure
            config.allow_empty_include_matchers = prior_value
          end # begin-ensure
        end # around each

        it 'should raise an error' do
          expect { described_class.new }.
            to raise_error ArgumentError,
              'must specify an item expectation'
        end # it
      end # context
    end # describe
  end # describe

  describe '#description' do
    let(:expected) do
      included_string = format_expected_items(expected_items)

      "include #{included_string}"
    end # let

    before(:example) do
      allow(SleepingKingStudios::Tools::CoreTools).to receive(:deprecate)
    end

    it { expect(instance).to respond_to(:description).with(0).arguments }

    it { expect(instance.description).to be == expected }

    context 'with a plural expectation' do
      let(:expectations) { %w(foo bar baz) }

      it { expect(instance.description).to be == expected }
    end # context

    context 'with a hash expectation' do
      let(:expectations) { { :foo => 'foo', :bar => 'bar' } }
      let(:expected_items) do
        hash = expectations

        hash = sort_keys(hash) if Spec::RSPEC_VERSION >= '3.8.0'

        [hash]
      end # let

      it { expect(instance.description).to be == expected }
    end # context

    context 'with a block expectation' do
      let(:expectations) { ->(obj) { obj.is_a?(Object) } }
      let(:instance)     { described_class.new &expectations }

      it { expect(instance.description).to be == expected }
    end # context
  end # describe

  describe '#matches?' do
    before(:example) do
      allow(SleepingKingStudios::Tools::CoreTools).to receive(:deprecate)
    end

    it 'should print a deprecation warning' do
      described_class.new {}.matches?(nil)

      expect(SleepingKingStudios::Tools::CoreTools)
        .to have_received(:deprecate)
        .with('IncludeMatcher with a block')
    end

    describe 'with an object that does not respond to #include?' do
      let(:failure_message) do
        "#{super()}, but it does not respond to `include?`"
      end # let
      let(:failure_message_when_negated) do
        "#{super()}, but it does not respond to `include?`"
      end # let
      let(:actual) { Object.new }

      include_examples 'should fail with a positive expectation'

      include_examples 'should fail with a negative expectation'
    end # describe

    describe 'with an Array' do
      let(:actual) { %w(foo bar baz) }

      describe 'with a matching single item expectation' do
        let(:expectations) { 'foo' }

        include_examples 'should pass with a positive expectation'

        include_examples 'should fail with a negative expectation'
      end # describe

      describe 'with a non-matching single item expectation' do
        let(:expectations) { 'wibble' }

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end # describe

      describe 'with a matching multiple item expectation' do
        let(:expectations) { %w(foo baz) }

        include_examples 'should pass with a positive expectation'

        include_examples 'should fail with a negative expectation'
      end # describe

      describe 'with a partially matching multiple item expectation' do
        let(:expectations)   { %w(foo wibble) }
        let(:matching_items) { %w(foo) }
        let(:missing_items)  { %w(wibble) }

        include_examples 'should fail with a positive expectation'

        include_examples 'should fail with a negative expectation'
      end # describe

      describe 'with a non-matching multiple item expectation' do
        let(:expectations) { %w(wibble wobble) }

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end # describe

      describe 'with a matching RSpec matcher expectation' do
        let(:expectations) { a_string_starting_with 'ba' }

        include_examples 'should pass with a positive expectation'

        include_examples 'should fail with a negative expectation'
      end # describe

      describe 'with a non-matching RSpec matcher expectation' do
        let(:expectations) { a_string_ending_with 'bble' }

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end # describe

      describe 'with a matching block expectation' do
        let(:expectations) { ->(str) { str =~ /ba/ } }
        let(:instance)     { described_class.new &expectations }

        include_examples 'should pass with a positive expectation'

        include_examples 'should fail with a negative expectation'
      end # describe

      describe 'with a non-matching block expectation' do
        let(:expectations) { ->(str) { str =~ /xy/ } }
        let(:instance)     { described_class.new &expectations }

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end # describe

      describe 'with a matching proc expectation' do
        let(:expectations) { ->(str) { str =~ /ba/ } }

        include_examples 'should pass with a positive expectation'

        include_examples 'should fail with a negative expectation'
      end # describe

      describe 'with a non-matching proc expectation' do
        let(:expectations) { ->(str) { str =~ /xy/ } }

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end # describe
    end # describe

    describe 'with a Hash' do
      let(:actual) do
        { :foo => 'foo', :bar => 'bar', :baz => 'baz' }
      end
      let(:actual_string) do
        hash = actual

        hash = sort_keys(hash) if Spec::RSPEC_VERSION >= '3.8.0'

        hash.inspect.gsub(/(\S)=>(\S)/, '\1 => \2')
      end

      describe 'with a matching single key expectation' do
        let(:expectations) { :foo }

        include_examples 'should pass with a positive expectation'

        include_examples 'should fail with a negative expectation'
      end # describe

      describe 'with a non-matching single key expectation' do
        let(:expectations) { :wibble }

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end # describe

      describe 'with a matching multiple key expectation' do
        let(:expectations) { [:foo, :bar] }

        include_examples 'should pass with a positive expectation'

        include_examples 'should fail with a negative expectation'
      end # describe

      describe 'with a partially matching multiple key expectation' do
        let(:expectations)   { [:foo, :wibble] }
        let(:matching_items) { [:foo] }
        let(:missing_items)  { [:wibble] }

        include_examples 'should fail with a positive expectation'

        include_examples 'should fail with a negative expectation'
      end # describe

      describe 'with a non-matching multiple key expectation' do
        let(:expectations) { [:wibble, :wobble] }

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end # describe

      describe 'with a matching single key-value expectation' do
        let(:expectations) { { :foo => 'foo' } }

        include_examples 'should pass with a positive expectation'

        include_examples 'should fail with a negative expectation'
      end # describe

      describe 'with a non-matching single key-value expectation' do
        let(:expectations) { { :wibble => 'wibble' } }

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end # describe

      describe 'with a single matching key but non-matching value expectation' do
        let(:expectations) { { :foo => 'fighters' } }

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end # describe

      describe 'with a matching multiple key-value expectation' do
        let(:expectations) { { :foo => 'foo', :baz => 'baz' } }

        include_examples 'should pass with a positive expectation'

        include_examples 'should fail with a negative expectation'
      end # describe

      describe 'with a non-matching multiple key-value expectation' do
        let(:expectations) { { :wibble => 'wibble', :wobble => 'wobble' } }

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end # describe

      describe 'with a partially matching multiple key-value expectation' do
        let(:expectations)   { { :foo => 'foo', :wibble => 'wibble' } }
        let(:matching_items) { [{ :foo => 'foo' }] }
        let(:missing_items)  { [{ :wibble => 'wibble' }] }

        include_examples 'should fail with a positive expectation'

        include_examples 'should fail with a negative expectation'
      end # describe

      describe 'with a multiple matching key but non-matching value expectation' do
        let(:expectations) { { :foo => 'fighters', :bar => 'bouncer' } }

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end # describe

      describe 'with a matching key-value expectation and a matching key but non-matching value expectation' do
        let(:expectations)   { { :foo => 'foo', :bar => 'crawl' } }
        let(:matching_items) { [{ :foo => 'foo' }] }
        let(:missing_items)  { [{ :bar => 'crawl' }] }

        include_examples 'should fail with a positive expectation'

        include_examples 'should fail with a negative expectation'
      end # describe

      describe 'with a matching block expectation' do
        let(:expectations) { ->((_, str)) { str =~ /ba/ } }
        let(:instance)     { described_class.new &expectations }

        include_examples 'should pass with a positive expectation'

        include_examples 'should fail with a negative expectation'
      end # describe

      describe 'with a non-matching block expectation' do
        let(:expectations) { ->((_, str)) { str =~ /xy/ } }
        let(:instance) { described_class.new &expectations }

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end # describe

      describe 'with a matching proc expectation' do
        let(:expectations) { ->((_, str)) { str =~ /ba/ } }

        include_examples 'should pass with a positive expectation'

        include_examples 'should fail with a negative expectation'
      end # describe

      describe 'with a non-matching proc expectation' do
        let(:expectations) { ->((_, str)) { str =~ /xy/ } }

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end # describe
    end # describe

    describe 'with a String' do
      let(:actual) { 'Cry Havoc! And let slip the dogs of war!' }

      describe 'with a matching single substring expectation' do
        let(:expectations) { 'the dogs' }

        include_examples 'should pass with a positive expectation'

        include_examples 'should fail with a negative expectation'
      end # describe

      describe 'with a non-matching single substring expectation' do
        let(:expectations) { 'the cats' }

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end # describe

      describe 'with a matching multiple substring expectation' do
        let(:expectations) { ['let slip', 'the dogs'] }

        include_examples 'should pass with a positive expectation'

        include_examples 'should fail with a negative expectation'
      end # describe

      describe 'with a partially matching multiple substring expectation' do
        let(:expectations)   { ['who let', 'the dogs'] }
        let(:matching_items) { ['the dogs'] }
        let(:missing_items)  { ['who let'] }

        include_examples 'should fail with a positive expectation'

        include_examples 'should fail with a negative expectation'
      end # describe

      describe 'with a non-matching multiple substring expectation' do
        let(:expectations) { ['unleash', 'the cats'] }

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end # describe

      describe 'with a matching block expectation' do
        let(:expectations) { ->(str) { str =~ /the (dog|cat)s of war/ } }
        let(:instance)     { described_class.new &expectations }

        include_examples 'should pass with a positive expectation'

        include_examples 'should fail with a negative expectation'
      end # describe

      describe 'with a non-matching block expectation' do
        let(:expectations) { ->(str) { str =~ /the (rabbit|sea slug)s of war/ } }
        let(:instance)     { described_class.new &expectations }

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end # describe

      describe 'with a matching proc expectation' do
        let(:expectations) { ->(str) { str =~ /the (dog|cat)s of war/ } }

        include_examples 'should pass with a positive expectation'

        include_examples 'should fail with a negative expectation'
      end # describe

      describe 'with a non-matching proc expectation' do
        let(:expectations) { ->(str) { str =~ /the (rabbit|sea slug)s of war/ } }

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end # describe
    end # describe
  end # describe
end # describe
