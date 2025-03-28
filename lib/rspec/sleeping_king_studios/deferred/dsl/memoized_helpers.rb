# frozen_string_literal: true

require 'rspec/sleeping_king_studios/deferred/dsl'

module RSpec::SleepingKingStudios::Deferred::Dsl # rubocop:disable Style/Documentation
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

      other.const_set(
        :HelperImplementations,
        Module.new do
          named = Module.new

          const_set(:NamedSuper, named)

          include named
        end
      )
    end

    # (see RSpec::SleepingKingStudios::Deferred::Definitions#call)
    def call(example_group)
      super

      include self::HelperImplementations
    end

    # @overload let(helper_name = nil, &block)
    #   Defines a memoized helper.
    #
    #   @param helper_name [String, Symbol] the name of the helper method.
    #   @param block [Block] the implementation of the helper method.
    #
    #   @return [void]
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

    # @overload let!(helper_name = nil, &block)
    #   Defines a memoized helper and adds a hook to evaluate it before examples.
    #
    #   @param helper_name [String, Symbol] the name of the helper method.
    #   @param block [Block] the implementation of the helper method.
    #
    #   @return [void]
    def let!(helper_name, &)
      let(helper_name, &)

      before(:example) { send(helper_name) }
    end

    # Defines an optional memoized helper.
    #
    # The helper will use the parent value if defined; otherwise, will use the
    # given value.
    #
    # @param helper_name [String, Symbol] the name of the helper method.
    # @param block [Block] the implementation of the helper method.
    #
    # @return [void]
    def let?(helper_name, &block)
      wrapped = lambda do
        next super() if defined?(super())

        instance_exec(&block)
      end

      let(helper_name, &wrapped)
    end

    # @overload subject(helper_name = nil, &block)
    #   Defines a memoized subject helper.
    #
    #   @param helper_name [String, Symbol] the name of the helper method.
    #   @param block [Block] the implementation of the helper method.
    #
    #   @return [void]
    def subject(helper_name = nil, &)
      let(:subject, &)

      define_method(helper_name) { subject } if helper_name

      self::HelperImplementations::NamedSuper.define_method(:subject) do
        raise NotImplementedError, '`super` in named subjects is not supported'
      end
    end

    # @overload subject!(helper_name = nil, &block)
    #   Defines a memoized subject helper and adds a hook to evaluate it.
    #
    #   @param helper_name [String, Symbol] the name of the helper method.
    #   @param block [Block] the implementation of the helper method.
    #
    #   @return [void]
    def subject!(helper_name = nil, &)
      subject(helper_name, &)

      before(:example) { send(helper_name) }
    end
  end

  include MemoizedHelpers
end
