# lib/rspec/sleeping_king_studios/matchers/core/have_reader.rb

require 'rspec/sleeping_king_studios/matchers/core/have_reader_matcher'

module RSpec::SleepingKingStudios::Matchers
  # @see RSpec::SleepingKingStudios::Matchers::Core::HaveReaderMatcher#matches?
  def have_reader expected
    RSpec::SleepingKingStudios::Matchers::Core::HaveReaderMatcher.new expected
  end # method have_reader
end # module
