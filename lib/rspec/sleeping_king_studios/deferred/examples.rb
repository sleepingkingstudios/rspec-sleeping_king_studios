# frozen_string_literal: true

require 'set'

require 'rspec/sleeping_king_studios/deferred'
require 'rspec/sleeping_king_studios/deferred/example'
require 'rspec/sleeping_king_studios/deferred/example_group'

module RSpec::SleepingKingStudios::Deferred
  # Defines a deferred example group for declaring shared tests.
  module Examples
    autoload :Definitions,
      'rspec/sleeping_king_studios/deferred/examples/definitions'
    autoload :Dsl,
      'rspec/sleeping_king_studios/deferred/examples/dsl'
    autoload :Missing,
      'rspec/sleeping_king_studios/deferred/examples/missing'

    # Callback invoked when the module is included in another module or class.
    #
    # Extends the class or module with the Deferred::Examples::Definitions
    # and Deferred::Examples::DSL modules.
    #
    # @param other [Module] the other module or class.
    #
    # @see RSpec::SleepingKingStudios::Deferred::Examples::Definitions.
    # @see RSpec::SleepingKingStudios::Deferred::Examples::Dsl.
    def self.included(other)
      super

      other.extend(RSpec::SleepingKingStudios::Deferred::Examples::Dsl)
    end
  end
end
