# lib/rspec/sleeping_king_studios/matchers/active_model/have_errors/error_expectation.rb

require 'rspec/sleeping_king_studios/matchers/active_model/have_errors/message_expectation'

# Helper objects for the ActiveModel::HaveErrorsMatcher.
module RSpec::SleepingKingStudios::Matchers::ActiveModel::HaveErrors
  # Stores an expectation of receiving an error for a specified attribute, as
  # well as zero or more message expectations.
  #
  # @since 1.0.0
  #
  # @see MessageExpectation
  class ErrorExpectation < Struct.new :attribute, :expected, :received
    # Extra instance methods for the :messages array.
    #
    # @api private
    module MessagesMethods
      # @return [Array<MessageExpectation>] Messages that are expected.
      def expected
        select { |message| message.expected }
      end # method expected

      # @return [Array<MessageExpectation>] Messages that are expected but have
      #   not been received.
      def missing
        select { |message| message.expected && !message.received }
      end # method missing

      # @return [Array<MessageExpectation>] Messages that have been received.
      def received
        select { |message| message.received }
      end # method received
    end # module

    # @param [String, Symbol] attribute The attribute for which an error is
    #   expected to be or has been received.
    # @param [Boolean] expected Whether an error is expected for the specified
    #   attribute.
    # @param [Boolean] received Whether an error has been received for the
    #   specified attribute.
    def initialize attribute, expected = true, received = false
      super attribute.intern, expected, received

      @messages = []
      class << @messages
        include MessagesMethods
      end # eigenclass
    end # constructor

    # The message expectations for the specified attribute. The returned array
    # supports several additional methods: #expected, #missing, and #received.
    #
    # @return [Array<MessageExpectation>]
    #
    # @see MessagesMethods#expected
    # @see MessagesMethods#missing
    # @see MessagesMethods#received
    attr_reader :messages
  end # class
end # module
