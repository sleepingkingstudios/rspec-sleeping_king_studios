# spec/rspec/sleeping_king_studios/matchers/core/include_matching_spec.rb

require 'rspec/sleeping_king_studios/spec_helper'

require 'rspec/sleeping_king_studios/matchers/core/include_matching'

describe "include matching matcher" do
  let :example_group do RSpec::Core::ExampleGroup.new; end
  
  specify { expect(example_group).to respond_to(:include_matching).with(1).arguments }
  
  let :pattern do /[01]+/; end
  let :instance do example_group.include_matching pattern; end
  
  describe 'with a non-enumerable object' do
    let :actual do Object.new; end
    
    specify { expect(instance).to fail_with_actual(actual).
      with_message "expected #{actual} to be enumerable" }
  end # describe
  
  describe 'with a non-matching enumerable' do
    let :actual do %w(foo bar baz); end
    
    specify { expect(instance).to fail_with_actual(actual).
      with_message "expected #{actual} to include an item matching #{pattern.inspect}" }
  end # describe
  
  describe 'with a matching enumerable' do
    let :actual do %w(zero one 1011); end
    
    specify { expect(instance).to pass_with_actual(actual).
      with_message "expected #{actual} not to include an item matching #{pattern.inspect}" }
  end # describe
end # describe
