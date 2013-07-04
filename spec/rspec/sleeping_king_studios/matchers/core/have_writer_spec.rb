# spec/rspec/sleeping_king_studios/matchers/core/have_writer_spec.rb

require 'rspec/sleeping_king_studios/spec_helper'

require 'rspec/sleeping_king_studios/matchers/core/have_writer'

describe "have writer matcher" do
  let :example_group do RSpec::Core::ExampleGroup.new; end
  
  specify { expect(example_group).to respond_to(:have_mutator).with(1).arguments }
  
  let :property do :foo; end
  let :instance do example_group.have_mutator property; end
  
  specify { expect(instance).to respond_to(:with).with(1).arguments }
  specify { expect(instance.with 5).to be instance }
  
  describe 'with a non-compliant object' do
    let :actual do Object.new; end
    
    specify { expect(instance).to fail_with_actual(actual).
      with_message("expected #{actual} to have mutator #{property}=") }
  end # describe

  describe 'with a compliant object' do
    let :value do "foo"; end
    let :actual do
      klass = Class.new do
        attr_reader :foo
        def foo= value; @foo = value.downcase; end
      end # anonymous class
      klass.new
    end # let

    specify { expect(instance).to pass_with_actual(actual).
      with_message("expected #{actual} not to have mutator #{property}=") }

    specify { expect(instance.with(value)).to pass_with_actual(actual).
      with_message("expected #{actual}.#{property} = #{value.inspect} not to set #{actual}.#{property}") }

    specify { expect(instance.with("FOO")).to fail_with_actual(actual).
      with_message("expected #{actual}.#{property} = \"FOO\" to set #{actual}.#{property}") }
  end # describe
end # describe
