# spec/rspec/sleeping_king_studios/matchers/core/have_property_spec.rb

require 'spec_helper'

require 'rspec/sleeping_king_studios/matchers/core/have_property'

RSpec.describe RSpec::SleepingKingStudios::Matchers do
  let(:matcher_class) do
    RSpec::SleepingKingStudios::Matchers::Core::HavePropertyMatcher
  end # let
  let(:method_name)   { :foo }
  let(:example_group) { self }

  describe '#have_property' do
    let(:matcher) { example_group.have_property method_name }

    it { expect(example_group).to respond_to(:have_property).with(1).arguments }

    it { expect(matcher).to be_a matcher_class }
  end # describe
end # describe
