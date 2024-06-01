# frozen_string_literal: true

require 'rspec/sleeping_king_studios/deferred/call'
require 'rspec/sleeping_king_studios/deferred/definitions'
require 'rspec/sleeping_king_studios/deferred'

module RSpec::SleepingKingStudios::Deferred
  # Optional support for deferring unrecognized methods.
  module Missing
    # Methods extended into the class when included in a class or module.
    module ClassMethods
      include RSpec::SleepingKingStudios::Deferred::Definitions

      private

      def method_missing(...)
        deferred_calls << RSpec::SleepingKingStudios::Deferred::Call.new(...)

        nil
      end

      def respond_to_missing?(name, include_private = false)
        return true if super

        return false if !include_private && super(name, true)

        true
      end
    end

    # Callback invoked when the module is included in another module or class.
    #
    # Extends the class or module with the ClassMethods module.
    #
    # @param other [Module] the other module or class.
    #
    # @see RSpec::SleepingKingStudios::Deferred::Missing::ClassMethods.
    def self.included(other)
      super

      other.extend(
        RSpec::SleepingKingStudios::Deferred::Missing::ClassMethods
      )
    end
  end
end
