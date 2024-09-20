# frozen_string_literal: true

require 'rspec/sleeping_king_studios/deferred/call'
require 'rspec/sleeping_king_studios/deferred/dsl'

module RSpec::SleepingKingStudios::Deferred::Dsl # rubocop:disable Style/Documentation
  # Domain-specific language for defining deferred example constants.
  #
  # @see RSpec::SleepingKingStudios::Concerns::ExampleConstants.
  module ExampleConstants
    # Defines a deferred temporary class scoped to the current example.
    #
    # @param class_name [String] the qualified name of the class.
    # @param base_class [Class, String] the base class or name of the base
    #   class. This can be the name of another example class, as long as the
    #   base class is defined earlier in the example group or in a parent
    #   example group.
    #
    # @yield definitions for the temporary class.  This block is evaluated in
    #     the context of the example, meaning that methods or memoized helpers
    #     can be referenced.
    # @yieldparam klass [Class] the temporary class.
    def example_class(class_name, base_class = nil, &)
      deferred_calls <<
        RSpec::SleepingKingStudios::Deferred::Call.new(
          :example_class,
          class_name,
          base_class,
          &
        )

      nil
    end

    # @overload example_constant(constant_name, constant_value)
    #   Defines a deferred temporary constant scoped to the current example.
    #
    #   @param constant_name [String] the qualified name of the constant.
    #   @param constant_value [Object] the value of the constant.
    #
    # @overload example_constant(constant_name, &block)
    #   Defines a deferred temporary constant scoped to the current example.
    #
    #   @param constant_name [String] the qualified name of the constant.
    #
    #   @yield generates the constant value. This block is evaluated in the
    #     context of the example, meaning that methods or memoized helpers can
    #     be referenced.
    #   @yieldreturn the value of the constant.
    #
    # @deprecate 2.8.0 with force: true parameter.
    def example_constant(
      qualified_name,
      constant_value = nil,
      force: false,
      &block
    )
      deferred_calls <<
        RSpec::SleepingKingStudios::Deferred::Call.new(
          :example_constant,
          qualified_name,
          *(constant_value.nil? ? [] : [constant_value]),
          force:,
          &block
        )

      nil
    end
  end

  include ExampleConstants
end
