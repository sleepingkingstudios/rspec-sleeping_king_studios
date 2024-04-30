# frozen_string_literal: true

require 'spec_helper'

require 'rspec/sleeping_king_studios/configuration'

require 'rspec/sleeping_king_studios/matchers/built_in/respond_to'
require 'rspec/sleeping_king_studios/matchers/core/construct'

RSpec.describe RSpec::SleepingKingStudios::Configuration do
  subject(:instance) { described_class.new }

  describe '::new' do
    it { expect(described_class).to be_constructible.with(0).arguments }
  end

  describe '#examples' do
    it 'should define the method' do
      expect(instance).to respond_to(:examples).with(0).arguments.and_a_block
    end

    it 'should return the examples configuration' do
      expect(instance.examples).to be_a(described_class::Examples)
    end

    it 'should yield the example configuration' do
      expect { |block| instance.examples(&block) }
        .to yield_with_args(instance.examples)
    end
  end

  describe '#matchers' do
    it 'should define the method' do
      expect(instance).to respond_to(:matchers).with(0).arguments.and_a_block
    end

    it 'should return the matchers configuration' do
      expect(instance.matchers).to be_a(described_class::Matchers)
    end

    it 'should yield the matchers configuration' do
      expect { |block| instance.matchers(&block) }
        .to yield_with_args(instance.matchers)
    end
  end
end
