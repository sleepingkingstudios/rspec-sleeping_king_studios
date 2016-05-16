# spec/rspec/sleeping_king_studios/matchers/built_in/respond_to_spec.rb

require 'spec_helper'

require 'rspec/sleeping_king_studios/matchers/built_in/respond_to'

RSpec.describe RSpec::SleepingKingStudios::Matchers do
  let(:matcher_class) do
    ::RSpec::SleepingKingStudios::Matchers::BuiltIn::RespondToMatcher
  end # let
  let(:example_group) { self }

  describe '#respond_to' do
    let(:method_name) { :foo }
    let(:matcher)     { example_group.respond_to method_name }

    it { expect(example_group).to respond_to(:respond_to).with(1).argument.and_unlimited_arguments }

    it { expect(matcher).to be_a matcher_class }
  end # describe
end # describe
