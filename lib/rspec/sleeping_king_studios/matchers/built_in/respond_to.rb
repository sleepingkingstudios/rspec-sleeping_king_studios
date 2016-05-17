# lib/rspec/sleeping_king_studios/matchers/built_in/respond_to.rb

require 'rspec/sleeping_king_studios/matchers/built_in/respond_to_matcher'
require 'rspec/sleeping_king_studios/matchers/macros'

module RSpec::SleepingKingStudios::Matchers::Macros
  # @see RSpec::SleepingKingStudios::Matchers::BuiltIn::RespondToMatcher#matches?
  def respond_to *expected
    RSpec::SleepingKingStudios::Matchers::BuiltIn::RespondToMatcher.new *expected
  end # method respond_to
end # module
