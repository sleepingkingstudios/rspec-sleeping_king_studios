# frozen_string_literal: true

require 'rspec/sleeping_king_studios/matchers/built_in'
require 'rspec/sleeping_king_studios/matchers/description'

module RSpec::SleepingKingStudios::Matchers::BuiltIn
  # Extensions to the built-in RSpec #include matcher.
  class IncludeMatcher < RSpec::Matchers::BuiltIn::Include # rubocop:disable Metrics/ClassLength
    include RSpec::SleepingKingStudios::Matchers::Description

    # @param [Array<Hash, Proc, Object>] expected the items expected to be
    #   matched by the actual object
    #
    # @yield If a block is provided, the block is converted to a proc and
    #   appended to the item expectations.
    # @yieldparam [Object] item An item from the actual object; yield(item)
    #   should return true if and only if the item matches the desired
    #   predicate.
    def initialize(*expected, &block) # rubocop:disable Metrics/MethodLength
      if block_given?
        SleepingKingStudios::Tools::CoreTools
          .deprecate('IncludeMatcher with a block')

        expected << block
      end

      if expected.empty? && !allow_empty_matcher?
        raise ArgumentError,
          'must specify an item expectation',
          caller
      end

      super(*expected)
    end

    # (see BaseMatcher#description)
    def description
      desc = super

      # Replace processed block expectation stub with proper description.
      desc.gsub ':__block_comparison__', 'an item matching the block'
    end

    # @api private
    #
    # @return [Boolean]
    def matches?(actual)
      @actual = actual

      perform_match(actual) { |v| v }
    end

    # @api private
    #
    # @return [Boolean]
    def does_not_match?(actual) # rubocop:disable Naming/PredicatePrefix
      @actual = actual

      perform_match(actual, &:!)
    end

    # (see BaseMatcher#failure_message)
    def failure_message
      message = super.sub ':__block_comparison__', 'an item matching the block'

      unless actual.respond_to?(:include?) || message =~ /does not respond to/
        message << ', but it does not respond to `include?`'
      end

      message
    end

    # (see BaseMatcher#failure_message_when_negated)
    def failure_message_when_negated
      message = super.sub ':__block_comparison__', 'an item matching the block'

      unless actual.respond_to?(:include?) || message =~ /does not respond to/
        message << ', but it does not respond to `include?`'
      end

      message
    end

    private

    def actual_matches_proc?(expected_item)
      if actual.respond_to?(:detect)
        !!actual.detect(&expected_item)
      else
        !!expected_item.call(actual)
      end
    end

    # @deprecated [3.0] Will be removed in version 3.0.
    def allow_empty_matcher?
      return false unless RSpec::Expectations::Version::STRING < '3.12.2'

      RSpec
        .configure { |config| config.sleeping_king_studios.matchers }
        .allow_empty_include_matchers?
    end

    def comparing_proc?(expected_item)
      expected_item.is_a?(Proc)
    end

    def expected_items_for_description
      items = defined?(expecteds) ? expecteds : @expected

      # Preprocess items to stub out block expectations.
      items.map { |item| item.is_a?(Proc) ? :__block_comparison__ : item }
    end

    def find_excluded_items(&)
      items = defined?(expecteds) ? expecteds : expected

      return [] unless @actual.respond_to?(:include?)

      items.each.with_object([]) do |expected_item, excluded_items|
        match_excluded_item(expected_item, excluded_items, &)
      end
    end

    def match_excluded_hash_keys(expected_item, excluded_items)
      return if yield actual_hash_has_key?(expected_item)

      excluded_items << expected_item
    end

    def match_excluded_hash_subset(expected_item, excluded_items)
      expected_item.each do |(key, value)|
        next if yield actual_hash_includes?(key, value)

        excluded_items << { key => value }
      end
    end

    def match_excluded_item(expected_item, excluded_items, &)
      if comparing_proc?(expected_item)
        match_excluded_proc(expected_item, excluded_items, &)
      elsif comparing_hash_to_a_subset?(expected_item)
        match_excluded_hash_subset(expected_item, excluded_items, &)
      elsif comparing_hash_keys?(expected_item)
        match_excluded_hash_keys(expected_item, excluded_items, &)
      else
        match_excluded_value(expected_item, excluded_items, &)
      end
    end

    def match_excluded_proc(expected_item, excluded_items)
      return if yield actual_matches_proc?(expected_item)

      excluded_items << :__block_comparison__
    end

    def match_excluded_value(expected_item, excluded_items)
      return if yield actual_collection_includes?(expected_item)

      excluded_items << expected_item
    end

    def perform_match(actual, &) # rubocop:disable Naming/PredicateMethod
      @actual = actual
      @divergent_items = find_excluded_items(&)
      actual.respond_to?(:include?) && @divergent_items.empty?
    end
  end
end
