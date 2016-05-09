# lib/rspec/sleeping_king_studios/matchers/core/be_boolean.rb

require 'spec_helper'

require 'rspec/sleeping_king_studios/matchers/core/be_boolean'

RSpec.describe RSpec::SleepingKingStudios::Matchers do
  let(:matcher_class) do
    RSpec::SleepingKingStudios::Matchers::Core::BeBooleanMatcher
  end # let
  let(:example_group) { self }

  describe '#a_boolean' do
    let(:matcher) { example_group.a_boolean }

    it { expect(example_group).to respond_to(:be_boolean).with(0).arguments }

    it { expect(matcher).to be_a RSpec::Matchers::AliasedMatcher }

    it { expect(matcher.base_matcher).to be_a matcher_class }

    it 'should have a custom description' do
      expect(matcher.description).to be == 'true or false'
    end # it
  end # describe

  describe '#be_boolean' do
    let(:matcher) { example_group.be_boolean }

    it { expect(example_group).to respond_to(:be_boolean).with(0).arguments }

    it { expect(matcher).to be_a matcher_class }
  end # describe
end # describe
