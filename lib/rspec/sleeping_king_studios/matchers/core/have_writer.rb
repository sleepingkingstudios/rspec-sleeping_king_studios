# lib/rspec/sleeping_king_studios/matchers/core/have_writer.rb

require 'rspec/sleeping_king_studios/matchers/core/have_writer_matcher'
require 'rspec/sleeping_king_studios/matchers/macros'

module RSpec::SleepingKingStudios::Matchers::Macros
  # @see RSpec::SleepingKingStudios::Matchers::Core::HaveWriterMatcher#matches?
  def have_writer expected
    RSpec::SleepingKingStudios::Matchers::Core::HaveWriterMatcher.new expected
  end # method have_writer
end # module
