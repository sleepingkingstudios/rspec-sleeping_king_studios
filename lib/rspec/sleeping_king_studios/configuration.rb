# lib/rspec/sleeping_king_studios/configuration.rb

require 'rspec/sleeping_king_studios'

module RSpec::SleepingKingStudios
  class Configuration
    class Examples
      MISSING_FAILURE_MESSAGE_HANDLERS = %w(ignore pending exception).map(&:intern)

      def handle_missing_failure_message_with
        @handle_missing_failure_message_with ||= :pending
      end # method missing_failure_message

      def handle_missing_failure_message_with= value
        unless MISSING_FAILURE_MESSAGE_HANDLERS.include?(value)
          message = "unrecognized handler value -- must be in #{MISSING_FAILURE_MESSAGE_HANDLERS.join ', '}"
          raise ArgumentError.new message
        end # unless

        @handle_missing_failure_message_with = value
      end # message missing_failure_message=
    end # class
    
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
  def sleeping_king_studios &block
    (@sleeping_king_studios ||= RSpec::SleepingKingStudios::Configuration.new).tap do |config|
      if block_given?
        config.instance_eval &block
      end # if
    end # tap
  end # method sleeping_king_studios
end # class
