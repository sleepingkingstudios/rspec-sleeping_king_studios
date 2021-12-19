# spec/rspec/sleeping_king_studios/matchers/macros/be_kind_of_spec.rb

require 'spec_helper'

require 'rspec/sleeping_king_studios/matchers/built_in/be_kind_of'
require 'rspec/sleeping_king_studios/matchers/core/have_aliased_method'

RSpec.describe RSpec::SleepingKingStudios::Matchers::Macros do
  let(:matcher_class) do
    RSpec::SleepingKingStudios::Matchers::BuiltIn::BeAKindOfMatcher
  end # let
  let(:example_group) { self }

  describe '#be_kind_of' do
    let(:type)          { Object }
    let(:matcher)       { example_group.be_kind_of type }

    it { expect(example_group).to respond_to(:be_kind_of).with(1).arguments }

    it { expect(example_group).to have_aliased_method(:be_kind_of).as(:be_a) }

    it { expect(matcher).to be_a matcher_class }
  end # describe
end # describe
