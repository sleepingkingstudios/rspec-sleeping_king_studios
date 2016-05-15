# lib/rspec/sleeping_king_studios/matchers/shared/parameters_matcher.rb

require 'rspec/sleeping_king_studios/matchers'
require 'rspec/sleeping_king_studios/support/method_signature_expectation'

module RSpec::SleepingKingStudios::Matchers::Shared
  # Helper methods for checking the parameters and keywords (Ruby 2.0 only) of
  # a method.
  module MatchParameters

    # Convenience method for more fluent specs. Does nothing and returns self.
    #
    # @return self
    def argument
      self
    end # method argument
    alias_method :arguments, :argument

    # Adds a parameter count expectation and/or one or more keyword
    # expectations.
    #
    # @overload with count
    #   Adds a parameter count expectation.
    #
    #   @param [Integer, Range, nil] count (optional) The number of expected
    #     parameters.
    #
    #   @return [RespondToMatcher] self
    # @overload with *keywords
    #   Adds one or more keyword expectations.
    #
    #   @param [Array<String, Symbol>] keywords List of keyword arguments
    #     accepted by the method.
    #
    #   @return self
    # @overload with count, *keywords
    #   Adds a parameter count expectation and one or more keyword
    #   expectations.
    #
    #   @param [Integer, Range, nil] count (optional) The number of expected
    #     parameters.
    #   @param [Array<String, Symbol>] keywords List of keyword arguments
    #     accepted by the method.
    #
    #   @return self
    def with *keywords
      case keywords.first
      when Range
        arity = keywords.shift

        method_signature_expectation.min_arguments = arity.begin
        method_signature_expectation.max_arguments = arity.end
      when Integer
        arity = keywords.shift

        method_signature_expectation.min_arguments = arity
        method_signature_expectation.max_arguments = arity
      end # case

      method_signature_expectation.keywords = keywords

      self
    end # method with

    # Adds a block expectation. The actual object will only match a block
    # expectation if it expects a parameter of the form &block.
    #
    # @return self
    def with_a_block
      method_signature_expectation.block_argument = true

      self
    end # method with_a_block
    alias_method :and_a_block, :with_a_block

    # Adds an arbitrary keyword expectation, e.g. that the method supports
    # any keywords with splatted hash arguments of the form **kwargs.
    def with_arbitrary_keywords
      method_signature_expectation.any_keywords = true

      self
    end # method with_arbitrary_keywords
    alias_method :and_arbitrary_keywords, :with_arbitrary_keywords
    alias_method :with_any_keywords,      :with_arbitrary_keywords
    alias_method :and_any_keywords,       :with_any_keywords

    # Adds one or more keyword expectations.
    #
    # @param [Array<String, Symbol>] keywords List of keyword arguments
    #   accepted by the method.
    #
    # @return self
    def with_keywords *keywords
      method_signature_expectation.keywords = keywords

      self
    end # method with_keywords
    alias_method :and_keywords, :with_keywords

    # Adds an unlimited parameter count expectation, e.g. that the method
    # supports splatted array arguments of the form *args.
    #
    # @return self
    def with_unlimited_arguments
      method_signature_expectation.unlimited_arguments = true

      self
    end # method with_unlimited_arguments
    alias_method :and_unlimited_arguments, :with_unlimited_arguments

    private

    # @api private
    def check_method_signature method
      method_signature_expectation.matches?(method)
    end # method check_method_signature

    # @api private
    def format_errors errors
      messages = []

      # TODO: Replace this with "  expected :arity arguments, but method can "\
      # "receive :count arguments", with :count being one of the following:
      # - an integer (for methods that do not have optional or variadic params)
      # - between :min and :max (for methods with optional but not variadic
      #   params)
      # - at least :min (for methods with variadic params)
      if hsh = errors.fetch(:not_enough_args, false)
        messages << "  expected at least #{hsh[:expected]} arguments, but received #{hsh[:received]}"
      end # if

      if hsh = errors.fetch(:too_many_args, false)
        messages << "  expected at most #{hsh[:expected]} arguments, but received #{hsh[:received]}"
      end # if

      # TODO: Replace this with "  expected method to receive unlimited "\
      # "arguments, but method can receive at most :max arguments"
      if hsh = errors.fetch(:no_variadic_args, false)
        messages << "  expected at most #{hsh[:expected]} arguments, but received unlimited arguments"
      end # if

      # TODO: Replace this with "  expected method to receive arbitrary "\
      # "keywords, but the method can receive :keyword_list", with
      # :keyword_list being a comma-separated list. If the method cannot
      # receive keywords, replace last fragment with ", but the method cannot"\
      # " receive keywords"
      if errors.fetch(:no_variadic_keywords, false)
        messages << "  expected arbitrary keywords"
      end # if

      # TODO: Replace this with "  expected method to receive keywords "\
      # ":received_list, but the method requires keywords :required_list"
      if ary = errors.fetch(:missing_keywords, false)
        messages << "  missing #{pluralize ary.count, 'keyword', 'keywords'} #{humanize_list ary.map(&:inspect)}"
      end # if

      # TODO: Replace this with "  expected method to receive keywords "\
      # ":received_list, but the method can receive :keyword_list"
      if ary = errors.fetch(:unexpected_keywords, false)
        messages << "  unexpected #{pluralize ary.count, 'keyword', 'keywords'} #{humanize_list ary.map(&:inspect)}"
      end # if

      # TODO: Replace this with "  expected method to receive a block "\
      # "argument, but the method signature does not specify a block argument"
      if errors.fetch(:no_block_argument, false)
        messages << "  unexpected block"
      end # if

      messages.join "\n"
    end # method format_errors

    # @api private
    def method_signature_expectation
      @method_signature_expectation ||=
        ::RSpec::SleepingKingStudios::Support::MethodSignatureExpectation.new
    end # method_signature_expectation

    # @api private
    def method_signature_expectation?
      !!@method_signature_expectation
    end # method_signature_expectation
  end # module
end # module
