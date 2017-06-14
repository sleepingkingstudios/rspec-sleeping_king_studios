# spec/rspec/sleeping_king_studios/examples/property_examples/predicates_spec.rb

require 'spec_helper'

require 'rspec/sleeping_king_studios/examples/property_examples'
require 'rspec/sleeping_king_studios/matchers/core/be_boolean'

RSpec.describe RSpec::SleepingKingStudios::Examples::PropertyExamples do
  include described_class

  def self.predicate; :"#{property}?"; end
  def self.property; :foo; end
  def self.value; 42; end

  let(:predicate) { self.class.predicate }
  let(:property)  { self.class.property }
  let(:value)     { self.class.value }
  let(:described_class) do
    Class.new.tap do |klass|
      klass.send :define_method, :initialize, ->(value) { @foo = value }
    end # class
  end # let
  let(:instance) { described_class.new(value) }

  describe 'with an object responding to :property?' do
    let(:described_class) do
      super().tap do |klass|
        property_name = property

        klass.send :define_method, predicate do
          !!instance_variable_get(:"@#{property_name}")
        end # define_method
      end # tap
    end # let

    describe 'should have predicate' do
      include_examples 'has predicate', property

      include_examples 'should have predicate', property

      include_examples 'has predicate', predicate

      include_examples 'should have predicate', predicate

      describe 'with a literal value' do
        include_examples 'should have predicate', property, true

        include_examples 'should have predicate', predicate, true
      end # describe

      describe 'with a proc value' do
        include_examples 'should have predicate', property, ->() { a_boolean }

        include_examples 'should have predicate', predicate, ->() { a_boolean }
      end # describe

      describe 'with a proc that takes an argument' do
        include_examples 'should have predicate', property, ->(value) { value == true }

        include_examples 'should have predicate', predicate, ->(value) { value == true }
      end # describe
    end # describe
  end # describe
end # describe
