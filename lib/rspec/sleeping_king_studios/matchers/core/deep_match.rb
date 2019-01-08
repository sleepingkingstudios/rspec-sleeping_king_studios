# frozen_string_literals: true

require 'rspec/sleeping_king_studios/matchers/core/deep_matcher'
require 'rspec/sleeping_king_studios/matchers/macros'

module RSpec::SleepingKingStudios::Matchers::Macros
  # @see RSpec::SleepingKingStudios::Matchers::Core::BeBooleanMatcher#matches?
  def deep_match(expected)
    RSpec::SleepingKingStudios::Matchers::Core::DeepMatcher.new(expected)
  end
end
