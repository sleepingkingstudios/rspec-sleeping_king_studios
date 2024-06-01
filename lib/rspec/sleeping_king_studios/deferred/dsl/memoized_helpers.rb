# frozen_string_literal: true

require 'rspec/sleeping_king_studios/deferred/dsl'

module RSpec::SleepingKingStudios::Deferred::Dsl
  # DSL for defining memoized helpers for deferred examples.
  module MemoizedHelpers
    # Callback invoked when the module is extended into another module or class.
    #
    # Defines a HelperImplementations module on the module and includes it in
    # the module.
    #
    # @param other [Module] the other module or class.
    def self.extended(other)
      super

      return if other.const_defined?(:HelperImplementations, true)

      other.const_set(:HelperImplementations, Module.new)
    end

    def call(example_group)
      super

      include self::HelperImplementations
    end

    # Defines a memoized helper.
    #
    # @param helper_name [String, Symbol] the name of the helper method.
    # @param block [Block] the implementation of the helper method.
    #
    # @return [void]
    def let(helper_name, &)
      helper_name = helper_name.to_sym

      self::HelperImplementations.define_method(helper_name, &)

      define_method(helper_name) do
        helper_values = @memoized_helper_values ||= {}

        helper_values.fetch(helper_name) do
          helper_values[helper_name] = super()
        end
      end
    end

    # Defines a memoized helper and adds a hook to evaluate it before examples.
    #
    # @param helper_name [String, Symbol] the name of the helper method.
    # @param block [Block] the implementation of the helper method.
    #
    # @return [void]
    def let!(helper_name, &)
      let(helper_name, &)

      before(:example) { send(helper_name) }
    end
  end
end
