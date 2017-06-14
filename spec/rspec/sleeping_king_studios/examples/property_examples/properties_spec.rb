# spec/rspec/sleeping_king_studios/examples/property_examples/properties_spec.rb

require 'spec_helper'

require 'rspec/sleeping_king_studios/examples/property_examples'

RSpec.describe RSpec::SleepingKingStudios::Examples::PropertyExamples do
  include described_class

  def self.property; :foo; end
  def self.value; 42; end

  let(:property) { self.class.property }
  let(:value)    { self.class.value }
  let(:described_class) do
    Class.new.tap do |klass|
      klass.send :define_method, :initialize, ->(value) { @foo = value }
    end # class
  end # let
  let(:instance) { described_class.new(value) }

  include_examples 'does not have reader', property

  include_examples 'should not have reader', property

  include_examples 'does not have writer', property

  include_examples 'should not have writer', property

  describe 'with an object responding to :property' do
    let(:described_class) do
      super().tap do |klass|
        klass.send :attr_reader, property
      end # tap
    end # let

    describe 'should have reader' do
      include_examples 'has reader', property

      include_examples 'should have reader', property

      describe 'with a literal value' do
        include_examples 'should have reader', property, value
      end # describe

      describe 'with a proc value' do
        include_examples 'should have reader', property, ->() { be_a(Integer) }
      end # describe

      describe 'with a proc that takes an argument' do
        include_examples 'should have reader', property, ->(value) { value > 0 }
      end # describe
    end # describe

    describe 'should not have writer' do
      include_examples 'does not have writer', property

      include_examples 'should not have writer', property
    end # describe
  end # describe

  describe 'with an object responding to :property=' do
    let(:described_class) do
      super().tap do |klass|
        klass.send :attr_writer, property
      end # tap
    end # let

    describe 'should not have reader' do
      include_examples 'does not have reader', property

      include_examples 'should not have reader', property
    end # describe

    describe 'should have writer' do
      include_examples 'has writer', property

      include_examples 'should have writer', property
    end # describe
  end # describe

  describe 'with an object responding to :property and :property=' do
    let(:described_class) do
      super().tap do |klass|
        klass.send :attr_accessor, property
      end # tap
    end # let

    describe 'should have reader' do
      let(:the_answer) { 42 }

      include_examples 'has reader', property

      include_examples 'should have reader', property

      describe 'with a literal value' do
        include_examples 'should have reader', property, value
      end # describe

      describe 'with a proc value' do
        include_examples 'should have reader', property, ->() { be_a(Integer) }
      end # describe

      describe 'with a proc that takes an argument' do
        include_examples 'should have reader', property, ->(value) { value == the_answer }
      end # describe
    end # describe

    describe 'should have writer' do
      include_examples 'has writer', property

      include_examples 'should have writer', property
    end # describe

    describe 'should have property' do
      include_examples 'has property', property

      include_examples 'should have property', property

      describe 'with a literal value' do
        include_examples 'should have property', property, value
      end # describe

      describe 'with a proc value' do
        include_examples 'should have property', property, ->() { be_a(Integer) }
      end # describe

      describe 'with a proc that takes an argument' do
        include_examples 'should have property', property, ->(value) { value > 0 }
      end # describe
    end # describe
  end # describe
end # describe
