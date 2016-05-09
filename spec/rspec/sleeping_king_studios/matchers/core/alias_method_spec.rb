# spec/rspec/sleeping_king_studios/matchers/core/alias_method_spec.rb

require 'spec_helper'

require 'rspec/sleeping_king_studios/matchers/core/alias_method'

RSpec.describe RSpec::SleepingKingStudios::Matchers do
  let(:matcher_class) do
    RSpec::SleepingKingStudios::Matchers::Core::AliasMethodMatcher
  end # let
  let(:example_group) { self }

  describe '#alias_method' do
    let(:method_name)   { :foo }
    let(:matcher)       { example_group.alias_method method_name }

    it { expect(example_group).to respond_to(:alias_method).with(1).argument }

    it { expect(matcher).to be_a matcher_class }
  end # describe
end # describe
