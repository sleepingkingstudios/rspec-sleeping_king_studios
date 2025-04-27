# frozen_string_literal: true

require 'rspec/sleeping_king_studios/matchers/core'
require 'rspec/sleeping_king_studios/matchers/core/have_aliased_method_matcher'

module RSpec::SleepingKingStudios::Matchers::Core
  # Matcher for testing whether an object aliases a specified method using the
  # specified other method name.
  #
  # @since 2.2.0
  class AliasMethodMatcher < RSpec::SleepingKingStudios::Matchers::Core::HaveAliasedMethodMatcher
    include RSpec::Matchers::Composable

    # (see BaseMatcher#matches?)
    def matches?(actual)
      SleepingKingStudios::Tools::CoreTools.deprecate(
        'AliasMethodMatcher',
        message: 'Use a HaveAliasedMethodMatcher instead.'
      )

      super
    end
  end
end
