# spec/rspec/sleeping_king_studios/matchers/built_in/include_spec.rb

require 'spec_helper'
require 'rspec/sleeping_king_studios/matchers/built_in/respond_to'

require 'rspec/sleeping_king_studios/matchers/built_in/include'

RSpec.describe RSpec::SleepingKingStudios::Matchers do
  let(:matcher_class) do
    ::RSpec::SleepingKingStudios::Matchers::BuiltIn::IncludeMatcher
  end # let
  let(:example_group) { self }

  describe '#include' do
    let(:expectations) { "String" }
    let(:matcher)      { example_group.include expectations }

    it { expect(example_group).to respond_to(:include).with_unlimited_arguments }

    it { expect(matcher).to be_a matcher_class }
  end # describe
end # describe
