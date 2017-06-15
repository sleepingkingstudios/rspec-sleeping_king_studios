# spec/rspec/sleeping_king_studios/examples/property_examples/private_properties_spec.rb

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

  describe 'with an object with private #property method' do
    let(:described_class) do
      super().tap do |klass|
        klass.send :attr_reader, property

        klass.send :private, property
      end # tap
    end # let

    include_examples 'has private reader', property

    include_examples 'should have private reader', property

    include_examples 'has private reader', property, value

    include_examples 'should have private reader', property, value
  end # describe

  describe 'with an object with private #property= method' do
    let(:described_class) do
      super().tap do |klass|
        klass.send :attr_writer, property

        klass.send :private, :"#{property}="
      end # tap
    end # let

    include_examples 'has private writer', property

    include_examples 'should have private writer', property
  end # describe

  describe 'with an object with private #property and #property= methods' do
    let(:described_class) do
      super().tap do |klass|
        klass.send :attr_accessor, property

        klass.send :private, property
        klass.send :private, :"#{property}="
      end # tap
    end # let

    describe 'should have private reader' do
      include_examples 'has private reader', property

      include_examples 'should have private reader', property

      include_examples 'has private reader', property, value

      include_examples 'should have private reader', property, value
    end # describe

    describe 'should have private writer' do
      include_examples 'has private writer', property

      include_examples 'should have private writer', property
    end # describe

    describe 'should have private property' do
      include_examples 'has private reader', property

      include_examples 'should have private property', property

      include_examples 'has private reader', property, value

      include_examples 'should have private reader', property, value
    end # describe
  end # describe
end # describe
