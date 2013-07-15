# lib/rspec/sleeping_king_studios/matchers/shared/parameters_matcher.rb

require 'rspec/sleeping_king_studios/matchers/shared/require'

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
    def check_method_arity method, arity
      parameters = method.parameters
      required   = parameters.count { |type, | :req  == type }
      optional   = parameters.count { |type, | :opt  == type }
      variadic   = parameters.count { |type, | :rest == type }

      min, max = arity.is_a?(Range) ?
        [arity.begin, arity.end] :
        [arity,       arity]

      if min < required
        return { :not_enough_args => { arity: min, count: required } }
      elsif 0 == variadic && max > required + optional
        return { :too_many_args   => { arity: max, count: required + optional } }
      end # if

      nil
    end # method check_method_arity

    # Checks whether the method accepts the specified keywords.
    # 
    # @param [Method] method the method to check
    # @param [Array<String, Symbol>] keywords the expected keywords
    # 
    # @return [Boolean] true if the method accepts the specified keywords;
    #   otherwise false
    def check_method_keywords method, keywords
      return nil unless RUBY_VERSION >= "2.0.0"

      parameters = method.parameters
      return nil if 0 < parameters.count { |type, _| :keyrest == type }

      mismatch = []
      keywords.each do |keyword|
        mismatch << keyword unless parameters.include?([:key, keyword])
      end # each

      mismatch.empty? ? nil : { :unexpected_keywords => mismatch }
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
