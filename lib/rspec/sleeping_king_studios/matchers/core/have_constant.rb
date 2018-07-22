# lib/rspec/sleeping_king_studios/matchers/core/have_constant.rb

require 'rspec/sleeping_king_studios/matchers/core/have_constant_matcher'
require 'rspec/sleeping_king_studios/matchers/macros'

module RSpec::SleepingKingStudios::Matchers::Macros
  # @see RSpec::SleepingKingStudios::Matchers::Core::HaveConstantMatcher#matches?
  def have_constant expected
    RSpec::SleepingKingStudios::Matchers::Core::HaveConstantMatcher.new expected
  end # method have_reader
  alias_method :define_constant, :have_constant

  # @see RSpec::SleepingKingStudios::Matchers::Core::HaveConstantMatcher#immutable
  def have_immutable_constant expected
    have_constant(expected).immutable
  end # method have_reader
  alias_method :define_immutable_constant, :have_immutable_constant
end # module
