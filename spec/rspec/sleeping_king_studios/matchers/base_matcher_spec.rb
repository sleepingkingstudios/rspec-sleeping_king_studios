# spec/rspec/sleeping_king_studios/matchers/base_matcher_spec.rb

require 'rspec/sleeping_king_studios/spec_helper'
require 'rspec/sleeping_king_studios/matchers/base_matcher_helpers'

require 'rspec/sleeping_king_studios/matchers/base_matcher'

describe RSpec::SleepingKingStudios::Matchers::BaseMatcher do
  include RSpec::SleepingKingStudios::Matchers::BaseMatcherHelpers

  let(:instance) { described_class.new }

  it_behaves_like RSpec::SleepingKingStudios::Matchers::BaseMatcher
end # describe
