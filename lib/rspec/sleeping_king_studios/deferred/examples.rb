# frozen_string_literal: true

require 'set'

require 'rspec/sleeping_king_studios/deferred'

module RSpec::SleepingKingStudios::Deferred
  # Defines a deferred example group for declaring shared tests.
  module Examples
    autoload :Dsl,
      'rspec/sleeping_king_studios/deferred/examples/dsl'
    autoload :Hooks,
      'rspec/sleeping_king_studios/deferred/examples/hooks'
    autoload :Missing,
      'rspec/sleeping_king_studios/deferred/examples/missing'

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

      other.extend(RSpec::SleepingKingStudios::Deferred::Examples::Dsl)
      other.extend(RSpec::SleepingKingStudios::Deferred::Dsl::Hooks)
    end
  end
end
