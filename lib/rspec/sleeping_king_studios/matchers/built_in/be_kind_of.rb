# lib/rspec/sleeping_king_studios/matchers/built_in/be_kind_of.rb

require 'rspec/sleeping_king_studios/matchers/built_in/be_kind_of_matcher'

module RSpec::SleepingKingStudios::Matchers
  # @see RSpec::SleepingKingStudios::Matchers::BuiltIn::BeAKindOfMatcher#match
  def be_kind_of expected
    RSpec::SleepingKingStudios::Matchers::BuiltIn::BeAKindOfMatcher.new expected
  end # method be_kind_of

  alias_method :be_a, :be_kind_of
end # module
