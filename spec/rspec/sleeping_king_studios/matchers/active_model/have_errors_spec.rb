# spec/rspec/sleeping_king_studios/matchers/active_model/have_errors_spec.rb

require 'active_model'

require 'rspec/sleeping_king_studios/spec_helper'

require 'rspec/sleeping_king_studios/matchers/active_model/have_errors'

describe "have_errors matcher" do
  let(:model) do Class.new do
    include ActiveModel::Validations
    
    def initialize(params = nil)
      (params || {}).each do |key, value|
        self.send :"#{key}=", value
      end # each
    end # method initialize
    
    attr_accessor :foo, :bar, :baz
    
    validates_each :foo, :bar do |record, attr, value|
      record.errors.add attr, 'not to be nil' if value.nil?
    end # validates
    
    validates_each :foo do |record, attr, value|
      record.errors.add attr, 'to be 1s and 0s' if
        value.nil? || value != value.gsub(/[^01]/,'')
    end # validates
  end; end # class; let

  let(:example_group) { RSpec::Core::ExampleGroup.new }
  let(:instance)      { example_group.have_errors }
  
  specify { expect(example_group).to respond_to(:have_errors).with(1).arguments }

  describe "#on" do
    specify { expect(instance).to respond_to(:on).with(1).arguments }
    specify { expect(instance.on :foo).to be instance }
  end # describe

  describe "#with_message" do
    specify { expect(instance).to respond_to(:with_message).with(1).arguments }
    specify { expect { instance.with_message 'xyzzy' }.to raise_error ArgumentError,
      /no attribute specified for error message/i }
    specify { expect(instance.on(:foo).with_message 'xyzzy').to be instance }
  end # describe

  <<-SCENARIOS
    When given a non-record object,
      Evaluates to false with should message "expected to respond to valid".
    When given a valid record,
      Evaluates to false with should message "expected to have errors".
    When given an invalid record,
      And when not given an attribute,
        Evaluates to true with should_not message "expected not to have errors, but had errors hash"
      And when given an attribute with no errors,
        Evaluates to false with should message "expected to have errors on".
      And when given an attribute with errors,
        And when not given a message,
          Evaluates to true with should_not message "expected not to have errors on, but had errors on with messages")
        And when given a correct message,
          Evaluates to true with should_not message "expected not to have errors on with message"
        And when given an incorrect message,
          Evaluates to false with should message "expected to have errors on with message".
  SCENARIOS
  
  context 'with a non-record object' do
    let(:actual) { Object.new }
    
    specify { expect(instance).to fail_with_actual(actual).
      with_message "expected #{actual} to respond to :valid?" }
  end # context

  context 'with a valid record' do
    let(:actual) { model.new :foo => '10010011101', :bar => 'bar' }

    specify { expect(instance).to fail_with_actual(actual).
      with_message "expected #{actual} to have errors" }
  end # context

  context 'with an invalid record' do
    let(:actual) { model.new }
    let(:errors) { actual.tap(&:valid?).errors.messages }

    specify { expect(instance).to pass_with_actual(actual).
      with_message "expected #{actual} not to have errors\n  errors: #{errors}" }

    context 'with an attribute with no errors' do
      let(:attribute) { :baz }
      let(:instance)  { super().on(attribute) }

      specify { expect(instance).to fail_with_actual(actual).
        with_message "expected #{actual} to have errors on #{attribute.inspect}"}
    end # context

    context 'with an attribute with errors' do
      let(:attribute) { :bar }
      let(:instance) { super().on(attribute) }

      specify { expect(instance).to pass_with_actual(actual).
        with_message "expected #{actual} not to have errors on #{attribute.inspect}\n  errors: #{errors}" }

      context 'with a correct message' do
        let(:expected_error) { "not to be nil" }
        let(:instance) { super().with_message(expected_error) }
        
        specify { expect(instance).to pass_with_actual(actual).
          with_message "expected #{actual} not to have errors on #{attribute.inspect} with message \"#{expected_error}\"\n  errors: #{errors}" }
      end # context

      context 'with an incorrect message' do
        let(:expected_error) { "to be 1s and 0s" }
        let(:failure_message) do
          "expected #{actual} to have errors on #{attribute.inspect} with message \"#{expected_error}\""
        end # let
        let(:instance) { super().with_message(expected_error) }
        
        specify { expect(instance).to fail_with_actual(actual).
          with_message(failure_message) }
      end # context
    end # context
  end # context
end # describe
