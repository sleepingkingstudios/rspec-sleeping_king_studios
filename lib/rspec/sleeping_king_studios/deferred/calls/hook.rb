# frozen_string_literal: true

require 'set'

require 'rspec/sleeping_king_studios/deferred/call'
require 'rspec/sleeping_king_studios/deferred/calls'

module RSpec::SleepingKingStudios::Deferred::Calls
  # Value object representing a deferred RSpec example.
  class Hook < RSpec::SleepingKingStudios::Deferred::Call
    VALID_METHOD_NAMES = Set.new(
      %i[after append_after around before prepend_before]
    ).freeze
    private_constant :VALID_METHOD_NAMES

    VALID_SCOPES = Set.new(%i[context each example]).freeze
    private_constant :VALID_SCOPES

    # @return [Symbol] the scope of the hook.
    def scope
      arguments.first&.intern
    end

    private

    def validate_block!
      return if block

      raise ArgumentError, 'no block given'
    end

    def validate_method_name!
      return if VALID_METHOD_NAMES.include?(method_name)

      raise ArgumentError, "invalid hook method #{method_name.inspect}"
    end

    def validate_parameters!
      super

      validate_block!
      validate_method_name!
      validate_scope!
    end

    def validate_scope! # rubocop:disable Metrics/MethodLength
      tools.assertions.validate_name(arguments.first, as: :scope)

      if method_name == :around
        return if scope == :each || scope == :example

        raise ArgumentError, 'scope for an :around hook must be :example'
      else
        return if VALID_SCOPES.include?(scope)

        message =
          "scope for a #{method_name.inspect} hook must be :context, :each, " \
          'or :example'

        raise ArgumentError, message
      end
    end
  end
end
