# frozen_string_literals: true

require 'spec_helper'

require 'rspec/sleeping_king_studios/matchers/core/deep_match'

RSpec.describe RSpec::SleepingKingStudios::Matchers::Macros do
  let(:matcher_class) do
    RSpec::SleepingKingStudios::Matchers::Core::DeepMatcher
  end
  let(:example_group) { self }

  describe '#deep_match' do
    let(:matcher)  { example_group.deep_match(expected) }
    let(:expected) { 'expected value' }

    it { expect(example_group).to respond_to(:deep_match).with(1).argument }

    it { expect(matcher).to be_a matcher_class }
  end
end
