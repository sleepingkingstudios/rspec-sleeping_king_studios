# lib/rspec/sleeping_king_studios/support/method_signature_expectation.rb

require 'rspec/sleeping_king_studios/support/method_signature'

require 'sleeping_king_studios/tools/array_tools'

module RSpec::SleepingKingStudios::Support
  # @api private
  class MethodSignatureExpectation
    def initialize
      @min_arguments       = 0
      @max_arguments       = 0
      @unlimited_arguments = false
      @keywords            = []
      @any_keywords        = false
      @block_argument      = false
      @errors              = {}
    end # method initialize

    attr_accessor :min_arguments, :max_arguments, :keywords

    attr_writer :any_keywords, :block_argument, :unlimited_arguments

    attr_reader :errors

    def description
      messages = []

      if min_arguments == max_arguments
        messages << "#{min_arguments} argument#{1 == min_arguments ? '' : 's'}"
      else
        messages << "#{min_arguments}..#{max_arguments} arguments"
      end # if-else

      messages << 'unlimited arguments' if unlimited_arguments?

      unless keywords.empty?
        keywords_list = array_tools.humanize_list keywords.map(&:inspect)
        messages << "keyword#{1 == keywords.count ? '' : 's'} #{keywords_list}"
      end # if

      messages << 'arbitrary keywords' if any_keywords?

      messages << 'a block' if block_argument?

      "with #{array_tools.humanize_list messages}"
    end # method description

    def matches? method
      @signature = MethodSignature.new(method)
      @errors    = {}

      match = true
      match = false unless matches_arity?
      match = false unless matches_keywords?
      match = false unless matches_block?
      match
    end # method matches?

    def any_keywords?
      !!@any_keywords
    end # method any_keywords?

    def block_argument?
      !!@block_argument
    end # method block_argument?

    def unlimited_arguments?
      !!@unlimited_arguments
    end # method unlimited_arguments?

    private

    attr_reader :signature

    def array_tools
      ::SleepingKingStudios::Tools::ArrayTools
    end # method array_tools

    def matches_arity?
      match = true

      if min_arguments < signature.min_arguments
        match = false

        @errors[:not_enough_args] = {
          :expected => signature.min_arguments,
          :received => min_arguments
        } # end hash
      end # if

      if signature.unlimited_arguments?

      else
        if max_arguments > signature.max_arguments
          match = false

          @errors[:too_many_args] = {
            :expected => signature.max_arguments,
            :received => max_arguments
          } # end hash
        end # if-else

        if unlimited_arguments?
          match = false

          @errors[:no_variadic_args] = {
            :expected => signature.max_arguments
          } # end hash
        end # if
      end # if-else

      match
    end # method matches_arity?

    def matches_block?
      match = true

      if block_argument? && !signature.block_argument?
        match = false

        @errors[:no_block_argument] = true
      end # if

      match
    end # method matches_block?

    def matches_keywords?
      match = true

      missing_keywords = signature.required_keywords - keywords
      unless missing_keywords.empty?
        match = false

        @errors[:missing_keywords] = missing_keywords
      end # unless

      if signature.any_keywords?

      else
        unexpected_keywords = keywords - signature.keywords
        unless unexpected_keywords.empty?
          match = false

          @errors[:unexpected_keywords] = unexpected_keywords
        end # unless

        if any_keywords?
          match = false

          @errors[:no_variadic_keywords] = true
        end # if
      end # if-else

      match
    end # method matches_keywords?
  end # class
end # module
