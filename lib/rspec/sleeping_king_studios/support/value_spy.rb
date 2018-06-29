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
    # @overload initialize(object, method_name)
    #   @param [Object] object The object to watch.
    #
    #   @param [Symbol, String] method_name The name of the method to watch.
    #
    # @overload initialize(&block)
    #   @yield The value to watch. The block will be called each time the value
    #     is requested, and the return value of the block will be given as the
    #     current value.
    def initialize(object = nil, method_name = nil, &block)
      @observed_block = if block_given?
        block
      else
        @method_name = method_name

        -> { object.send(method_name) }
      end

      @initial_value = current_value
    end

    # @return [Object] the watched value at the time the spy was initialized.
    attr_reader :initial_value

    def changed?
      !RSpec::Support::FuzzyMatcher.values_match?(initial_value, current_value)
    end

    # @return [Object] the watched value when #current_value is called.
    def current_value
      @observed_block.call
    end

    # @return [String] a human-readable representation of the watched method or
    #   block.
    def description
      return 'result' unless @method_name

      "##{@method_name}"
    end
  end
end
