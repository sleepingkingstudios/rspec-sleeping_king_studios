# spec/rspec/sleeping_king_studios/matchers/core/have_accessor_spec.rb

require 'rspec/sleeping_king_studios/spec_helper'

require 'rspec/sleeping_king_studios/matchers/core/have_accessor'

describe "have accessor matcher" do
  let :example_group do RSpec::Core::ExampleGroup.new; end
  
  specify { expect(example_group).to respond_to(:have_accessor).with(1).arguments }
  
  let :property do :foo; end
  let :instance do example_group.have_accessor property; end
  
  specify { expect(instance).to respond_to(:with).with(1).arguments }
  specify { expect(instance.with 5).to be instance }
  
  describe 'with a non-compliant object' do
    let :actual do Object.new; end
    
    specify { expect(instance).to fail_with_actual(actual).
      with_message("expected #{actual} to have accessor #{property}") }
  end # describe
  
  describe 'with a compliant object' do
    let :value do "foo"; end
    let :actual do
      klass = Class.new do def foo; "foo"; end; end
      klass.new
    end # let
    
    specify { expect(instance).to pass_with_actual(actual).
      with_message("expected #{actual} not to have accessor #{property}") }
    
    specify { expect(instance.with(value)).to pass_with_actual(actual).
      with_message("expected #{actual}.#{property} not to be #{value.inspect}") }
    
    specify { expect(instance.with("bar")).to fail_with_actual(actual).
      with_message("expected #{actual}.#{property} to be \"bar\"") }
  end # describe
end # describe
