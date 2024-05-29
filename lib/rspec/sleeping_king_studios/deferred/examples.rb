# frozen_string_literal: true

require 'rspec/sleeping_king_studios/deferred'
require 'rspec/sleeping_king_studios/deferred/definitions'
require 'rspec/sleeping_king_studios/deferred/dsl'

module RSpec::SleepingKingStudios::Deferred
  # Defines a deferred example group for declaring shared tests.
  module Examples
    # Callback invoked when the module is included in another module or class.
    #
    # Extends the class or module with the Deferred::Definitions
    # and Deferred::Examples::DSL modules.
    #
    # @param other [Module] the other module or class.
    #
    # @see RSpec::SleepingKingStudios::Deferred::Definitions.
    # @see RSpec::SleepingKingStudios::Deferred::Examples::Dsl.
    def self.included(other)
      super

      other.extend RSpec::SleepingKingStudios::Deferred::Definitions
      other.extend RSpec::SleepingKingStudios::Deferred::Dsl
    end
  end
end
