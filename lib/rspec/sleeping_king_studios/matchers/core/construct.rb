# spec/rspec/sleeping_king_studios/matchers/core/construct.rb

require 'rspec/sleeping_king_studios/matchers/core/construct_matcher'
require 'rspec/sleeping_king_studios/matchers/macros'

module RSpec::SleepingKingStudios::Matchers::Macros
  # @see RSpec::SleepingKingStudios::Matchers::Core::ConstructMatcher#matches?
  def construct
    RSpec::SleepingKingStudios::Matchers::Core::ConstructMatcher.new
  end # method construct
  alias_method :be_constructible, :construct
end # module
