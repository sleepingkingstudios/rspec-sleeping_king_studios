require 'rspec/sleeping_king_studios/matchers/core/have_changed_matcher'
require 'rspec/sleeping_king_studios/matchers/macros'
require 'rspec/sleeping_king_studios/support/value_spy'

module RSpec::SleepingKingStudios::Matchers::Macros
  # @see RSpec::SleepingKingStudios::Matchers::Core::HaveChangedMatcher#matches?
  def have_changed
    RSpec::SleepingKingStudios::Matchers::Core::HaveChangedMatcher.new
  end

  # @see RSpec::SleepingKingStudios::Support::ValueSpy#initialize
  def watch_value(object = nil, method_name = nil, &block)
    RSpec::SleepingKingStudios::Support::ValueSpy
      .new(object, method_name, &block)
  end
end
