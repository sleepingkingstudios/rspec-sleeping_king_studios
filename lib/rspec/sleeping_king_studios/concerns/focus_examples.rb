# lib/rspec/sleeping_king_studios/concerns/focus_examples.rb

require 'rspec/sleeping_king_studios/concerns'

module RSpec::SleepingKingStudios::Concerns
  # Convenience methods for automatically focusing or skipping shared example
  # groups.
  module FocusExamples
    # Includes the specified shared example group and wraps it inside an
    # `fdescribe` block named "(focused)". If the spec runner is set to run only
    # focused specs, this will ensure that the wrapped example group is run.
    #
    # @param [String] name The name of the shared example group to be wrapped.
    # @param [Array] args Optional array of arguments that are passed on to
    #   the shared example group.
    # @param [Hash] kwargs Optional hash of keyword arguments that are passed
    #   on to the shared example group.
    #
    # @yield Optional block that is passed on to the shared example group.
    #
    # @note Do not use this method with example groups that have side effects,
    #   e.g. define a memoized `#let` helper or a `#before` block that is
    #   intended to modify the behavior of sibling examples. Wrapping the
    #   example group in a `describe` block breaks that relationship. Best
    #   practice is to use the `#wrap_examples` method to safely encapsulate
    #   example groups with side effects, and the `#fwrap_examples` method to
    #   automatically focus such groups.
    def finclude_examples name, *args, **kwargs, &block
      fdescribe '(focused)' do
        if kwargs.empty?
          include_examples name, *args, &block
        else
          include_examples name, *args, **kwargs, &block
        end # if-else
      end # describe
    end # method wrap_examples
    alias_method :finclude_context, :finclude_examples

    # Includes the specified shared example group and wraps it inside an
    # `xdescribe` block named "(skipped)". This will ensure that the wrapped
    # example group is not run.
    #
    # @param [String] name The name of the shared example group to be wrapped.
    # @param [Array] args Optional array of arguments that are passed on to
    #   the shared example group.
    # @param [Hash] kwargs Optional hash of keyword arguments that are passed
    #   on to the shared example group.
    #
    # @yield Optional block that is passed on to the shared example group.
    #
    # @note Do not use this method with example groups that have side effects,
    #   e.g. define a memoized `#let` helper or a `#before` block that is
    #   intended to modify the behavior of sibling examples. Wrapping the
    #   example group in a `describe` block breaks that relationship. Best
    #   practice is to use the `#wrap_examples` method to safely encapsulate
    #   example groups with side effects, and the `#xwrap_examples` method to
    #   automatically skip such groups.
    # groups.
    def xinclude_examples name, *args, **kwargs, &block
      xdescribe '(focused)' do
        if kwargs.empty?
          include_examples name, *args, &block
        else
          include_examples name, *args, **kwargs, &block
        end # if-else
      end # describe
    end # method xinclude_examples
    alias_method :xinclude_context, :xinclude_examples
  end # module
end # module
