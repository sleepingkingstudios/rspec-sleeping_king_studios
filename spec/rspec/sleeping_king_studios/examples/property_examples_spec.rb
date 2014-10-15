# spec/rspec/sleeping_king_studios/examples/property_examples_spec.rb

require 'rspec/sleeping_king_studios/spec_helper'

require 'rspec/sleeping_king_studios/examples/property_examples'

RSpec.describe RSpec::SleepingKingStudios::Examples::PropertyExamples do
  include described_class

  def self.property; :foo; end
  def self.value; 42; end

  let(:property) { self.class.property }
  let(:value)    { self.class.value }

  describe 'with an object responding to :property' do
    let(:instance) do
      Class.new.tap do |klass|
        klass.send :define_method, :initialize, ->(value) { @foo = value }

        klass.send :attr_reader, property
      end.new(value)
    end # let

    describe 'has reader' do
      include_examples 'has reader', property

      describe 'with a literal value' do
        include_examples 'has reader', property, value
      end # describe

      describe 'with a proc value' do
        include_examples 'has reader', property, ->() { be_a(Fixnum) }
      end # describe

      describe 'with a proc that takes an argument' do
        include_examples 'has reader', property, ->(value) { value > 0 }
      end # describe
    end # describe
  end # describe

  describe 'with an object responding to :property=' do
    let(:instance) do
      Class.new.tap do |klass|
        klass.send :attr_writer, property
      end.new
    end # let

    describe 'has writer' do
      include_examples 'has writer', property
    end # describe
  end # describe

  describe 'with an object responding to :property and :property=' do
    let(:instance) do
      Class.new.tap do |klass|
        klass.send :define_method, :initialize, ->(value) { @foo = value }

        klass.send :attr_accessor, property
      end.new(value)
    end # let

    describe 'has reader' do
      include_examples 'has reader', property

      describe 'with a literal value' do
        include_examples 'has reader', property, value
      end # describe

      describe 'with a proc value' do
        include_examples 'has reader', property, ->() { be_a(Fixnum) }
      end # describe

      describe 'with a proc that takes an argument' do
        include_examples 'has reader', property, ->(value) { value > 0 }
      end # describe
    end # describe

    describe 'has writer' do
      include_examples 'has writer', property
    end # describe

    describe 'has property' do
      include_examples 'has property', property

      describe 'with a literal value' do
        include_examples 'has property', property, value
      end # describe

      describe 'with a proc value' do
        include_examples 'has property', property, ->() { be_a(Fixnum) }
      end # describe

      describe 'with a proc that takes an argument' do
        include_examples 'has property', property, ->(value) { value > 0 }
      end # describe
    end # describe
  end # describe
end # describe
