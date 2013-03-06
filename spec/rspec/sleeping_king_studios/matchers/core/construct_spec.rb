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
  
  describe 'with a non-class object' do
    let :actual do Object.new; end
    
    specify { expect(instance).to fail_with_actual(actual).
      with_message(/expected #{actual.inspect} to initialize/) }
  end # describe
  
  describe 'with a class with no arguments' do
    let :actual do Class.new; end
    
    specify { expect(instance).to pass_with_actual(actual).
      with_message(/expected #{actual.inspect} not to initialize/) }
    
    specify { expect(instance.with(0).arguments ).to pass_with_actual(actual).
      with_message(/expected #{actual.inspect} not to initialize with 0 arguments/) }
    
    specify { expect(instance.with(1).arguments ).to fail_with_actual(actual).
      with_message(/expected #{actual.inspect} to initialize with 1 argument/) }
  end # describe
  
  describe 'with a class with multiple arguments' do
    let :actual do Class.new do def initialize a, b, c = nil; end; end; end
    
    specify { expect(instance).to pass_with_actual(actual).
      with_message(/expected #{actual.inspect} not to initialize/) }
    
    specify { expect(instance.with(2).arguments ).to pass_with_actual(actual).
      with_message(/expected #{actual.inspect} not to initialize with 2 arguments/) }
    
    specify { expect(instance.with(3).arguments ).to pass_with_actual(actual).
      with_message(/expected #{actual.inspect} not to initialize with 3 arguments/) }
    
    specify { expect(instance.with(2..3).arguments ).to pass_with_actual(actual).
      with_message(/expected #{actual.inspect} not to initialize with 2..3 arguments/) }
    
    specify { expect(instance.with(0).arguments ).to fail_with_actual(actual).
      with_message(/expected #{actual.inspect} to initialize with 0 arguments/) }
    
    specify { expect(instance.with(1).arguments ).to fail_with_actual(actual).
      with_message(/expected #{actual.inspect} to initialize with 1 argument/) }
    
    specify { expect(instance.with(4).arguments ).to fail_with_actual(actual).
      with_message(/expected #{actual.inspect} to initialize with 4 arguments/) }
    
    specify { expect(instance.with(0..3).arguments ).to fail_with_actual(actual).
      with_message(/expected #{actual.inspect} to initialize with 0..3 arguments/) }
    
    specify { expect(instance.with(2..4).arguments ).to fail_with_actual(actual).
      with_message(/expected #{actual.inspect} to initialize with 2..4 arguments/) }
  end # describe
end # describe
