# spec/rspec/sleeping_king_studios/matchers/core/construct_spec.rb

require 'rspec/sleeping_king_studios/spec_helper'

require 'rspec/sleeping_king_studios/matchers/core/construct'

describe "construct matcher" do
  let :example_group do RSpec::Core::ExampleGroup.new; end
  
  specify { expect(example_group).to respond_to(:construct).with(0).arguments }
  
  let :instance do example_group.construct; end
  
  specify { expect(instance).to respond_to(:with).with(1).arguments }
  specify { expect(instance.with(5)).to be instance }
  
  specify { expect(instance).to respond_to(:arguments).with(0).arguments }
  specify { expect(instance.arguments).to be instance }
  
  def self.matches_helper actual, matches, argc
    context do
      let :instance do super().with(argc).arguments; end unless argc.nil?
      let :arguments do
        argc.nil? ? '' : " with #{argc} argument#{1 == argc ? '' : 's'}"
      end # let
    
      specify { expect(instance.matches? actual).to be matches }
    
      if matches
        specify 'failure message' do
          instance.matches? actual
          expect(instance.failure_message_for_should_not)
            .to match /expected #{actual.inspect} not to initialize#{arguments}/
        end # specify
      else
        specify 'failure message' do
          instance.matches? actual
          expect(instance.failure_message_for_should)
            .to match /expected #{actual.inspect} to initialize#{arguments}/
        end # specify
      end # if-else
    end # context
  end # method matches_helper
  
  def self.expect_to_match actual, argc = nil
    matches_helper actual, true, argc
  end # method expect_actual_to_match

  def self.expect_not_to_match actual, argc = nil
    matches_helper actual, false, argc
  end # method expect_actual_not_to_match
  
  describe 'with a non-class object' do
    def self.actual; Object.new; end
    
    expect_not_to_match actual
  end # describe
  
  describe 'with a class with no arguments' do
    def self.actual; Class.new; end
    
    expect_to_match actual
    expect_to_match actual, 0
    expect_not_to_match actual, 1
  end # describe
  
  describe 'with a class with multiple arguments' do
    def self.actual; Class.new do def initialize a, b, c = nil; end; end; end
    
    expect_to_match actual
    expect_to_match actual, 2
    expect_to_match actual, 3
    expect_to_match actual, 2..3
    
    expect_not_to_match actual, 0
    expect_not_to_match actual, 1
    expect_not_to_match actual, 4
    expect_not_to_match actual, 0..3
    expect_not_to_match actual, 2..4
  end # describe
end # describe
