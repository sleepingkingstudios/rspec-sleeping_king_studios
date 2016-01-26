# lib/rspec/sleeping_king_studios/matchers/core/have_predicate.rb

require 'rspec/sleeping_king_studios/matchers/core/have_predicate_matcher'

module RSpec::SleepingKingStudios::Matchers
  # @see RSpec::SleepingKingStudios::Matchers::Core::HavePredicateMatcher#matches?
  def have_predicate expected
    RSpec::SleepingKingStudios::Matchers::Core::HavePredicateMatcher.new expected
  end # method have_reader
end # module
