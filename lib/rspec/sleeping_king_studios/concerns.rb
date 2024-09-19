# frozen_string_literal: true

require 'rspec/sleeping_king_studios'

module RSpec::SleepingKingStudios
  # RSpec-related concerns to mix into classes or objects.
  module Concerns
    autoload :ExampleConstants,
      'rspec/sleeping_king_studios/concerns/example_constants'
    autoload :MemoizedHelpers,
      'rspec/sleeping_king_studios/concerns/memoized_helpers'
  end
end
