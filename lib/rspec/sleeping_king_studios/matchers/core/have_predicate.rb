# lib/rspec/sleeping_king_studios/matchers/core/have_predicate.rb

require 'rspec/sleeping_king_studios/matchers/core/have_predicate_matcher'
require 'rspec/sleeping_king_studios/matchers/macros'

module RSpec::SleepingKingStudios::Matchers::Macros
  # @see RSpec::SleepingKingStudios::Matchers::Core::HavePredicateMatcher#matches?
  def have_predicate expected
    RSpec::SleepingKingStudios::Matchers::Core::HavePredicateMatcher.new expected
  end # method have_reader
  alias_method :define_predicate, :have_predicate
end # module
