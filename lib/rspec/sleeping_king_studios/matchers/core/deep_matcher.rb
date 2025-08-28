# frozen_string_literal: true

require 'hashdiff'

require 'rspec/sleeping_king_studios/matchers/base_matcher'
require 'rspec/sleeping_king_studios/matchers/core'

module RSpec::SleepingKingStudios::Matchers::Core
  # Matcher for performing a deep comparison between two objects.
  #
  # @since 2.5.0
  class DeepMatcher < RSpec::SleepingKingStudios::Matchers::BaseMatcher # rubocop:disable Metrics/ClassLength
    include RSpec::Matchers::Composable

    # @param [Object] expected the expected object.
    def initialize(expected)
      super()

      @expected = expected
    end

    # (see BaseMatcher#description)
    def description
      "match #{format_expected(@expected)}"
    end

    # Inverse of #matches? method.
    #
    # @param [Object] actual the object to check.
    #
    # @return [Boolean] true if the actual object does not match the
    #   expectation, otherwise true.
    #
    # @see #matches?
    def does_not_match?(actual) # rubocop:disable Metrics/MethodLength, Naming/PredicatePrefix
      super

      if matcher?(@expected)
        delegate_to_negated_matcher(@expected)
      elsif @expected.is_a?(Array) && actual.is_a?(Array)
        diff_arrays_negated
      elsif @expected.is_a?(Hash) && actual.is_a?(Hash)
        diff_hashes_negated
      else
        delegate_to_negated_matcher(equality_matcher)
      end

      !@matches
    end

    # (see BaseMatcher#failure_message)
    def failure_message # rubocop:disable Style/TrivialAccessors
      @failure_message
    end

    # (see BaseMatcher#failure_message_when_negated)
    def failure_message_when_negated # rubocop:disable Style/TrivialAccessors
      @failure_message_when_negated
    end

    # Performs a deep comparison between the actual object and the expected
    # object. The type of comparison depends on the type of the expected object:
    #
    # - If the expected object is an RSpec matcher, the #matches? method on the
    #   matcher is called with the expected object.
    # - If the expected object is an Array, then each item is compared based on
    #   the type of the expected item.
    # - If the expected object is a Hash, then the keys must match and each
    #   value is compared based on the type of the expected value.
    # - Otherwise, the two objects are compared using an equality comparison.
    #
    # @param [Object] actual the object to check.
    #
    # @return [Boolean] true if the actual object matches the expectation,
    #   otherwise false.
    def matches?(actual) # rubocop:disable Metrics/MethodLength
      super

      if matcher?(@expected)
        delegate_to_matcher(@expected)
      elsif @expected.is_a?(Array) && actual.is_a?(Array)
        diff_arrays
      elsif @expected.is_a?(Hash)  && actual.is_a?(Hash)
        diff_hashes
      else
        delegate_to_matcher(equality_matcher)
      end

      @matches
    end

    private

    def compare_arrays(expected, actual)
      compare_hashes({ _ary: expected }, { _ary: actual })
        .map { |(char, path, *values)| [char, path[1..], *values] }
    end

    def compare_hashes(expected, actual)
      Hashdiff.diff(expected, actual, array_path: true, use_lcs: false) \
      do |path, exp, act|
        # Handle missing keys with matcher values.
        next nil unless nested_key?(actual, path)

        next exp.matches?(act) if matcher?(exp)
      end
    end

    def delegate_to_matcher(matcher)
      @matches = matcher.matches?(actual)

      return if @matches

      @failure_message = matcher.failure_message
    end

    def delegate_to_negated_matcher(matcher)
      @matches =
        if matcher.respond_to?(:does_not_match?)
          !matcher.does_not_match?(actual)
        else
          matcher.matches?(actual)
        end

      return unless @matches

      @failure_message_when_negated = matcher.failure_message_when_negated
    end

    def diff_arrays
      diff     = compare_arrays(@expected, actual)
      @matches = diff.empty?

      @failure_message = format_message(diff)
    end

    def diff_arrays_negated
      diff     = compare_arrays(@expected, actual)
      @matches = diff.empty?

      @failure_message_when_negated =
        "`expect(#{format_expected(@expected)}).not_to be == " \
        "#{format_expected(@actual)}`"
    end

    def diff_hashes
      diff     = compare_hashes(@expected, actual)
      @matches = diff.empty?

      @failure_message = format_message(diff)
    end

    def diff_hashes_negated
      diff     = compare_hashes(@expected, actual)
      @matches = diff.empty?

      @failure_message_when_negated =
        "`expect(#{format_expected(@expected)}).not_to be == " \
        "#{format_expected(@actual)}`"
    end

    def equality_matcher # rubocop:disable Naming/PredicateMethod
      matchers_delegate.be == @expected
    end

    def format_diff(diff)
      diff
        .sort_by { |(_char, path, *_values)| [path.map(&:to_s)] }
        .map { |item| format_diff_item(*item) }
        .join "\n"
    end

    def format_diff_item(char, path, *values)
      "#{char} #{format_diff_path(path)} => #{format_diff_values(char, values)}"
    end

    def format_diff_path(path)
      path.map(&:inspect).join('.')
    end

    def format_diff_values(char, values)
      case char
      when '-'
        "expected #{format_expected(values.first)}"
      when '~'
        "expected #{format_expected(values.first)}, got " \
        "#{format_expected(values.last)}"
      when '+'
        "got #{format_expected(values.last)}"
      end
    end

    def format_expected(object)
      RSpec::Support::ObjectFormatter.format(object)
    end

    def format_message(diff)
      "expected: == #{format_expected(@expected)}\n" \
        "     got:    #{format_expected(@actual)}\n" \
        "\n" \
        "(compared using Hashdiff)\n" \
        "\n" \
        "Diff:\n" \
        "#{format_diff(diff)}"
    end

    def matcher?(object)
      %i[description failure_message failure_message_when_negated matches?]
        .all? { |method_name| object.respond_to?(method_name) }
    end

    def matchers_delegate
      Object.new.extend RSpec::Matchers
    end

    def nested_key?(object, path)
      key    = path.last
      object = object.dig(*path[0...-1]) if path.size > 1

      return object.key?(key) if object.is_a?(Hash)
      return object.size > key if object.is_a?(Array)

      false
    end
  end
end
