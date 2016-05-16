# spec/rspec/sleeping_king_studios/matchers/core/construct_spec.rb

require 'spec_helper'
require 'rspec/sleeping_king_studios/matchers/core/alias_method'

require 'rspec/sleeping_king_studios/matchers/core/construct'

RSpec.describe RSpec::SleepingKingStudios::Matchers do
  let(:matcher_class) do
    ::RSpec::SleepingKingStudios::Matchers::Core::ConstructMatcher
  end # let
  let(:example_group) { self }

  describe '#respond_to' do
    let(:matcher) { example_group.be_constructible }

    it { expect(example_group).to respond_to(:be_constructible).with(0).arguments }

    it { expect(example_group).to alias_method(:be_constructible).as(:construct) }

    it { expect(matcher).to be_a matcher_class }
  end # describe
end # describe
