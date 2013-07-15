# lib/rspec/sleeping_king_studios/matchers/require.rb

require 'rspec/sleeping_king_studios'

module RSpec::SleepingKingStudios
  # Custom matchers for use with RSpec::Expectations.
  module Matchers; end
end # module

RSpec.configure do |config|
  config.include RSpec::SleepingKingStudios::Matchers
end # configuration
