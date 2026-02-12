# frozen_string_literal: true

require 'sleeping_king_studios/tools/toolbelt'

require 'rspec/sleeping_king_studios/support/method_signature'

module RSpec::SleepingKingStudios::Support
  # @api private
  class MethodSignatureExpectation # rubocop:disable Metrics/ClassLength
    def initialize
      @min_arguments       = 0
      @max_arguments       = 0
      @unlimited_arguments = false
      @keywords            = []
      @any_keywords        = false
      @block_argument      = false
      @errors              = {}
    end

    attr_accessor :min_arguments, :max_arguments, :keywords

    attr_writer :any_keywords, :block_argument, :unlimited_arguments

    attr_reader :errors

    def description # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength, Metrics/PerceivedComplexity
      messages = []

      messages <<
        if min_arguments == max_arguments
          "#{min_arguments} argument#{'s' unless min_arguments == 1}"
        else
          "#{min_arguments}..#{max_arguments} arguments"
        end

      messages << 'unlimited arguments' if unlimited_arguments?

      unless keywords.empty?
        keywords_list = array_tools.humanize_list keywords.map(&:inspect)
        messages << "keyword#{'s' unless keywords.one?} #{keywords_list}"
      end

      messages << 'arbitrary keywords' if any_keywords?

      messages << 'a block' if block_argument?

      "with #{array_tools.humanize_list messages}"
    end

    def matches?(method)
      @signature = MethodSignature.new(method)
      @errors    = {}

      match = true
      match = false unless matches_arity?
      match = false unless matches_keywords?
      match = false unless matches_block?
      match
    end

    def any_keywords?
      !!@any_keywords
    end

    def block_argument?
      !!@block_argument
    end

    def unlimited_arguments?
      !!@unlimited_arguments
    end

    private

    attr_reader :signature

    def array_tools
      ::SleepingKingStudios::Tools::Toolbelt.instance.array_tools
    end

    def matches_arity? # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
      match = true

      if min_arguments < signature.min_arguments
        match = false

        @errors[:not_enough_args] = {
          expected: signature.min_arguments,
          received: min_arguments
        }
      end

      return match if signature.unlimited_arguments?

      if max_arguments > signature.max_arguments
        match = false

        @errors[:too_many_args] = {
          expected: signature.max_arguments,
          received: max_arguments
        }
      end

      if unlimited_arguments?
        match = false

        @errors[:no_variadic_args] = { expected: signature.max_arguments }
      end

      match
    end

    def matches_block?
      match = true

      if block_argument? && !signature.block_argument?
        match = false

        @errors[:no_block_argument] = true
      end

      match
    end

    def matches_keywords? # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
      match = true

      missing_keywords = signature.required_keywords - keywords
      unless missing_keywords.empty?
        match = false

        @errors[:missing_keywords] = missing_keywords
      end

      return match if signature.any_keywords?

      unexpected_keywords = keywords - signature.keywords
      unless unexpected_keywords.empty?
        match = false

        @errors[:unexpected_keywords] = unexpected_keywords
      end

      if any_keywords?
        match = false

        @errors[:no_variadic_keywords] = true
      end

      match
    end
  end
end
