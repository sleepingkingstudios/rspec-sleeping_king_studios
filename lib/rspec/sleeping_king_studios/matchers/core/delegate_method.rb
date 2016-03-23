# lib/rspec/sleeping_king_studios/matchers/core/delegate_method.rb

require 'rspec/sleeping_king_studios/matchers/core/delegate_method_matcher'

module RSpec::SleepingKingStudios::Matchers
  # @see RSpec::SleepingKingStudios::Matchers::Core::DelegateMethodMatcher#matches?
  def delegate_method *method_names
    RSpec::SleepingKingStudios::Matchers::Core::DelegateMethodMatcher.new *method_names
  end # method delegate_method
end # module
