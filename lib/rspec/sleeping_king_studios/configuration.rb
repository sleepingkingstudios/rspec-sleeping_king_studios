# frozen_string_literal: true

require 'rspec/sleeping_king_studios'

module RSpec::SleepingKingStudios
  # Configuration options for RSpec::SleepingKingStudios.
  class Configuration
    # Configuration options for RSpec::SleepingKingStudios::Examples.
    class Examples
      # Permitted options for :handle_missing_failure_message_with.
      MISSING_FAILURE_MESSAGE_HANDLERS = %i[ignore pending exception].freeze

      # Options for matching failure messages to strings.
      STRING_FAILURE_MESSAGE_MATCH_OPTIONS = %i[exact substring].freeze

      # Gets the handler for missing failure messages when using the matcher
      # examples, and sets to :pending if unset.
      #
      # @return [Symbol] The current missing message handler.
      def handle_missing_failure_message_with
        @handle_missing_failure_message_with ||= :pending
      end

      # Sets the handler for missing failure messages when using the matcher
      # examples.
      #
      # @param [Symbol] value The desired handler. Must be :ignore, :pending,
      #   or :exception.
      #
      # @raise ArgumentError If the handler is not one of the recognized
      #   values.
      def handle_missing_failure_message_with=(value)
        value = value.to_s.intern

        unless MISSING_FAILURE_MESSAGE_HANDLERS.include?(value)
          message =
            'unrecognized handler value -- must be in ' \
            "#{MISSING_FAILURE_MESSAGE_HANDLERS.join ', '}"

          raise ArgumentError, message
        end

        @handle_missing_failure_message_with = value
      end

      # Gets the option for matching failure messages to strings, and sets to
      # :substring if unset.
      #
      # @return [Symbol] The current failure message string matching option.
      def match_string_failure_message_as
        @match_string_failure_message_as ||= :substring
      end

      # Sets the option for matching failure messages to strings.
      #
      # @param [Symbol] value The desired option. Must be :exact, :substring, or
      #   :partial (alias of :substring).
      #
      # @raise ArgumentError If the handler is not one of the recognized
      #   values.
      def match_string_failure_message_as=(value)
        value = value.to_s.intern
        value = :substring if value == :partial

        unless STRING_FAILURE_MESSAGE_MATCH_OPTIONS.include?(value)
          message =
            'unrecognized value -- must be in ' \
            "#{STRING_FAILURE_MESSAGE_MATCH_OPTIONS.join ', '}"

          raise ArgumentError, message
        end

        @match_string_failure_message_as = value
      end
    end

    # Configuration options for RSpec::SleepingKingStudios::Matchers.
    class Matchers
      # Checks whether the #include matcher can be instantiated without an
      # expectation object or block.
      #
      # @return [Boolean] True if the empty include matchers are permitted,
      #   otherwise false.
      #
      # @deprecated [3.0] Will be removed in version 3.0.
      def allow_empty_include_matchers
        value = @allow_empty_include_matchers

        value.nil? ? true : value
      end
      alias allow_empty_include_matchers? allow_empty_include_matchers

      # Sets whether the #include matcher can be instantiated without an
      # expectation object or block. If this option is set to false, an
      # ArgumentError will be raised when attempting to instantiate an
      # IncludeMatcher without any expectations.
      #
      # This prevents an insidious bug when using the do..end block syntax to
      # create a block expectation while the matcher macro is itself an argument
      # to another function, such as ExpectationTarget#to. This bug causes the
      # block to be silently ignored and any enumerable object to match against
      # the matcher, even an empty object.
      #
      # @return [Boolean] True if the empty include matchers are permitted,
      #   otherwise false.
      #
      # @deprecated [3.0] Will be removed in version 3.0.
      def allow_empty_include_matchers=(value)
        @allow_empty_include_matchers = !!value
      end

      # Checks whether predicates are matched "strictly", meaning that they must
      # return either true or false.
      #
      # @return [Boolean] True if predicates are strictly matched, otherwise
      #   false.
      def strict_predicate_matching
        @strict_predicate_matching ||= false
      end
      alias strict_predicate_matching? strict_predicate_matching

      # Sets whether predicates are matched "strictly", meaning that they must
      # return either true or false.
      #
      # @param [Boolean] value The desired value. Is coerced to true or false.
      def strict_predicate_matching=(value)
        @strict_predicate_matching = !!value
      end
    end

    # Get or set the configuration options for
    # RSpec::SleepingKingStudios::Examples.
    def examples(&)
      @examples ||= RSpec::SleepingKingStudios::Configuration::Examples.new

      @examples.instance_eval(&) if block_given?

      @examples
    end

    # Get or set the configuration options for
    # RSpec::SleepingKingStudios::Matchers.
    def matchers(&)
      @matchers ||= RSpec::SleepingKingStudios::Configuration::Matchers.new

      @matchers.instance_eval(&) if block_given?

      @matchers
    end
  end
end

class RSpec::Core::Configuration # rubocop:disable Style/Documentation
  # Get or set the configuration options for RSpec::SleepingKingStudios.
  def sleeping_king_studios(&)
    @sleeping_king_studios ||= RSpec::SleepingKingStudios::Configuration.new

    @sleeping_king_studios.instance_eval(&) if block_given?

    @sleeping_king_studios
  end
end
