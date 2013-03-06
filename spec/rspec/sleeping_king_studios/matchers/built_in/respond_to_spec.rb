# spec/rspec/sleeping_king_studios/matchers/built_in/respond_to_spec.rb

require 'rspec/sleeping_king_studios/spec_helper'

require 'rspec/sleeping_king_studios/matchers/built_in/respond_to'

describe "respond to matcher" do
  let :example_group do RSpec::Core::ExampleGroup.new; end
  
  specify { expect(example_group).to respond_to(:respond_to).with(1).arguments }
  
  let :identifier do :foo; end
  let :instance do example_group.respond_to identifier; end
  
  specify { expect(instance).to respond_to(:with).with(0..1).arguments }
  specify { expect(instance.with).to be instance }
  
  specify { expect(instance).to respond_to(:and).with(0).arguments }
  specify { expect(instance.and).to be instance }
  
  specify { expect(instance).to respond_to(:a_block).with(0).arguments }
  specify { expect(instance.a_block).to be instance }
  
  describe 'with no matching method' do
    let :actual do Class.new.new; end
    
    specify { expect(instance).to fail_with_actual(actual).
      with_message "expected #{actual.inspect} to respond to #{identifier.inspect}" }
    specify { expect(instance.with(count = 0)).to fail_with_actual(actual).
      with_message "expected #{actual.inspect} to respond to #{identifier.inspect}" }
    specify { expect(instance.with(count = 0..1)).to fail_with_actual(actual).
      with_message "expected #{actual.inspect} to respond to #{identifier.inspect}" }
    specify { expect(instance.with.a_block).to fail_with_actual(actual).
      with_message "expected #{actual.inspect} to respond to #{identifier.inspect}" }
  end # describe
  
  describe 'with a method with no arguments' do
    let :actual do
      Class.new.tap { |klass| klass.define_method identifier, &(Proc.new {}) }.new
    end # let
    
    specify { expect(instance).to pass_with_actual(actual).
      with_message "expected #{actual.inspect} not to respond to #{identifier.inspect}" }
    specify { expect(instance.with(count = 0).arguments).to pass_with_actual(actual).
      with_message "expected #{actual.inspect} not to respond to #{identifier.inspect} with #{count} arguments" }
    specify { expect(instance.with(count = 1).arguments).to fail_with_actual(actual).
      with_message "expected #{actual.inspect} to respond to #{identifier.inspect} with #{count} argument" }
    specify { expect(instance.with(count = 0..1)).to fail_with_actual(actual).
      with_message "expected #{actual.inspect} to respond to #{identifier.inspect} with #{count} arguments" }
    specify { expect(instance.with.a_block).to fail_with_actual(actual).
      with_message "expected #{actual.inspect} to respond to #{identifier.inspect} with a block" }
  end # describe
  
  describe 'with a method with required arguments' do
    let :actual do
      Class.new.tap { |klass| klass.define_method identifier, &(Proc.new { |a, b, c| }) }.new
    end # let
    
    specify { expect(instance).to pass_with_actual(actual).
      with_message "expected #{actual.inspect} not to respond to #{identifier.inspect}" }
    specify { expect(instance.with(count = 0).arguments).to fail_with_actual(actual).
      with_message "expected #{actual.inspect} to respond to #{identifier.inspect} with #{count} arguments" }
    specify { expect(instance.with(count = 1).arguments).to fail_with_actual(actual).
      with_message "expected #{actual.inspect} to respond to #{identifier.inspect} with #{count} argument" }
    specify { expect(instance.with(count = 3).arguments).to pass_with_actual(actual).
      with_message "expected #{actual.inspect} not to respond to #{identifier.inspect} with #{count} arguments" }
    specify { expect(instance.with(count = 4).arguments).to fail_with_actual(actual).
      with_message "expected #{actual.inspect} to respond to #{identifier.inspect} with #{count} arguments" }
    specify { expect(instance.with(count = 0..1)).to fail_with_actual(actual).
      with_message "expected #{actual.inspect} to respond to #{identifier.inspect} with #{count} arguments" }
    specify { expect(instance.with.a_block).to fail_with_actual(actual).
      with_message "expected #{actual.inspect} to respond to #{identifier.inspect} with a block" }
  end # describe
  
  describe 'with a method with optional arguments' do
    let :actual do
      Class.new.tap { |klass| klass.define_method identifier, &(Proc.new { |a, b, c = nil, d = nil| }) }.new
    end # let

    specify { expect(instance).to pass_with_actual(actual).
      with_message "expected #{actual.inspect} not to respond to #{identifier.inspect}" }
    specify { expect(instance.with(count = 0).arguments).to fail_with_actual(actual).
      with_message "expected #{actual.inspect} to respond to #{identifier.inspect} with #{count} arguments" }
    specify { expect(instance.with(count = 1).arguments).to fail_with_actual(actual).
      with_message "expected #{actual.inspect} to respond to #{identifier.inspect} with #{count} argument" }
    specify { expect(instance.with(count = 3).arguments).to pass_with_actual(actual).
      with_message "expected #{actual.inspect} not to respond to #{identifier.inspect} with #{count} arguments" }
    specify { expect(instance.with(count = 4).arguments).to pass_with_actual(actual).
      with_message "expected #{actual.inspect} not to respond to #{identifier.inspect} with #{count} arguments" }
    specify { expect(instance.with(count = 5).arguments).to fail_with_actual(actual).
      with_message "expected #{actual.inspect} to respond to #{identifier.inspect} with #{count} arguments" }
    specify { expect(instance.with(count = 0..1)).to fail_with_actual(actual).
      with_message "expected #{actual.inspect} to respond to #{identifier.inspect} with #{count} arguments" }
    specify { expect(instance.with(count = 3..4)).to pass_with_actual(actual).
      with_message "expected #{actual.inspect} not to respond to #{identifier.inspect} with #{count} arguments" }
    specify { expect(instance.with.a_block).to fail_with_actual(actual).
      with_message "expected #{actual.inspect} to respond to #{identifier.inspect} with a block" }
  end # describe
  
  describe 'with a method with variadic arguments' do
    let :actual do
      Class.new.tap { |klass| klass.define_method identifier, &(Proc.new { |a, b, *c| }) }.new
    end # let
    
    specify { expect(instance).to pass_with_actual(actual).
      with_message "expected #{actual.inspect} not to respond to #{identifier.inspect}" }
    specify { expect(instance.with(count = 0).arguments).to fail_with_actual(actual).
      with_message "expected #{actual.inspect} to respond to #{identifier.inspect} with #{count} arguments" }
    specify { expect(instance.with(count = 1).arguments).to fail_with_actual(actual).
      with_message "expected #{actual.inspect} to respond to #{identifier.inspect} with #{count} argument" }
    specify { expect(instance.with(count = 2).arguments).to pass_with_actual(actual).
      with_message "expected #{actual.inspect} not to respond to #{identifier.inspect} with #{count} arguments" }
    specify { expect(instance.with(count = 10).arguments).to pass_with_actual(actual).
      with_message "expected #{actual.inspect} not to respond to #{identifier.inspect} with #{count} arguments" }
    specify { expect(instance.with(count = 0..1)).to fail_with_actual(actual).
      with_message "expected #{actual.inspect} to respond to #{identifier.inspect} with #{count} arguments" }
    specify { expect(instance.with(count = 2..10)).to pass_with_actual(actual).
      with_message "expected #{actual.inspect} not to respond to #{identifier.inspect} with #{count} arguments" }
    specify { expect(instance.with.a_block).to fail_with_actual(actual).
      with_message "expected #{actual.inspect} to respond to #{identifier.inspect} with a block" }
  end # describe
  
  describe 'with a method with a block argument' do
    let :actual do
      Class.new.tap { |klass| klass.define_method identifier, &(Proc.new { |&a| }) }.new
    end # let
    
    specify { expect(instance).to pass_with_actual(actual).
      with_message "expected #{actual.inspect} not to respond to #{identifier.inspect}" }
    specify { expect(instance.with(count = 0).arguments).to pass_with_actual(actual).
      with_message "expected #{actual.inspect} not to respond to #{identifier.inspect} with #{count} arguments" }
    specify { expect(instance.with(count = 1).arguments).to fail_with_actual(actual).
      with_message "expected #{actual.inspect} to respond to #{identifier.inspect} with #{count} argument" }
    specify { expect(instance.with(count = 0..1)).to fail_with_actual(actual).
      with_message "expected #{actual.inspect} to respond to #{identifier.inspect} with #{count} arguments" }
    specify { expect(instance.with.a_block).to pass_with_actual(actual).
      with_message "expected #{actual.inspect} not to respond to #{identifier.inspect} with a block" }
  end # describe
end # describe
