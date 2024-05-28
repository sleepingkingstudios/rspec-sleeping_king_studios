# frozen_string_literal: true

require 'rspec/sleeping_king_studios/deferred/calls/example_group'
require 'rspec/sleeping_king_studios/deferred/dsl'

module RSpec::SleepingKingStudios::Deferred::Dsl # rubocop:disable Style/Documentation
  # Methods for defining deferred example groups.
  module ExampleGroups
    # Meta-methods for defining deferred example groups.
    module Macros
      # Registers a method for deferring an example group.
      #
      # @param method_name [String, Symbol] the name of the deferred method.
      #
      # @return [void]
      def define_example_group_method(method_name)
        define_method(method_name) do |*args, **kwargs, &block|
          deferred_calls <<
            RSpec::SleepingKingStudios::Deferred::Calls::ExampleGroup.new(
              method_name,
              *args,
              **kwargs,
              &block
            )

          nil
        end
      end
    end

    extend Macros

    # @!macro [new] define_example_group_method
    #   @!method $1(doc_string = nil, *flags, **metadata, &block)
    #     Defines a deferred example group using the $1 method.
    #
    #     @param doc_string [String] the example group's doc string.
    #     @param flags [Array<Symbol>] metadata flags for the example group.
    #       Will be transformed into metadata entries with true values.
    #     @param metadata [Hash] metadata for the example group.
    #     @param block [Proc] the implementation of the example group.
    #
    #     @return [void]

    # @!macro define_example_group_method
    define_example_group_method :context

    # @!macro define_example_group_method
    define_example_group_method :describe

    # @!macro define_example_group_method
    define_example_group_method :example_group

    # @!macro define_example_group_method
    define_example_group_method :fcontext

    # @!macro define_example_group_method
    define_example_group_method :fdescribe

    # @!macro define_example_group_method
    define_example_group_method :xcontext

    # @!macro define_example_group_method
    define_example_group_method :xdescribe
  end

  include ExampleGroups
end
