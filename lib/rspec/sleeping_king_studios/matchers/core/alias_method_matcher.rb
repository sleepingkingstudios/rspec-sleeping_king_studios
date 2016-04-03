# lib/rspec/sleeping_king_studios/matchers/core/alias_method_matcher.rb

require 'rspec/sleeping_king_studios/matchers/base_matcher'
require 'rspec/sleeping_king_studios/matchers/core'

module RSpec::SleepingKingStudios::Matchers::Core
  # Matcher for testing whether an object aliases a specified method using the
  # specified other method name.
  #
  # @since 2.2.0
  class AliasMethodMatcher < RSpec::SleepingKingStudios::Matchers::BaseMatcher
    # @param [String, Symbol] expected The name of the method that is expected
    #   to be aliased.
    def initialize expected
      @old_method_name = @expected = expected.intern
      @errors          = {}
    end # method initialize

    # Specifies the name of the new method.
    #
    # @param [String, Symbol] new_method_name The method name.
    #
    # @return [AliasMethodMatcher] self
    def as new_method_name
      @new_method_name = new_method_name

      self
    end # method as

    # (see BaseMatcher#description)
    def description
      str = "alias :#{old_method_name}"

      str << " as #{new_method_name.inspect}" if new_method_name

      str
    end # method description

    # (see BaseMatcher#failure_message)
    def failure_message
      message = "expected #{@actual.inspect} to alias :#{old_method_name}"

      message << " as #{new_method_name.inspect}" if new_method_name

      if @errors[:does_not_respond_to_old_method]
        message << ", but did not respond to :#{old_method_name}"

        return message
      end # if

      if @errors[:does_not_respond_to_new_method]
        message << ", but did not respond to :#{new_method_name}"

        return message
      end # if

      if @errors[:does_not_alias_method]
        message <<
          ", but :#{old_method_name} and :#{new_method_name} are different "\
          "methods"

        return message
      end # if

      message
    end # method failure_message

    # (see BaseMatcher#matches?)
    def matches? actual
      super

      raise ArgumentError.new('must specify a new method name') if new_method_name.nil?

      responds_to_methods? && aliases_method?
    end # method matches?

    private

    attr_reader :old_method_name, :new_method_name

    def aliases_method?
      unless @actual.method(old_method_name) == @actual.method(new_method_name)
        @errors[:does_not_alias_method] = true

        return false
      end # unless

      true
    end # method aliases_method?

    def responds_to_methods?
      unless @actual.respond_to?(old_method_name)
        @errors[:does_not_respond_to_old_method] = true

        return false
      end # unless

      unless @actual.respond_to?(new_method_name)
        @errors[:does_not_respond_to_new_method] = true

        return false
      end # unless

      true
    end # method responds_to_methods?
  end # class
end # module
