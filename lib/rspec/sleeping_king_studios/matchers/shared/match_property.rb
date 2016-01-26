# lib/rspec/sleeping_king_studios/matchers/shared/match_property.rb

module RSpec::SleepingKingStudios::Matchers::Shared
  # Helper methods for checking reader and writer methods and values.
  module MatchProperty
    private

    # Checks whether the value of the predicate matches the expected value. If
    # the value looks like an RSpec matcher (it responds to :matches?), runs
    # value.matches?(); otherwise checks for equality using :==.
    #
    # @return [Boolean] true if the value matches the expected value; otherwise
    #   false.
    def matches_predicate_value?
      return false unless responds_to_predicate?
      return true  unless @value_set

      actual_value = @actual.send(:"#{@expected}?")

      @matches_predicate_value = (@value.respond_to?(:matches?) && @value.respond_to?(:description)) ?
        @value.matches?(actual_value) :
        @value == actual_value
    end # method matches_reader_value?

    # Checks whether the value of the reader matches the expected value. If the
    # value looks like an RSpec matcher (it responds to :matches?), runs
    # value.matches?(); otherwise checks for equality using :==.
    #
    # @return [Boolean] true if the value matches the expected value; otherwise
    #   false.
    def matches_reader_value?
      return false unless responds_to_reader?
      return true  unless @value_set

      actual_value = @actual.send(@expected)

      @matches_reader_value = (@value.respond_to?(:matches?) && @value.respond_to?(:description)) ?
        @value.matches?(actual_value) :
        @value == actual_value
    end # method matches_reader_value?

    # Checks whether the object responds to the predicate method :#{property}?.
    #
    # @return [Boolean] true if the object responds to the method; otherwise
    #   false.
    def responds_to_predicate?
      @matches_predicate = @actual.respond_to?(:"#{@expected}?")
    end # method responds_to_predicate?

    # Checks whether the object responds to the reader method :#{property}.
    #
    # @return [Boolean] true if the object responds to the method; otherwise
    #   false.
    def responds_to_reader?
      @matches_reader = @actual.respond_to?(@expected)
    end # method responds_to_reader?

    # Checks whether the object responds to the writer method :#{property}=.
    #
    # @return [Boolean] true if the object responds to the method; otherwise
    #   false.
    def responds_to_writer?
      @matches_writer = @actual.respond_to?(:"#{@expected}=")
    end # method responds_to_reader?

    # Formats the expected value as a human-readable string. If the value looks
    # like an RSpec matcher (it responds to :matches? and :description), calls
    # value#description; otherwise calls value#inspect.
    #
    # @return [String] the value as a human-readable string.
    def value_to_string
      return @value.description if @value.respond_to?(:matches?) && @value.respond_to?(:description)

      @value.inspect
    end # method value_to_string
  end # module
end # module
