# frozen_string_literal: true

require 'rspec/sleeping_king_studios/deferred/calls/hook'
require 'rspec/sleeping_king_studios/deferred/definitions'
require 'rspec/sleeping_king_studios/deferred/examples'

module RSpec::SleepingKingStudios::Deferred::Examples
  # Domain-specific language for defining deferred hooks.
  module Hooks
    include RSpec::SleepingKingStudios::Deferred::Definitions

    # Defines a deferred hook using the #after method.
    #
    # @param scope [Symbol] the scope for the hook. Must be one of :context,
    #   :each, or :example.
    # @param flags [Array<Symbol>] condition flags for the hook. Will be
    #   transformed into conditions entries with true values.
    # @param block [Proc] the implementation of the hook.
    #
    # @return [void]
    def after(scope, *flags, **conditions, &block)
      deferred_hooks << RSpec::SleepingKingStudios::Deferred::Calls::Hook.new(
        :after,
        scope,
        *flags,
        **conditions,
        &block
      )
    end

    # Defines a deferred hook using the #append_after method.
    #
    # @param scope [Symbol] the scope for the hook. Must be one of :context,
    #   :each, or :example.
    # @param flags [Array<Symbol>] condition flags for the hook. Will be
    #   transformed into conditions entries with true values.
    # @param block [Proc] the implementation of the hook.
    #
    # @return [void]
    def append_after(scope, *flags, **conditions, &block)
      deferred_hooks << RSpec::SleepingKingStudios::Deferred::Calls::Hook.new(
        :append_after,
        scope,
        *flags,
        **conditions,
        &block
      )
    end

    # Defines a deferred hook using the #around method.
    #
    # @param scope [Symbol] the scope for the hook. Must be one of :context,
    #   :each, or :example.
    # @param flags [Array<Symbol>] condition flags for the hook. Will be
    #   transformed into conditions entries with true values.
    # @param block [Proc] the implementation of the hook.
    #
    # @return [void]
    def around(scope, *flags, **conditions, &block)
      deferred_hooks << RSpec::SleepingKingStudios::Deferred::Calls::Hook.new(
        :around,
        scope,
        *flags,
        **conditions,
        &block
      )
    end

    # Defines a deferred hook using the #before method.
    #
    # @param scope [Symbol] the scope for the hook. Must be one of :context,
    #   :each, or :example.
    # @param flags [Array<Symbol>] condition flags for the hook. Will be
    #   transformed into conditions entries with true values.
    # @param block [Proc] the implementation of the hook.
    #
    # @return [void]
    def before(scope, *flags, **conditions, &block)
      deferred_hooks << RSpec::SleepingKingStudios::Deferred::Calls::Hook.new(
        :before,
        scope,
        *flags,
        **conditions,
        &block
      )
    end

    # Defines a deferred hook using the #prepend_before method.
    #
    # @param scope [Symbol] the scope for the hook. Must be one of :context,
    #   :each, or :example.
    # @param flags [Array<Symbol>] condition flags for the hook. Will be
    #   transformed into conditions entries with true values.
    # @param block [Proc] the implementation of the hook.
    #
    # @return [void]
    def prepend_before(scope, *flags, **conditions, &block)
      deferred_hooks << RSpec::SleepingKingStudios::Deferred::Calls::Hook.new(
        :prepend_before,
        scope,
        *flags,
        **conditions,
        &block
      )
    end

    protected

    def deferred_hooks
      @deferred_hooks ||= []
    end

    private

    def group_hooks
      ancestors
        .reduce([]) do |memo, ancestor|
          unless ancestor.singleton_class.method_defined?(:deferred_hooks)
            break memo
          end

          memo + ancestor.deferred_hooks
        end
        .reverse
    end

    def grouped_deferred_calls
      super.merge(hooks: group_hooks)
    end
  end
end
