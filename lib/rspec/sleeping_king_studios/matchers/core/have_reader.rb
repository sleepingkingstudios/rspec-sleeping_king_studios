# lib/rspec/sleeping_king_studios/matchers/core/have_reader.rb

require 'rspec/sleeping_king_studios/matchers/core/have_reader_matcher'
require 'rspec/sleeping_king_studios/matchers/macros'

module RSpec::SleepingKingStudios::Matchers::Macros
  # @see RSpec::SleepingKingStudios::Matchers::Core::HaveReaderMatcher#matches?
  def have_reader expected
    RSpec::SleepingKingStudios::Matchers::Core::HaveReaderMatcher.new expected
  end # method have_reader
end # module
