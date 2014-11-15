# lib/rspec/sleeping_king_studios/matchers/active_model/have_errors/message_expectation.rb

require 'rspec/sleeping_king_studios/matchers/active_model'

module RSpec::SleepingKingStudios::Matchers::ActiveModel::HaveErrors
  # Stores an expectation of receiving a specified error message.
  class MessageExpectation < Struct.new :message, :expected, :received
    # @param [String] message The message which is expected to be or has been
    #   received.
    # @param [Boolean] expected Whether the message is expected.
    # @param [Boolean] received Whether the message has been received.
    def initialize message, expected = true, received = false
      super message, expected, received
    end # constructor
  end # class
end # module
