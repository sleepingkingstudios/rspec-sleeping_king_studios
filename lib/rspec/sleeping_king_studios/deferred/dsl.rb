# frozen_string_literal: true

require 'rspec/sleeping_king_studios/deferred'

module RSpec::SleepingKingStudios::Deferred
  # Domain-specific language for defining deferred examples.
  module Dsl
    # Callback invoked when the module is extended into another module or class.
    #
    # Delegates to child module #extended methods.
    #
    # @param other [Module] the other module or class.
    def self.extended(other)
      super

      other.extend(RSpec::SleepingKingStudios::Deferred::Dsl::MemoizedHelpers)
    end
  end
end

require 'rspec/sleeping_king_studios/deferred/dsl/examples'
require 'rspec/sleeping_king_studios/deferred/dsl/example_groups'
require 'rspec/sleeping_king_studios/deferred/dsl/hooks'
require 'rspec/sleeping_king_studios/deferred/dsl/memoized_helpers'
