# spec/rspec/sleeping_king_studios/matchers/active_model/have_errors_spec.rb

require 'active_model'

require 'rspec/sleeping_king_studios/spec_helper'

require 'rspec/sleeping_king_studios/matchers/active_model/have_errors'

describe "have_errors matcher" do
  let :example_group do RSpec::Core::ExampleGroup.new; end
  
  specify { expect(example_group).to respond_to(:have_errors).with(1).arguments }
  
  let :instance do example_group.have_errors; end
  
  specify { expect(instance).to respond_to(:on).with(1).arguments }
  specify { expect(instance.on :foo).to be instance }
  
  specify { expect(instance).to respond_to(:with_message).with(1).arguments }
  specify { expect { instance.with_message 'xyzzy' }.to raise_error ArgumentError,
    /no attribute specified for error message/i }
  specify { expect(instance.on(:foo).with_message 'xyzzy').to be instance }
  
  context 'with a non-record object' do
    let :actual do Object.new; end
    
    specify { expect(instance).to fail_with_actual(actual).
      with_message "expected #{actual} to respond to :valid?" }
  end # context
  
  let :model do Class.new do
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
  
  context 'with a valid record' do
    let :actual do model.new :foo => '10010011101', :bar => 'bar'; end
    
    specify { expect(instance).to fail_with_actual(actual).
      with_message "expected #{actual} to have errors" }
    
    specify { expect(instance.on :foo).to fail_with_actual(actual).
      with_message "expected #{actual} to have errors on :foo" }
    specify { expect(instance.on :bar).to fail_with_actual(actual).
      with_message "expected #{actual} to have errors on :bar" }
    specify { expect(instance.on :baz).to fail_with_actual(actual).
      with_message "expected #{actual} to have errors on :baz" }
    
    specify { expect(instance.on(:foo).with_message "xyzzy").to fail_with_actual(actual).
      with_message "expected #{actual} to have errors on :foo with message \"xyzzy\"" }
    specify { expect(instance.on(:bar).with_message "xyzzy").to fail_with_actual(actual).
      with_message "expected #{actual} to have errors on :bar with message \"xyzzy\"" }
    specify { expect(instance.on(:baz).with_message "xyzzy").to fail_with_actual(actual).
      with_message "expected #{actual} to have errors on :baz with message \"xyzzy\"" }
  end # context
  
  context 'with an invalid record' do
    let :actual do model.new; end
    
    specify { expect(instance).to pass_with_actual(actual).
      with_message "expected #{actual} not to have errors" }
    
    specify { expect(instance.on :foo).to pass_with_actual(actual).
      with_message "expected #{actual} not to have errors on :foo" }
    specify { expect(instance.on(:foo).with_message(message = 'not to be nil')).
      to pass_with_actual(actual).
      with_message "expected #{actual} not to have errors on :foo" +
      " with message #{message.inspect}" }
    specify { expect(instance.on(:foo).with_message(message = 'to be 1s and 0s')).
      to pass_with_actual(actual).
      with_message "expected #{actual} not to have errors on :foo" +
      " with message #{message.inspect}" }
    
    specify { expect(instance.on :bar).to pass_with_actual(actual).
      with_message "expected #{actual} not to have errors on :bar" }
    specify { expect(instance.on(:bar).with_message(message = 'not to be nil')).
      to pass_with_actual(actual).
      with_message "expected #{actual} not to have errors on :bar" +
      " with message #{message.inspect}" }
    specify { expect(instance.on(:bar).with_message(message = 'to be 1s and 0s')).
      to fail_with_actual(actual).
      with_message "expected #{actual} to have errors on :bar" +
      " with message #{message.inspect}" }
    
    specify { expect(instance.on :baz).to fail_with_actual(actual).
      with_message "expected #{actual} to have errors on :baz" }
    specify { expect(instance.on(:baz).with_message(message = 'not to be nil')).
      to fail_with_actual(actual).
      with_message "expected #{actual} to have errors on :baz" +
      " with message #{message.inspect}" }
    specify { expect(instance.on(:baz).with_message(message = 'to be 1s and 0s')).
      to fail_with_actual(actual).
      with_message "expected #{actual} to have errors on :baz" +
      " with message #{message.inspect}" }
  end # context
end # describe