# lib/rspec/sleeping_king_studios/matchers/built_in/include_matcher.rb

require 'rspec/sleeping_king_studios/matchers/built_in'

module RSpec::SleepingKingStudios::Matchers::BuiltIn
  # Extensions to the built-in RSpec #include matcher.
  class IncludeMatcher < RSpec::Matchers::BuiltIn::Include
    # @param [Array<Hash, Proc, Object>] expected the items expected to be
    #   matched by the actual object
    #
    # @yield If a block is provided, the block is converted to a proc and
    #   appended to the item expectations.
    # @yieldparam [Object] item An item from the actual object; yield(item)
    #   should return true if and only if the item matches the desired
    #   predicate.
    def initialize *expected, &block
      expected << block if block_given?

      super *expected
    end # constructor

    # @api private
    #
    # @return [Boolean]
    def matches?(actual)
      perform_match(actual) { |v| v }
    end # method matches?

    # @api private
    #
    # @return [Boolean]
    def does_not_match?(actual)
      perform_match(actual) { |v| !v }
    end # method does_not_match?

    # @api private
    #
    # Converts the expected item to a human-readable string. Retained for
    # pre-3.3 compatibility.
    def to_word expected_item
      case
      when is_matcher_with_description?(expected_item)
        expected_item.description
      when Proc === expected_item
        "an item matching the block"
      else
        expected_item.inspect
      end # case
    end # method to_word

    # (see BaseMatcher#failure_message)
    def failure_message
      message = super.sub ':__block_comparison__', 'an item matching the block'

      message << ", but it does not respond to `include?`" unless actual.respond_to?(:include?) || message =~ /does not respond to/

      message
    end # method failure_message_for_should

    # (see BaseMatcher#failure_message_when_negated)
    def failure_message_when_negated
      message = super.sub ':__block_comparison__', 'an item matching the block'

      message << ", but it does not respond to `include?`" unless actual.respond_to?(:include?) || message =~ /does not respond to/

      message
    end # method

    private

    # @api private
    def perform_match(actual, &block)
      @actual = actual
      @divergent_items = excluded_from_actual(&block)
      actual.respond_to?(:include?) && @divergent_items.empty?
    end # method perform_match

    # @api private
    def excluded_from_actual
      return [] unless @actual.respond_to?(:include?)

      expected.inject([]) do |memo, expected_item|
        if comparing_proc?(expected_item)
          memo << :__block_comparison__ unless yield actual_matches_proc?(expected_item)
        elsif comparing_hash_to_a_subset?(expected_item)
          expected_item.each do |(key, value)|
            memo << { key => value } unless yield actual_hash_includes?(key, value)
          end # each
        elsif comparing_hash_keys?(expected_item)
          memo << expected_item unless yield actual_hash_has_key?(expected_item)
        else
          memo << expected_item unless yield actual_collection_includes?(expected_item)
        end # if-elsif-else

        memo
      end # inject
    end # method excluded_from_actual

    # @api private
    def actual_matches_proc? expected_item
      !!actual.detect(&expected_item)
    end # method actual_matches_proc?

    # @api private
    def comparing_proc? expected_item
      expected_item.is_a?(Proc)
    end # method comparing_proc?
  end # class
end # module