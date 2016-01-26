# lib/rspec/sleeping_king_studios/matchers/core/be_boolean.rb

require 'rspec/sleeping_king_studios/matchers/core/be_boolean_matcher'

module RSpec::SleepingKingStudios::Matchers
  # @see RSpec::SleepingKingStudios::Matchers::Core::BeBooleanMatcher#matches?
  def be_boolean
    RSpec::SleepingKingStudios::Matchers::Core::BeBooleanMatcher.new
  end # method be_boolean

  alias_method :be_bool, :be_boolean

  # @!method a_boolean
  #   @see RSpec::SleepingKingStudios::Matchers::Core::BeBooleanMatcher#matches?
  alias_matcher :a_boolean, :be_boolean do |description|
    'true or false'
  end # alias
end # module
