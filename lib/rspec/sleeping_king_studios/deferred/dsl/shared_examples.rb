# frozen_string_literal: true

require 'rspec/sleeping_king_studios/deferred/calls/included_examples'
require 'rspec/sleeping_king_studios/deferred/calls/shared_examples'
require 'rspec/sleeping_king_studios/deferred/dsl'

module RSpec::SleepingKingStudios::Deferred::Dsl # rubocop:disable Style/Documentation
  # Methods for defining and including deferred shared example groups.
  module SharedExamples
    # Meta-methods for defining deferred examples.
    module Macros
      # Registers a method for deferring including a shared example group.
      #
      # @param method_name [String, Symbol] the name of the deferred method.
      #
      # @return [void]
      def define_included_examples_method(method_name) # rubocop:disable Metrics/MethodLength
        define_method(method_name) do |name, *args, **kwargs, &block|
          deferred_calls <<
            RSpec::SleepingKingStudios::Deferred::Calls::IncludedExamples.new(
              method_name,
              name,
              *args,
              **kwargs,
              &block
            )

          nil
        end
      end

      # Registers a method for deferring a shared example group.
      #
      # @param method_name [String, Symbol] the name of the deferred method.
      #
      # @return [void]
      def define_shared_examples_method(method_name) # rubocop:disable Metrics/MethodLength
        define_method(method_name) do |name, *args, **kwargs, &block|
          deferred_calls <<
            RSpec::SleepingKingStudios::Deferred::Calls::SharedExamples.new(
              method_name,
              name,
              *args,
              **kwargs,
              &block
            )

          nil
        end
      end
    end

    extend Macros

    # @!macro [new] define_included_examples_method
    #   @!method $1(name, *flags, **metadata, &block)
    #     Defines a deferred included example group using the $1 method.
    #
    #     @param name [String, Symbol, Module] the name for the included example
    #       group.
    #     @param flags [Array<Symbol>] metadata flags for the included example
    #       group.
    #     @param metadata [Hash] metadata for the included example group.
    #     @param block [Proc] the implementation of the included example group.
    #
    #     @return [void]

    # @!macro [new] define_shared_examples_method
    #   @!method $1(name, *flags, **metadata, &block)
    #     Defines a deferred shared example group using the $1 method.
    #
    #     @param name [String, Symbol, Module] the name for the shared example
    #       group.
    #     @param flags [Array<Symbol>] metadata flags for the shared example
    #       group.
    #     @param metadata [Hash] metadata for the shared example group.
    #     @param block [Proc] the implementation of the shared example group.
    #
    #     @return [void]

    # @!macro define_included_examples_method
    define_included_examples_method :finclude_deferred

    # @!macro define_included_examples_method
    define_included_examples_method :finclude_examples

    # @!macro define_included_examples_method
    define_included_examples_method :fwrap_context

    # @!macro define_included_examples_method
    define_included_examples_method :fwrap_deferred

    # @!macro define_included_examples_method
    define_included_examples_method :fwrap_examples

    # @!macro define_included_examples_method
    define_included_examples_method :include_context

    # @!macro define_included_examples_method
    define_included_examples_method :include_deferred

    # @!macro define_included_examples_method
    define_included_examples_method :include_examples

    # @!macro define_included_examples_method
    define_included_examples_method :it_behaves_like

    # @!macro define_included_examples_method
    define_included_examples_method :it_should_behave_like

    # @!macro define_shared_examples_method
    define_shared_examples_method :shared_context

    # @!macro define_shared_examples_method
    define_shared_examples_method :shared_examples

    # @!macro define_shared_examples_method
    define_shared_examples_method :shared_examples_for

    # @!macro define_included_examples_method
    define_included_examples_method :wrap_context

    # @!macro define_included_examples_method
    define_included_examples_method :wrap_deferred

    # @!macro define_included_examples_method
    define_included_examples_method :wrap_examples

    # @!macro define_included_examples_method
    define_included_examples_method :xinclude_deferred

    # @!macro define_included_examples_method
    define_included_examples_method :xinclude_examples

    # @!macro define_included_examples_method
    define_included_examples_method :xwrap_context

    # @!macro define_included_examples_method
    define_included_examples_method :xwrap_deferred

    # @!macro define_included_examples_method
    define_included_examples_method :xwrap_examples
  end

  include SharedExamples
end
