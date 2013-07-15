# spec/rspec/sleeping_king_studios/matchers/built_in/be_kind_of_spec.rb

require 'rspec/sleeping_king_studios/spec_helper'
require 'rspec/sleeping_king_studios/matchers/base_matcher_helpers'

require 'rspec/sleeping_king_studios/matchers/built_in/be_kind_of'

describe RSpec::SleepingKingStudios::Matchers::BuiltIn::BeAKindOfMatcher do
  include RSpec::SleepingKingStudios::Matchers::BaseMatcherHelpers

  let(:example_group) { self }
  let(:type)          { Object }
  
  specify { expect(example_group).to respond_to(:be_kind_of).with(1).arguments }
  specify { expect(example_group.be_kind_of type).to be_a described_class }

  specify { expect(example_group).to respond_to(:be_a).with(1).arguments }
  specify { expect(example_group.be_a type).to be_a described_class }

  let(:instance) { described_class.new type }

  it_behaves_like RSpec::SleepingKingStudios::Matchers::BaseMatcher

  <<-SCENARIOS
    When given nil,
      And actual is nil,
        Evaluates to true with should_not message "not to be nil".
      And actual is not nil,
        Evaluates to false with should message "to be nil".
    When given a Class,
      And actual is an instance of that class,
        Evaluates to true with should_not message "not to be a (type)".
      And actual is not an instance of that class,
        Evaluates to false with should message "to be a (type)".
    When given an array of types,
      And actual is an instance of one of the types,
        Evaluates to true with should_not message "not to be a type, type or type".
      And actual is not an instance of one of the types,
        Evalutes to false with should message "to be a type, type or type".
  SCENARIOS

  context 'with nil' do
    let(:type) { nil }

    specify 'with a nil actual' do
      expect(instance).to pass_with_actual(actual = nil).
        with_message "expected #{actual.inspect} not to be nil"
    end # specify

    specify 'with a non-nil actual' do
      expect(instance).to fail_with_actual(actual = Object.new).
        with_message "expected #{actual.inspect} to be nil"
    end # specify
  end # context

  context 'with a class' do
    let(:type) { Class.new }

    specify 'with an instance of the class' do
      expect(instance).to pass_with_actual(actual = type.new).
        with_message "expected #{actual.inspect} not to be a #{type}"
    end # specify

    specify 'with a non-instance object' do
      expect(instance).to fail_with_actual(actual = Object.new).
        with_message "expected #{actual.inspect} to be a #{type}"
    end # specify
  end

  context 'with an array of types' do
    let(:type)         { [String, Symbol, nil] }
    let(:types_string) { "#{type[0..-2].map(&:inspect).join(", ")}, or #{type.last.inspect}" }

    specify 'with an instance of an array member' do
      expect(instance).to pass_with_actual(actual = "").
        with_message "expected #{actual.inspect} not to be a #{types_string}"
    end # specify

    specify 'with a object that is not an instance of an array member' do
      expect(instance).to fail_with_actual(actual = Object.new).
        with_message "expected #{actual.inspect} to be a #{types_string}"
    end # specify
  end # context
end # describe
