# lib/rspec/sleeping_king_studios/matchers/core/have_writer.rb

require 'rspec/sleeping_king_studios/matchers/core/have_writer_matcher'
require 'rspec/sleeping_king_studios/matchers/macros'

module RSpec::SleepingKingStudios::Matchers::Macros
  # @see RSpec::SleepingKingStudios::Matchers::Core::HaveWriterMatcher#matches?
  def have_writer expected, allow_private: false
    RSpec::SleepingKingStudios::Matchers::Core::HaveWriterMatcher.new(
      expected,
      :allow_private => allow_private
    ) # end matcher
  end # method have_writer
  alias_method :define_writer, :have_writer
end # module
