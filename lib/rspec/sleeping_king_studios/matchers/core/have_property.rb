# lib/rspec/sleeping_king_studios/matchers/core/have_property.rb

require 'rspec/sleeping_king_studios/matchers/core/have_property_matcher'

module RSpec::SleepingKingStudios::Matchers
  # @see RSpec::SleepingKingStudios::Matchers::Core::HavePropertyMatcher#matches?
  def have_property expected
    RSpec::SleepingKingStudios::Matchers::Core::HavePropertyMatcher.new expected
  end # method have_property
end # module
