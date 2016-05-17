# lib/rspec/sleeping_king_studios/matchers/built_in/be_kind_of.rb

require 'rspec/sleeping_king_studios/matchers/built_in/include_matcher'
require 'rspec/sleeping_king_studios/matchers/macros'

module RSpec::SleepingKingStudios::Matchers::Macros
  # @see RSpec::SleepingKingStudios::Matchers::BuiltIn::IncludeMatcher#matches?
  def include *expected, &block
    RSpec::SleepingKingStudios::Matchers::BuiltIn::IncludeMatcher.new *expected, &block
  end # method include
end # module
