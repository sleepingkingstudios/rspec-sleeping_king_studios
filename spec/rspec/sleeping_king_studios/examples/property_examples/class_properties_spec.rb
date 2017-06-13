# spec/rspec/sleeping_king_studios/examples/property_examples/class_properties_spec.rb

require 'spec_helper'

require 'rspec/sleeping_king_studios/examples/property_examples'

RSpec.describe RSpec::SleepingKingStudios::Examples::PropertyExamples do
  include described_class

  def self.property; :foo; end
  def self.value; 42; end

  let(:property)        { self.class.property }
  let(:value)           { self.class.value }
  let(:described_class) { Class.new }

  include_examples 'does not have class reader', property

  include_examples 'should not have class reader', property

  include_examples 'does not have class writer', property

  include_examples 'should not have class writer', property

  describe 'with a class responding to :property' do
    let(:described_class) do
      super().tap do |klass|
        property_name  = property
        property_value = value

        klass.define_singleton_method property,
          lambda {
            variable_name = "@#{property_name}"

            unless instance_variable_defined?(variable_name)
              instance_variable_set(variable_name, property_value)
            end # unless

            instance_variable_get(variable_name)
          } # lambda
      end # tap
    end # let

    describe 'should have class reader' do
      include_examples 'has class reader', property

      include_examples 'should have class reader', property

      include_examples 'does not have class writer', property

      include_examples 'should not have class writer', property

      describe 'with a literal value' do
        include_examples 'should have class reader', property, value
      end # describe

      describe 'with a proc value' do
        include_examples 'should have class reader', property, ->() { be_a(Integer) }
      end # describe

      describe 'with a proc that takes an argument' do
        include_examples 'should have class reader', property, ->(value) { value > 0 }
      end # describe
    end # describe

    describe 'should not have class writer' do
      include_examples 'does not have class writer', property

      include_examples 'should not have class writer', property
    end # describe
  end # describe

  describe 'with a class responding to :property=' do
    let(:described_class) do
      super().tap do |klass|
        property_name = property

        klass.define_singleton_method :"#{property}=",
          lambda { |property_value|
            variable_name = "@#{property_name}"

            instance_variable_set(variable_name, property_value)
          } # end lambda
      end # tap
    end # let
    let(:described_class) do
      super().tap do |klass|
        klass.singleton_class.send :attr_writer, property
      end # tap
    end # let

    describe 'should not have class reader' do
      include_examples 'does not have class reader', property

      include_examples 'should not have class reader', property
    end # describe

    describe 'should have class writer' do
      include_examples 'has class writer', property

      include_examples 'should have class writer', property
    end # describe
  end # describe

  describe 'with a class responding to :property and :property=' do
    let(:described_class) do
      super().tap do |klass|
        property_name  = property
        property_value = value

        klass.define_singleton_method property,
          lambda {
            variable_name = "@#{property_name}"

            unless instance_variable_defined?(variable_name)
              instance_variable_set(variable_name, property_value)
            end # unless

            instance_variable_get(variable_name)
          } # lambda

        klass.define_singleton_method :"#{property}=",
          lambda { |property_value|
            variable_name = "@#{property_name}"

            instance_variable_set(variable_name, property_value)
          } # end lambda
      end # tap
    end # let

    describe 'should have class reader' do
      include_examples 'has class reader', property

      include_examples 'should have class reader', property

      describe 'with a literal value' do
        include_examples 'should have class reader', property, value
      end # describe

      describe 'with a proc value' do
        include_examples 'should have class reader', property, ->() { be_a(Integer) }
      end # describe

      describe 'with a proc that takes an argument' do
        include_examples 'should have class reader', property, ->(value) { value > 0 }
      end # describe
    end # describe

    describe 'should have class writer' do
      include_examples 'has class writer', property

      include_examples 'should have class writer', property
    end # describe

    describe 'should have class property' do
      include_examples 'has class property', property

      include_examples 'should have class property', property

      describe 'with a literal value' do
        include_examples 'should have class property', property, value
      end # describe

      describe 'with a proc value' do
        include_examples 'should have class property', property, ->() { be_a(Integer) }
      end # describe

      describe 'with a proc that takes an argument' do
        include_examples 'should have class property', property, ->(value) { value > 0 }
      end # describe
    end # describe
  end # describe
end # describe
