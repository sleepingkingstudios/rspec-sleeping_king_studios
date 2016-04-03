# lib/rspec/sleeping_king_studios/matchers/core/alias_method.rb

require 'rspec/sleeping_king_studios/matchers/core/alias_method_matcher'

module RSpec::SleepingKingStudios::Matchers
  # @see RSpec::SleepingKingStudios::Matchers::Core::AliasMethodMatcher#matches?
  def alias_method expected
    RSpec::SleepingKingStudios::Matchers::Core::AliasMethodMatcher.new expected
  end # method be_boolean
end # module
