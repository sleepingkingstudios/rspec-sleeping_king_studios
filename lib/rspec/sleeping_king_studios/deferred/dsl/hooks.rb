# frozen_string_literal: true

require 'rspec/sleeping_king_studios/deferred/calls/hook'
require 'rspec/sleeping_king_studios/deferred/dsl'

module RSpec::SleepingKingStudios::Deferred::Dsl # rubocop:disable Style/Documentation
  # Domain-specific language for defining deferred hooks.
  module Hooks
    # @overload after(scope, *flags, **conditions, &block)
    #   Defines a deferred hook using the #after method.
    #
    #   @param scope [Symbol] the scope for the hook. Must be one of :context,
    #     :each, or :example.
    #   @param flags [Array<Symbol>] condition flags for the hook. Will be
    #     transformed into conditions entries with true values.
    #   @param block [Proc] the implementation of the hook.
    #
    #   @return [void]
    def after(scope, *flags, **conditions, &)
      deferred_hooks << RSpec::SleepingKingStudios::Deferred::Calls::Hook.new(
        :after,
        scope,
        *flags,
        **conditions,
        &
      )
    end

    # @overload append_after(scope, *flags, **conditions, &block)
    #   Defines a deferred hook using the #append_after method.
    #
    #   @param scope [Symbol] the scope for the hook. Must be one of :context,
    #     :each, or :example.
    #   @param flags [Array<Symbol>] condition flags for the hook. Will be
    #     transformed into conditions entries with true values.
    #   @param block [Proc] the implementation of the hook.
    #
    #   @return [void]
    def append_after(scope, *flags, **conditions, &)
      deferred_hooks << RSpec::SleepingKingStudios::Deferred::Calls::Hook.new(
        :append_after,
        scope,
        *flags,
        **conditions,
        &
      )
    end

    # @overload around(scope, *flags, **conditions, &block)
    #   Defines a deferred hook using the #around method.
    #
    #   @param scope [Symbol] the scope for the hook. Must be one of :context,
    #     :each, or :example.
    #   @param flags [Array<Symbol>] condition flags for the hook. Will be
    #     transformed into conditions entries with true values.
    #   @param block [Proc] the implementation of the hook.
    #
    #   @return [void]
    def around(scope, *flags, **conditions, &)
      deferred_hooks << RSpec::SleepingKingStudios::Deferred::Calls::Hook.new(
        :around,
        scope,
        *flags,
        **conditions,
        &
      )
    end

    # @overload before(scope, *flags, **conditions, &block)
    #   Defines a deferred hook using the #before method.
    #
    #   @param scope [Symbol] the scope for the hook. Must be one of :context,
    #     :each, or :example.
    #   @param flags [Array<Symbol>] condition flags for the hook. Will be
    #     transformed into conditions entries with true values.
    #   @param block [Proc] the implementation of the hook.
    #
    #   @return [void]
    def before(scope, *flags, **conditions, &)
      deferred_hooks << RSpec::SleepingKingStudios::Deferred::Calls::Hook.new(
        :before,
        scope,
        *flags,
        **conditions,
        &
      )
    end

    # (see RSpec::SleepingKingStudios::Deferred::Definitions#call)
    def call(example_group)
      super

      deferred_hooks.reverse_each do |deferred_hook|
        deferred_hook.call(example_group)
      end
    end

    # @private
    def deferred_hooks
      @deferred_hooks ||= []
    end

    # @overload prepend_before(scope, *flags, **conditions, &block)
    #   Defines a deferred hook using the #prepend_before method.
    #
    #   @param scope [Symbol] the scope for the hook. Must be one of :context,
    #     :each, or :example.
    #   @param flags [Array<Symbol>] condition flags for the hook. Will be
    #     transformed into conditions entries with true values.
    #   @param block [Proc] the implementation of the hook.
    #
    #   @return [void]
    def prepend_before(scope, *flags, **conditions, &)
      deferred_hooks << RSpec::SleepingKingStudios::Deferred::Calls::Hook.new(
        :prepend_before,
        scope,
        *flags,
        **conditions,
        &
      )
    end
  end

  include Hooks
end
