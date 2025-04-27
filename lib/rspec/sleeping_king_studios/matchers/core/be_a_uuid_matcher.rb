# frozen_string_literals: true

require 'rspec/sleeping_king_studios/matchers/base_matcher'
require 'rspec/sleeping_king_studios/matchers/core'

module RSpec::SleepingKingStudios::Matchers::Core
  # Matcher for testing whether an object is a UUID string.
  #
  # @since 2.5.0
  class BeAUuidMatcher < RSpec::SleepingKingStudios::Matchers::BaseMatcher
    include RSpec::Matchers::Composable

    # (see BaseMatcher#description)
    def description
      'be a UUID'
    end

    # (see BaseMatcher#failure_message)
    def failure_message
      message = super() + ', but '

      return message + 'was not a String' unless string?

      return message + 'was too short' if too_short?

      return message + 'was too long' if too_long?

      return message + 'has invalid characters' if invalid_characters?

      return message + 'the format is invalid' unless valid_format?

      message
    end

    # Checks if the object is a UUID string.
    #
    # @param [Object] actual The object to check.
    #
    # @return [Boolean] true if the object is a string with the correct format;
    #   otherwise false.
    def matches?(actual)
      super

      string? && valid_length? && valid_characters? && valid_format?
    end

    private

    def invalid_characters?
      @invalid_characters ||= @actual.match?(/[^A-Fa-f0-9\-]/)
    end

    def string?
      @string ||= @actual.is_a?(String)
    end

    def too_long?
      @too_long ||= @actual.length > 36
    end

    def too_short?
      @too_short ||= @actual.length < 36
    end

    def uuid_format
      chars = '[A-Fa-f0-9\-]'

      /\A#{chars}{8}-#{chars}{4}-#{chars}{4}-#{chars}{4}-#{chars}{12}\z/
    end

    def valid_characters?
      !invalid_characters?
    end

    def valid_format?
      @valid_format || @actual.match?(uuid_format)
    end

    def valid_length?
      !too_short? && !too_long?
    end
  end
end
