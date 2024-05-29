# frozen_string_literal: true

require 'rspec/sleeping_king_studios/deferred/calls/example'
require 'rspec/sleeping_king_studios/deferred/dsl'

module RSpec::SleepingKingStudios::Deferred::Dsl # rubocop:disable Style/Documentation
  # Methods for defining deferred examples.
  module Examples
    # Meta-methods for defining deferred examples.
    module Macros
      # Registers a method for deferring an example.
      #
      # @param method_name [String, Symbol] the name of the deferred method.
      #
      # @return [void]
      def define_example_method(method_name)
        define_method(method_name) do |*args, **kwargs, &block|
          deferred_calls <<
            RSpec::SleepingKingStudios::Deferred::Calls::Example.new(
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

    # @!macro define_example_method
    define_example_method :example

    # @!macro define_example_method
    define_example_method :fexample

    # @!macro define_example_method
    define_example_method :fit

    # @!macro define_example_method
    define_example_method :focus

    # @!macro define_example_method
    define_example_method :fspecify

    # @!macro define_example_method
    define_example_method :it

    # @!macro define_example_method
    define_example_method :pending

    # @!macro define_example_method
    define_example_method :skip

    # @!macro define_example_method
    define_example_method :specify

    # @!macro define_example_method
    define_example_method :xexample

    # @!macro define_example_method
    define_example_method :xit

    # @!macro define_example_method
    define_example_method :xspecify
  end

  include Examples
end
