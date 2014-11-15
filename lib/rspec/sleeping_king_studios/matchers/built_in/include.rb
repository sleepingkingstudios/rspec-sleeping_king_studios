# lib/rspec/sleeping_king_studios/matchers/built_in/be_kind_of.rb

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
    # Converts the expected item to a human-readable string.
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
      message = super

      message << ", but it does not respond to `include?`" unless actual.respond_to?(:include?) || message =~ /does not respond to/

      message
    end # method failure_message_for_should

    # (see BaseMatcher#failure_message_when_negated)
    def failure_message_when_negated
      message = super

      message << ", but it does not respond to `include?`" unless actual.respond_to?(:include?) || message =~ /does not respond to/

      message
    end # method

    private

    def perform_match(predicate, hash_subset_predicate)
      return false unless actual.respond_to?(:include?)

      expected.__send__(predicate) do |expected_item|
        if comparing_proc?(expected_item)
          actual_matches_proc?(expected_item)
        elsif comparing_hash_to_a_subset?(expected_item)
          expected_item.__send__(hash_subset_predicate) do |(key, value)|
            actual_hash_includes?(key, value)
          end
        elsif comparing_hash_keys?(expected_item)
          actual_hash_has_key?(expected_item)
        else
          actual_collection_includes?(expected_item)
        end
      end
    end

    def actual_matches_proc? expected_item
      !!actual.detect(&expected_item)
    end # method actual_matches_proc?

    def comparing_proc? expected_item
      expected_item.is_a?(Proc)
    end # method comparing_proc?
  end # class
end # module

module RSpec::SleepingKingStudios::Matchers
  # @see RSpec::SleepingKingStudios::Matchers::BuiltIn::IncludeMatcher#matches?
  def include *expected, &block
    RSpec::SleepingKingStudios::Matchers::BuiltIn::IncludeMatcher.new *expected, &block
  end # method include
end # module
