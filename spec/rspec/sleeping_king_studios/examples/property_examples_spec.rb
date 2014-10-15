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
