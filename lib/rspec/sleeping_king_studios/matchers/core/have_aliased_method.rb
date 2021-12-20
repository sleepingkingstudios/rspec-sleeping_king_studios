# frozen_string_literal: true

require 'rspec/sleeping_king_studios/matchers/core/have_aliased_method_matcher'
require 'rspec/sleeping_king_studios/matchers/macros'

module RSpec::SleepingKingStudios::Matchers::Macros
  # @see RSpec::SleepingKingStudios::Matchers::Core::HaveAliasedMethodMatcher#matches?
  def have_aliased_method(original_name)
    RSpec::SleepingKingStudios::Matchers::Core::HaveAliasedMethodMatcher
      .new(original_name)
  end
end
