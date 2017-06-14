# lib/rspec/sleeping_king_studios/matchers/core/have_property.rb

require 'rspec/sleeping_king_studios/matchers/core/have_property_matcher'
require 'rspec/sleeping_king_studios/matchers/macros'

module RSpec::SleepingKingStudios::Matchers::Macros
  # @see RSpec::SleepingKingStudios::Matchers::Core::HavePropertyMatcher#matches?
  def have_property expected, allow_private: false
    RSpec::SleepingKingStudios::Matchers::Core::HavePropertyMatcher.new(
      expected,
      :allow_private => allow_private
    ) # end matcher
  end # method have_property
end # module
