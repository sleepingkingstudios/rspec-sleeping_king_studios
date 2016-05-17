# lib/rspec/sleeping_king_studios/support/method_signature.rb

require 'rspec/sleeping_king_studios/support'

module RSpec::SleepingKingStudios::Support
  # @api private
  class MethodSignature
    def initialize method
      parameters = method.parameters

      required = parameters.count { |type, _| :req  == type }
      optional = parameters.count { |type, _| :opt  == type }
      variadic = parameters.count { |type, _| :rest == type }

      @min_arguments       = required
      @max_arguments       = required + optional
      @unlimited_arguments = variadic > 0

      required = parameters.select { |type, _| :keyreq  == type }.map { |_, keyword| keyword }
      optional = parameters.select { |type, _| :key     == type }.map { |_, keyword| keyword }
      variadic = parameters.count  { |type, _| :keyrest == type }

      @required_keywords = required
      @optional_keywords = optional
      @any_keywords      = variadic > 0

      @block_argument = parameters.count { |type, _| :block == type } > 0
    end # method initialize

    attr_reader :min_arguments,
      :max_arguments,
      :optional_keywords,
      :required_keywords

    def any_keywords?
      !!@any_keywords
    end # method any_keywords?

    def block_argument?
      !!@block_argument
    end # method block_argument?

    def keywords
      @optional_keywords + @required_keywords
    end # method keywords

    def unlimited_arguments?
      !!@unlimited_arguments
    end # method unlimited_arguments?
  end # class
end # module
