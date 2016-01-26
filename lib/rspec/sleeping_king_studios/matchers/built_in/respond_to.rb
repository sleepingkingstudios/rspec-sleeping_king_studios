# lib/rspec/sleeping_king_studios/matchers/built_in/respond_to.rb

require 'rspec/sleeping_king_studios/matchers/built_in/respond_to_matcher'

module RSpec::SleepingKingStudios::Matchers
  # @see RSpec::SleepingKingStudios::Matchers::BuiltIn::RespondToMatcher#matches?
  def respond_to *expected
    RSpec::SleepingKingStudios::Matchers::BuiltIn::RespondToMatcher.new *expected
  end # method respond_to
end # module
