# spec/rspec/sleeping_king_studios/matchers/macros_spec.rb

require 'spec_helper'
require 'rspec/sleeping_king_studios/matchers/base_matcher'
require 'rspec/sleeping_king_studios/matchers/macros'

RSpec.describe RSpec::SleepingKingStudios::Matchers::Macros do
  describe '::alias_matcher' do
    it { expect(described_class).to respond_to(:alias_matcher).with(2).arguments }

    describe 'with a defined matcher' do
      let(:dance_matcher) do
        Class.new(RSpec::SleepingKingStudios::Matchers::BaseMatcher) do
          def description
            'to dance'
          end # method description
        end # class
      end # let
      let(:example_group) { self }

      before(:example) { described_class.send :define_method, :to_dance, ->() { dance_matcher.new } }

      after(:example) do
        %i(a_dance to_dance).each do |method|
          described_class.send(:remove_method, method) if example_group.respond_to?(method)
        end # each
      end # after example

      it 'should define an alias' do
        described_class.alias_matcher :a_dance, :to_dance

        expect(example_group).to respond_to(:a_dance)

        aliased = example_group.a_dance
        expect(aliased.class).to be RSpec::Matchers::AliasedMatcher
        expect(aliased.base_matcher).to be_a dance_matcher
      end # it

      it 'should override the description' do
        described_class.alias_matcher :a_dance, :to_dance

        aliased = example_group.a_dance
        expect(aliased.description).to be == 'a dance'
      end # it

      describe 'with a description block' do
        it 'should override the description' do
          described_class.alias_matcher :a_dance, :to_dance do |old_description|
            'a waltz'
          end # alias

          aliased = example_group.a_dance
          expect(aliased.description).to be == 'a waltz'
        end # it
      end # describe
    end # describe
  end # describe
end # describe
