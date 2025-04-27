# frozen_string_literal: true

require 'rspec/sleeping_king_studios/matchers/base_matcher'
require 'rspec/sleeping_king_studios/matchers/core'

module RSpec::SleepingKingStudios::Matchers::Core
  # Matcher for testing whether an object aliases a specified method using the
  # specified other method name.
  #
  # @since 2.2.0
  #
  # @note Prior to 2.7.0, this was named AliasMethodMatcher.
  class HaveAliasedMethodMatcher < RSpec::SleepingKingStudios::Matchers::BaseMatcher
    include RSpec::Matchers::Composable

    # @param [String, Symbol] original_name The name of the method that is
    #   expected to have an alias.
    def initialize(original_name)
      @original_name = original_name.intern
    end

    # Specifies the name of the new method.
    #
    # @param [String, Symbol] aliased_name The method name.
    #
    # @return [AliasMethodMatcher] self
    def as(aliased_name)
      @aliased_name = aliased_name

      self
    end

    # (see BaseMatcher#description)
    def description
      str = "alias :#{original_name}"

      str += " as #{aliased_name.inspect}" if aliased_name

      str
    end

    # (see BaseMatcher#failure_message)
    def failure_message
      message = "expected #{@actual.inspect} to alias :#{original_name}"

      message += " as #{aliased_name.inspect}" if aliased_name

      if @errors[:does_not_respond_to_old_method]
        message += ", but did not respond to :#{original_name}"

        return message
      end

      if @errors[:does_not_respond_to_new_method]
        message += ", but did not respond to :#{aliased_name}"

        return message
      end

      if @errors[:does_not_alias_method]
        message +=
          ", but :#{original_name} and :#{aliased_name} are different "\
          "methods"

        return message
      end

      message
    end

    # (see BaseMatcher#matches?)
    def matches?(actual)
      super

      @errors = {}

      if aliased_name.nil?
        raise ArgumentError.new('must specify a new method name')
      end

      responds_to_methods? && aliases_method?
    end

    private

    attr_reader :aliased_name

    attr_reader :original_name

    def aliases_method?
      unless @actual.method(original_name) == @actual.method(aliased_name)
        @errors[:does_not_alias_method] = true

        return false
      end

      true
    end

    def responds_to_methods?
      unless @actual.respond_to?(original_name)
        @errors[:does_not_respond_to_old_method] = true

        return false
      end

      unless @actual.respond_to?(aliased_name)
        @errors[:does_not_respond_to_new_method] = true

        return false
      end

      true
    end
  end
end
