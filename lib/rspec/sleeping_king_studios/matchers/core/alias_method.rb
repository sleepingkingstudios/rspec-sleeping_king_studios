# lib/rspec/sleeping_king_studios/matchers/core/alias_method.rb

require 'rspec/sleeping_king_studios/matchers/core/have_aliased_method_matcher'
require 'rspec/sleeping_king_studios/matchers/macros'

module RSpec::SleepingKingStudios::Matchers::Macros
  # @see RSpec::SleepingKingStudios::Matchers::Core::AliasMethodMatcher#matches?
  def alias_method expected
    SleepingKingStudios::Tools::CoreTools.deprecate(
      '#alias_method',
      message: 'Use #have_aliased_method instead.'
    )

    RSpec::SleepingKingStudios::Matchers::Core::HaveAliasedMethodMatcher
      .new expected
  end # method be_boolean
end # module
