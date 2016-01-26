# lib/rspec/sleeping_king_studios/matchers/active_model/have_errors.rb

require 'rspec/sleeping_king_studios/matchers/active_model/have_errors_matcher'

module RSpec::SleepingKingStudios::Matchers
  # @see RSpec::SleepingKingStudios::Matchers::ActiveModel::HaveErrorsMatcher#matches?
  def have_errors
    RSpec::SleepingKingStudios::Matchers::ActiveModel::HaveErrorsMatcher.new
  end # method have_errors
end # module
