require 'rspec/sleeping_king_studios/configuration'

require 'rspec/sleeping_king_studios/matchers/core/construct'
require 'rspec/sleeping_king_studios/matchers/core/have_predicate'
require 'rspec/sleeping_king_studios/matchers/core/have_reader'
require 'rspec/sleeping_king_studios/matchers/core/have_writer'

RSpec.describe RSpec::SleepingKingStudios::Configuration::Matchers do
  subject(:instance) { described_class.new }

  describe '::new' do
    it { expect(described_class).to be_constructible.with(0).arguments }
  end

  describe '#allow_empty_include_matchers' do
    it 'should define the reader' do
      expect(instance)
        .to have_reader(:allow_empty_include_matchers)
        .with_value(true)
    end
  end

  describe '#allow_empty_include_matchers?' do
    it 'should define the predicate' do
      expect(instance)
        .to have_predicate(:allow_empty_include_matchers?)
        .with_value(true)
    end

    context 'when allow_empty_include_matchers is false' do
      before(:example) do
        instance.allow_empty_include_matchers = false
      end

      it { expect(instance.allow_empty_include_matchers?).to be false }
    end
  end

  describe '#allow_empty_include_matchers=' do
    it 'should define the writer' do
      expect(instance).to have_writer(:allow_empty_include_matchers=)
    end

    it 'should update the value' do
      expect { instance.allow_empty_include_matchers = false }
        .to change(instance, :allow_empty_include_matchers)
        .to be false
    end
  end

  describe '#strict_predicate_matching' do
    it 'should define the reader' do
      expect(instance)
        .to have_reader(:strict_predicate_matching)
        .with_value(false)
    end
  end

  describe '#strict_predicate_matching?' do
    it 'should define the predicate' do
      expect(instance)
        .to have_reader(:strict_predicate_matching?)
        .with_value(false)
    end

    context 'when strict_predicate_matching is true' do
      before(:example) do
        instance.strict_predicate_matching = true
      end

      it { expect(instance.strict_predicate_matching?).to be true }
    end
  end

  describe '#strict_predicate_matching=' do
    it 'should define the writer' do
      expect(instance).to have_writer(:strict_predicate_matching=)
    end

    it 'should update the value' do
      expect { instance.strict_predicate_matching = true }
        .to change(instance, :strict_predicate_matching)
        .to be true
    end
  end
end
