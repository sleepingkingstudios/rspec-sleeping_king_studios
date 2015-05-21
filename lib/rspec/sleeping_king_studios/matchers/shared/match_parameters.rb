# lib/rspec/sleeping_king_studios/matchers/shared/parameters_matcher.rb

require 'rspec/sleeping_king_studios/matchers'

module RSpec::SleepingKingStudios::Matchers::Shared
  # Helper methods for checking the parameters and keywords (Ruby 2.0 only) of
  # a method.
  module MatchParameters
    # Checks whether the method accepts the specified number or range of
    # arguments.
    #
    # @param [Method] method the method to check
    # @param [Integer, Range] arity the expected number or range of parameters
    #
    # @return [Boolean] true if the method accepts the specified number or both
    #   the specified minimum and maximum number of parameters; otherwise false
    def check_method_arity method, arity, expect_unlimited_arguments: false
      parameters = method.parameters
      required   = parameters.count { |type, | :req  == type }
      optional   = parameters.count { |type, | :opt  == type }
      variadic   = parameters.count { |type, | :rest == type }
      reasons    = {}

      reasons[:expected_unlimited_arguments] = { count: required + optional } if 0 == variadic && expect_unlimited_arguments

      min, max = arity.is_a?(Range) ?
        [arity.begin, arity.end] :
        [arity,       arity]

      if min && min < required
        reasons[:not_enough_args] = { arity: min, count: required }
      elsif max && 0 == variadic && max > required + optional
        reasons[:too_many_args]   = { arity: max, count: required + optional }
      end # if

      reasons.empty? ? nil : reasons
    end # method check_method_arity

    # Checks whether the method accepts the specified keywords.
    #
    # @param [Method] method the method to check
    # @param [Array<String, Symbol>] keywords the expected keywords
    #
    # @return [Boolean] true if the method accepts the specified keywords;
    #   otherwise false
    def check_method_keywords method, keywords, expect_arbitrary_keywords: false
      keywords ||= []
      parameters = method.parameters
      reasons    = {}

      # Check for missing required keywords.
      if RUBY_VERSION >= "2.1.0"
        missing = []
        parameters.select { |type, _| :keyreq == type }.each do |_, keyword|
          missing << keyword unless keywords.include?(keyword)
        end # each

        reasons[:missing_keywords] = missing unless missing.empty?
      end # if

      unless 0 < parameters.count { |type, _| :keyrest == type }
        reasons[:expected_arbitrary_keywords] = true if expect_arbitrary_keywords

        mismatch = []
        keywords.each do |keyword|
          mismatch << keyword unless
            parameters.include?([:key,    keyword]) ||
            parameters.include?([:keyreq, keyword])
        end # each

        reasons[:unexpected_keywords] = mismatch unless mismatch.empty?
      end # unless

      reasons.empty? ? nil : reasons
    end # method check_method_keywords

    # Checks whether the method expects a block.
    #
    # @param [Method] method the method to check
    #
    # @return [Boolean] true if the method expects a block argument; otherwise
    #   false
    def check_method_block method
      0 == method.parameters.count { |type, | :block == type } ? { :expected_block => true } : nil
    end # method check_method_block

    private :check_method_arity, :check_method_block, :check_method_keywords
  end # module
end # module
