require 'rspec/sleeping_king_studios/support'

module RSpec::SleepingKingStudios::Support
  # Encapsulates the value of a method call or block, and captures a snapshot of
  # the value when the observation is initialized for later comparison.
  #
  # @example Observing a Method
  #   user  = Person.new(name: 'Alan Bradley')
  #   value = ValueObservation.new(user, :name)
  #   value.initial_value #=> 'Alan Bradley'
  #   value.current_value #=> 'Alan Bradley'
  #
  #   user.name = 'Ed Dillinger'
  #   value.initial_value #=> 'Alan Bradley'
  #   value.current_value #=> 'Ed Dillinger'
  #
  # @example Observing a Block
  #   value = ValueObservation.new { Person.where(virtual: false).count }
  #   value.initial_value #=> 4
  #   value.current_value #=> 4
  #
  #   Person.where(name: 'Kevin Flynn').enter_grid!
  #   value.initial_value #=> 4
  #   value.current_value #=> 3
  class ValueObservation
    # @overload initialize(object, method_name)
    #   @param [Object] object The object to observe.
    #
    #   @param [Symbol, String] method_name The name of the method to observe.
    #
    # @overload initialize(&block)
    #   @yield The value to observe. The block will be called each time the
    #     value is requested, and the return value of the block will be given as
    #     the current value.
    def initialize(object = nil, method_name = nil, &block)
      @observation = if block_given?
        block
      else
        @method_name = method_name

        -> { object.send(method_name) }
      end

      @initial_value = current_value
    end

    # @return [Object] the observed value at the time the observation was
    #   initialized.
    attr_reader :initial_value

    def changed?
      !RSpec::Support::FuzzyMatcher.values_match?(initial_value, current_value)
    end

    # @return [Object] the observed value when #current_value is called.
    def current_value
      @observation.call
    end

    # @return [String] a human-readable representation of the observed method
    #   or block.
    def description
      return 'result' unless @method_name

      "##{@method_name}"
    end
  end
end
