# spec/rspec/sleeping_king_studios/matchers/rspec/pass_with_actual_spec.rb

require 'rspec/sleeping_king_studios/spec_helper'

require 'rspec/sleeping_king_studios/matchers/rspec/pass_with_actual'

describe "pass with actual matcher" do
  let :example_group do RSpec::Core::ExampleGroup.new; end
  
  specify { expect(example_group).to respond_to(:pass_with_actual).with(1).arguments }
  
  let :actual do nil; end
  let :matcher do example_group.be_true; end
  let :instance do example_group.pass_with_actual actual; end
  
  specify { expect(instance).to respond_to(:with_message).with(1).arguments }
  specify { expect(instance.with_message "").to be instance }
  
  context 'with true' do
    let :actual do true; end
    
    specify { expect(instance.matches? matcher).to be true }
    specify 'failure message' do
      instance.matches? matcher
      expect(instance.failure_message_for_should_not).
        to eq "expected #{matcher} not to match #{actual}"
    end # specify
    
    context 'with invalid string message' do
      let :message do "expected power level to be <= 9000"; end
      let :instance do super().with_message message; end
      
      specify { expect(instance.matches? matcher).to be false }
      specify 'failure message' do
        instance.matches? matcher
        expect(instance.failure_message_for_should).to eq "expected" +
          " #{matcher} to match #{actual} with message:\nexpected:" +
          " \"#{message}\"\nreceived: \"expected: non-true value\n" +
          "     got: true\""
      end # specify
    end # context
    
    context 'with valid string message' do
      let :message do "expected: non-true value\n     got: true"; end
      let :instance do super().with_message message; end
      
      specify { expect(instance.matches? matcher).to be true }
      specify 'failure message' do
        instance.matches? matcher
        expect(instance.failure_message_for_should_not).to eq "expected #{matcher} not to match #{actual}"
      end # specify
    end # context
    
    context 'with valid regexp message' do
      let :message do /expected: non-true value/i; end
      let :instance do super().with_message message; end
      
      specify { expect(instance.matches? matcher).to be true }
      specify 'failure message' do
        instance.matches? matcher
        expect(instance.failure_message_for_should_not).to eq "expected #{matcher} not to match #{actual}"
      end # specify
    end # context
  end # let
  
  context 'with false' do
    let :actual do false; end
    
    specify { expect(instance.matches? matcher).to be false }
    specify 'failure message' do
      instance.matches? matcher
      expected_message = "expected #{matcher} to match #{actual}"
      expect(instance.failure_message_for_should).to eq expected_message
    end # specify
  end # context
end # describe
