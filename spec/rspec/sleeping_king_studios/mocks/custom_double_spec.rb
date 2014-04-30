# spec/rspec/sleeping_king_studios/mocks/custom_double_spec.rb

require 'rspec/sleeping_king_studios/spec_helper'
require 'rspec/sleeping_king_studios/matchers/built_in/respond_to'

require 'rspec/sleeping_king_studios/mocks/custom_double'

describe '#custom_double' do
  let(:example_group) { self }

  specify do
    expect(example_group).to respond_to(:custom_double).with(0..9001).arguments.with_a_block
  end # specify

  <<-SCENARIOS
    When created with stubs,
      Responds to those messages with the specified values.
    When created with a block,
      And the block contains a property definition,
        Responds to :property and :property= with appropriate values.
        And the custom double acts as a null object,
          Updates :property when invoking :property=.
      And the block contains a method definition,
        Responds to that message with the specified value.
    When acts as null object,
      Responds to any message.
  SCENARIOS

  describe 'with stubs' do
    let(:name)  { "Custom Double" }
    let(:stubs) { { :foo => "foo", :bar => "bar" } }
    subject(:custom) { custom_double(name, stubs) }

    describe '#foo' do
      specify { expect(custom).to respond_to(:foo) }
      specify { expect(custom.foo).to be == "foo" }
    end # describe

    describe '#bar' do
      specify { expect(custom).to respond_to(:bar) }
      specify { expect(custom.bar).to be == "bar" }
    end # describe
  end # describe

  describe 'with a block' do
    let(:name)  { "Custom Double" }
    let(:block) { Proc.new {} }
    subject(:custom) { custom_double(name, {}, &block) }

    describe 'with a property definition' do
      let(:block) do
        Proc.new do
          attr_accessor :foo
        end # proc
      end # let

      describe '#foo' do
        specify { expect(custom).to respond_to(:foo) }
        specify { expect(custom.foo).to be nil }
      end # describe

      describe '#foo=' do
        specify { expect(custom).to respond_to(:foo=) }
        specify 'sets the value' do
          custom.foo = "foo"
          expect(custom.foo).to be == "foo"
        end # specify
      end # describe

      describe 'as a null object' do
        let(:custom) { super().as_null_object }

        describe '#foo=' do
          specify 'sets the value' do
            custom.foo = "foo"
            expect(custom.foo).to be == "foo"
          end # specify
        end # describe
      end # describe
    end # describe

    describe 'with a method definition' do
      let(:block) do
        Proc.new do
          def triple string
            "#{string} #{string} #{string}"
          end # method triple
        end # proc
      end # let

      describe '#triple' do
        specify { expect(custom).to respond_to(:triple) }
        specify { expect(custom.triple "foo").to be == "foo foo foo" }
      end # describe
    end # describe

    describe 'as a null object' do
      let(:custom) { super().as_null_object }

      describe '#baz' do
        specify { expect(custom).to respond_to(:baz) }
      end # describe
    end # describe
  end # describe
end # describe
