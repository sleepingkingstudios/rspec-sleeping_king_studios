# spec/rspec/sleeping_king_studios/matchers/built_in/be_kind_of_spec.rb

require 'rspec/sleeping_king_studios/spec_helper'

require 'rspec/sleeping_king_studios/matchers/built_in/be_kind_of'

describe "be kind of matcher" do
  let :example_group do RSpec::Core::ExampleGroup.new; end
  
  specify { expect(example_group).to respond_to(:be_kind_of).with(1).arguments }
  
  let :type do Object; end
  let :instance do example_group.be_kind_of type; end
  
  describe 'with nil' do
    let :type do nil; end
    
    specify { expect(instance).to pass_with_actual(actual = nil).
      with_message "expected #{actual.inspect} not to be nil" }
    specify { expect(instance).to fail_with_actual(actual = Object.new).
        with_message "expected #{actual.inspect} to be nil" }
  end # describe
  
  describe 'with a class' do
    let :type do Class.new; end
    
    specify { expect(instance).to pass_with_actual(actual = type.new).
      with_message "expected #{actual.inspect} not to be a #{type}" }
    specify { expect(instance).to fail_with_actual(actual = Object.new).
        with_message "expected #{actual.inspect} to be a #{type}" }
  end # describe
  
  describe 'with an array of types' do
    let :type do [String, Symbol, nil]; end
    
    specify { expect(instance).to pass_with_actual(actual = "").
      with_message "expected #{actual.inspect} not to be a #{type}" }
    specify { expect(instance).to pass_with_actual(actual = :"").
      with_message "expected #{actual.inspect} not to be a #{type}" }
    specify { expect(instance).to pass_with_actual(actual = nil).
      with_message "expected #{actual.inspect} not to be a #{type}" }
    specify { expect(instance).to fail_with_actual(actual = Object.new).
      with_message "expected #{actual.inspect} to be a #{type}" }
  end # describe
end # describe
