# lib/rspec/sleeping_king_studios/configuration.rb

require 'rspec/sleeping_king_studios'

module RSpec::SleepingKingStudios
  # Configuration options for RSpec::SleepingKingStudios.
  class Configuration
    # Configuration options for RSpec::SleepingKingStudios::Examples.
    class Examples
      # Permitted options for :handle_missing_failure_message_with.
      MISSING_FAILURE_MESSAGE_HANDLERS = %w(ignore pending exception).map(&:intern)

      # Gets the handler for missing failure messages when using the matcher
      # examples, and sets to :pending if unset.
      #
      # @return [Symbol] The current missing message handler.
      def handle_missing_failure_message_with
        @handle_missing_failure_message_with ||= :pending
      end # method missing_failure_message

      # Sets the handler for missing failure messages when using the matcher
      # examples.
      #
      # @param [Symbol] value The desired handler. Must be :ignore, :pending,
      #   or :exception.
      #
      # @raise ArgumentError If the handler is not one of the recognized
      #   values.
      def handle_missing_failure_message_with= value
        unless MISSING_FAILURE_MESSAGE_HANDLERS.include?(value)
          message = "unrecognized handler value -- must be in #{MISSING_FAILURE_MESSAGE_HANDLERS.join ', '}"
          raise ArgumentError.new message
        end # unless

        @handle_missing_failure_message_with = value
      end # message missing_failure_message=
    end # class

    # Get or set the configuration options for
    # RSpec::SleepingKingStudios::Examples.
    def examples &block
      (@examples ||= RSpec::SleepingKingStudios::Configuration::Examples.new).tap do |config|
        if block_given?
          config.instance_eval &block
        end # if
      end # tap
    end # method examples
  end # class
end # module

class RSpec::Core::Configuration
  # Get or set the configuration options for RSpec::SleepingKingStudios.
  def sleeping_king_studios &block
    (@sleeping_king_studios ||= RSpec::SleepingKingStudios::Configuration.new).tap do |config|
      if block_given?
        config.instance_eval &block
      end # if
    end # tap
  end # method sleeping_king_studios
end # class
