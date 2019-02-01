# frozen_string_literals: true

require 'rspec/sleeping_king_studios/support'

module RSpec::SleepingKingStudios::Support
  # Encapsulates the value of a method call or block, and captures a snapshot of
  # the value at the time the spy is initialized.
  #
  # @example Observing a Method
  #   user  = Person.new(name: 'Alan Bradley')
  #   value = ValueSpy.new(user, :name)
  #   value.initial_value #=> 'Alan Bradley'
  #   value.current_value #=> 'Alan Bradley'
  #
  #   user.name = 'Ed Dillinger'
  #   value.initial_value #=> 'Alan Bradley'
  #   value.current_value #=> 'Ed Dillinger'
  #
  # @example Observing a Block
  #   value = ValueSpy.new { Person.where(virtual: false).count }
  #   value.initial_value #=> 4
  #   value.current_value #=> 4
  #
  #   Person.where(name: 'Kevin Flynn').enter_grid!
  #   value.initial_value #=> 4
  #   value.current_value #=> 3
  class ValueSpy
    # @overload initialize(receiver, method_name)
    #   @param [Object] receiver The object to watch.
    #
    #   @param [Symbol, String] method_name The name of the method to watch.
    #
    # @overload initialize(&block)
    #   @yield The value to watch. The block will be called each time the value
    #     is requested, and the return value of the block will be given as the
    #     current value.
    def initialize(receiver = nil, method_name = nil, &block)
      @observed_block = if block_given?
        block
      else
        @method_name = method_name

        -> { receiver.send(method_name) }
      end

      @receiver        = receiver
      @initial_hash    = current_value.hash
      @initial_inspect = current_value.inspect
      @initial_value   = current_value
    end

    # @return [Integer] the hash of the watched value at the time the spy was
    #   initialized.
    attr_reader :initial_hash

    # @return [String] the string representation of the watched value at the
    #   time the spy was initialized
    attr_reader :initial_inspect

    # @return [Object] the watched value at the time the spy was initialized.
    attr_reader :initial_value

    def changed?
      initial_value != current_value || initial_hash != current_value.hash
    end

    # @return [Object] the watched value when #current_value is called.
    def current_value
      @observed_block.call
    end

    # @return [String] a human-readable representation of the watched method or
    #   block.
    def description
      return 'result' unless @method_name

      format_message
    end

    private

    attr_reader :method_name

    attr_reader :receiver

    def format_message
      return "#{receiver}.#{method_name}" if receiver.is_a?(Module)

      "#{receiver.class}##{method_name}"
    end
  end
end
