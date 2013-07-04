# lib/rspec/sleeping_king_studios/matchers/shared/parameters_matcher.rb

require 'rspec/sleeping_king_studios/matchers/shared'
require 'rspec/sleeping_king_studios/util/version'

module RSpec::SleepingKingStudios::Matchers::Shared
  module MatchParameters
    def ruby_version
      RSpec::SleepingKingStudios::Util::Version.new ::RUBY_VERSION
    end # method ruby_version

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

    def check_method_keywords method, keywords
      return nil unless ruby_version >= "2.0.0"

      parameters = method.parameters
      return nil if 0 < parameters.count { |type, _| :keyrest == type }

      mismatch = []
      keywords.each do |keyword|
        mismatch << keyword unless parameters.include?([:key, keyword])
      end # each

      mismatch.empty? ? nil : { :unexpected_keywords => mismatch }
    end # method check_method_keywords

    def check_method_block method
      0 == method.parameters.count { |type, | :block == type } ? { :expected_block => true } : nil
    end # method check_method_block

    private :check_method_arity, :check_method_block, :check_method_keywords, :ruby_version
  end # module
end # module
