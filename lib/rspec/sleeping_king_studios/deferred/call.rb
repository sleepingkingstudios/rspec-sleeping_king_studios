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

    # Invokes the deferred method call on the receiver.
    #
    # @param receiver [Object] the receiver for the method call.
    #
    # @return [Object] the returned value of the method call.
    def call(receiver)
      receiver.send(method_name, *arguments, **keywords, &block)
    end

    # @return [Symbol, nil] the type of deferred call.
    def type
      nil
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
