# frozen_string_literal: true

require 'rspec/sleeping_king_studios/deferred/calls/example'
require 'rspec/sleeping_king_studios/deferred/calls/example_group'
require 'rspec/sleeping_king_studios/deferred/definitions'
require 'rspec/sleeping_king_studios/deferred/examples'

module RSpec::SleepingKingStudios::Deferred::Examples
  # Domain-specific language for defining deferred examples and test setup.
  module Dsl
    include RSpec::SleepingKingStudios::Deferred::Definitions

    # Meta-DSL for defining example and example group macros.
    module Meta
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

    extend Meta

    # Callback invoked when the module is extended into another module or class.
    #
    # Extends the class or module with the Dsl::Meta module.
    #
    # @param other [Module] the other module or class.
    #
    # @see RSpec::SleepingKingStudios::Deferred::Examples::Dsl::Meta.
    def self.extended(other)
      super

      other.extend(Meta)
    end

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

    # @!macro [new] define_example_method
    #   @!method $1(doc_string = nil, *flags, **metadata, &block)
    #     Defines a deferred example using the $1 method.
    #
    #     @param doc_string [String] the example's doc string.
    #     @param flags [Array<Symbol>] metadata flags for the example. Will be
    #       transformed into metadata entries with true values.
    #     @param metadata [Hash] metadata for the example.
    #     @param block [Proc] the implementation of the example.
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
end
