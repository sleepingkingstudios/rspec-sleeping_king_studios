# frozen_string_literal: true

require 'sleeping_king_studios/tools/toolbelt'

require 'rspec/sleeping_king_studios/deferred'

module RSpec::SleepingKingStudios::Deferred
  # Value object representing a deferred call to a method.
  class Call
    # @param method_name [String, Symbol] the name of the method to call.
    # @param arguments [Array] the arguments to pass to the method.
    # @param keywords [Hash] the keywords to pass to the method.
    # @param block [Proc] the block to pass to the method.
    def initialize(method_name, *arguments, **keywords, &block)
      @method_name = method_name
      @arguments   = arguments
      @keywords    = keywords
      @block       = block

      validate_parameters!
    end

    # @return [Array] the arguments to pass to the method.
    attr_reader :arguments

    # @return [Proc] the block to pass to the method.
    attr_reader :block

    # @return [Hash] the keywords to pass to the method.
    attr_reader :keywords

    # @return [String, Symbol] the name of the method to call.
    attr_reader :method_name

    # Compares the other object with the deferred call.
    #
    # Returns true if and only if:
    # - The other object is an instance of Deferred::Call.
    # - The other object's method name and type match the deferred call.
    # - The other object's arguments, keywords, and block all match the deferred
    #   call.
    #
    # @param other [Object] the object to compare.
    #
    # @return [Boolean] true if the other matches the deferred call; otherwise
    #   false.
    def ==(other)
      other.class == self.class &&
        other.method_name == method_name &&
        other.arguments == arguments &&
        other.keywords == keywords &&
        other.block == block
    end

    # Invokes the deferred method call on the receiver.
    #
    # @param receiver [Object] the receiver for the method call.
    #
    # @return [Object] the returned value of the method call.
    def call(receiver)
      receiver.send(method_name, *arguments, **keywords, &block)
    end

    private

    def tools
      SleepingKingStudios::Tools::Toolbelt.instance
    end

    def validate_parameters!
      tools.assertions.validate_name(method_name, as: 'method_name')
    end
  end
end
