# spec/rspec/sleeping_king_studios/examples/property_examples/constants_spec.rb

require 'spec_helper'

require 'rspec/sleeping_king_studios/examples/property_examples'

RSpec.describe RSpec::SleepingKingStudios::Examples::PropertyExamples do
  include described_class

  def self.constant; :THE_ANSWER; end
  def self.value; 42; end

  let(:constant) { self.class.constant }
  let(:value)    { self.class.value }
  let(:described_class) do
    Class.new.tap do |klass|
      klass.send :define_method, :initialize, ->(value) { @foo = value }
    end # class
  end # let
  let(:instance) { described_class.new(value) }

  describe 'with an object whose class defines constant :CONSTANT' do
    let(:described_class) do
      super().tap do |klass|
        klass.send :const_set, constant, value
      end # tap
    end # let

    describe 'should have constant' do
      include_examples 'should have constant', constant
    end # describe

    describe 'with an immutable constant' do
      let(:value) { 'string'.freeze }

      include_examples 'should have immutable constant', constant
    end # describe
  end # describe
end # describe
