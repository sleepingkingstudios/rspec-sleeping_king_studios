# spec/rspec/sleeping_king_studios/matchers/core/have_predicate_spec.rb

require 'spec_helper'

require 'rspec/sleeping_king_studios/matchers/core/have_predicate'

RSpec.describe RSpec::SleepingKingStudios::Matchers::Macros do
  let(:matcher_class) do
    RSpec::SleepingKingStudios::Matchers::Core::HavePredicateMatcher
  end # let
  let(:method_name)   { :foo }
  let(:example_group) { self }

  describe '#have_predicate' do
    let(:matcher) { example_group.have_predicate method_name }

    it { expect(example_group).to respond_to(:have_predicate).with(1).arguments }

    it { expect(matcher).to be_a matcher_class }
  end # describe
end # describe
