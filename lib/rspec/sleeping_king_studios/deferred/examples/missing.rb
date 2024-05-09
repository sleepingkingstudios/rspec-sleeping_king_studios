# frozen_string_literal: true

require 'rspec/sleeping_king_studios/deferred/call'
require 'rspec/sleeping_king_studios/deferred/examples'
require 'rspec/sleeping_king_studios/deferred/examples/definitions'

module RSpec::SleepingKingStudios::Deferred::Examples
  # Optional support for deferring unrecognized methods.
  module Missing
    # Methods extended into the class when included in a class or module.
    module ClassMethods
      include RSpec::SleepingKingStudios::Deferred::Examples::Definitions

      private

      def method_missing(symbol, *args, **kwargs, &block)
        deferred_calls << RSpec::SleepingKingStudios::Deferred::Call.new(
          symbol,
          *args,
          **kwargs,
          &block
        )

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
    # @see RSpec::SleepingKingStudios::Deferred::Examples::Missing::ClassMethods.
    def self.included(other)
      super

      other.extend(
        RSpec::SleepingKingStudios::Deferred::Examples::Missing::ClassMethods
      )
    end
  end
end
