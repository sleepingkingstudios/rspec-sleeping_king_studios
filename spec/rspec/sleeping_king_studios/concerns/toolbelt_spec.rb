# spec/rspec/sleeping_king_studios/concerns/toolbelt_spec.rb

require 'spec_helper'

require 'rspec/sleeping_king_studios/concerns/toolbelt'

RSpec.describe RSpec::SleepingKingStudios::Concerns::Toolbelt do
  let(:described_class) do
    Class.new do
      include RSpec::SleepingKingStudios::Concerns::Toolbelt
    end # let
  end # let
  let(:instance) { described_class.new }

  describe '::tools' do
    it { expect(described_class).to respond_to(:tools).with(0).arguments }

    it 'should be a toolbelt' do
      tools = described_class.tools
      klass = Kernel.instance_method(:class).bind(tools).call

      expect(klass).to be SleepingKingStudios::Tools::Toolbelt
    end # it
  end # describe

  describe '#tools' do
    it { expect(instance).to respond_to(:tools).with(0).arguments }

    it { expect(instance.tools).to equal described_class.tools }

    it 'should be a toolbelt' do
      tools = instance.tools
      klass = Kernel.instance_method(:class).bind(tools).call

      expect(klass).to be SleepingKingStudios::Tools::Toolbelt
    end # it
  end # describe
end # describe
