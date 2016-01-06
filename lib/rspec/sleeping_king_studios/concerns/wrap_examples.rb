# lib/rspec/sleeping_king_studios/concerns/wrap_examples.rb

require 'rspec/sleeping_king_studios/concerns'

module RSpec::SleepingKingStudios::Concerns
  # Methods for encapsulating shared example groups to include contexts or
  # examples without affecting the surrounding context.
  #
  # @examples
  module WrapExamples
    # Includes the specified shared example group and wraps it inside a
    # `describe` block. If a block is provided, it is evaluated in the
    # context of the describe block after the example group has been included.
    #
    # @param [String] name The name of the shared example group to be wrapped.
    # @param [Array] args Optional array of arguments that are passed on to
    #   the shared example group.
    # @param [Hash] kwargs Optional hash of keyword arguments that are passed
    #   on to the shared example group.
    #
    # @yield Additional code to run in the context of the wrapping `describe`
    #   block, such as additional examples or memoized values.
    def wrap_examples name, *args, **kwargs, &block
      describe name do
        include_examples name, *args, **kwargs

        instance_eval(&block) if block_given?
      end # describe
    end # method wrap_examples
    alias_method :wrap_context, :wrap_examples

    # Includes the specified shared example group and wraps it inside a
    # focused `fdescribe` block. If a block is provided, it is evaluated in the
    # context of the fdescribe block after the example group has been included.
    #
    # @param [String] name The name of the shared example group to be wrapped.
    # @param [Array] args Optional array of arguments that are passed on to
    #   the shared example group.
    # @param [Hash] kwargs Optional hash of keyword arguments that are passed
    #   on to the shared example group.
    #
    # @yield Additional code to run in the context of the wrapping `fdescribe`
    #   block, such as additional examples or memoized values.
    def fwrap_examples name, *args, **kwargs, &block
      fdescribe name do
        include_examples name, *args, **kwargs

        instance_eval(&block) if block_given?
      end # describe
    end # method fwrap_examples
    alias_method :fwrap_context, :fwrap_examples

    # Includes the specified shared example group and wraps it inside a
    # skipped `xdescribe` block. If a block is provided, it is evaluated in the
    # context of the xdescribe block after the example group has been included.
    # Mostly used to temporarily disable a wrapped example group while updating
    # or debugging a spec.
    #
    # @param [String] name The name of the shared example group to be wrapped.
    # @param [Array] args Optional array of arguments that are passed on to
    #   the shared example group.
    # @param [Hash] kwargs Optional hash of keyword arguments that are passed
    #   on to the shared example group.
    #
    # @yield Additional code to run in the context of the wrapping `fdescribe`
    #   block, such as additional examples or memoized values.
    def xwrap_examples name, *args, **kwargs, &block
      xdescribe name do
        include_examples name, *args, **kwargs

        instance_eval(&block) if block_given?
      end # describe
    end # method fwrap_examples
    alias_method :xwrap_context, :xwrap_examples
  end # module
end # module
