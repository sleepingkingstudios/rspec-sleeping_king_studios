# frozen_string_literal: true

require 'rspec/sleeping_king_studios/concerns'

module RSpec::SleepingKingStudios::Concerns
  # Methods for defining example-scoped classes and constants.
  module ExampleConstants
    DEFAULT_VALUE = Object.new.freeze
    private_constant :DEFAULT_VALUE

    # @api private
    ExampleConstant = Struct.new(:name, :value)

    # @api private
    module HoistedMethods
      # @api private
      def apply_example_constants(example_constants) # rubocop:disable Metrics/MethodLength
        return if example_constants_applied?

        example_constants.each do |example_constant|
          resolved_value =
            if example_constant.value.is_a?(Proc)
              instance_exec(&example_constant.value)
            else
              example_constant.value
            end

          stub_const(example_constant.name, resolved_value)
        end

        @example_constants_applied = true
      end

      private

      def example_constants_applied?
        @example_constants_applied
      end
    end

    class << self
      # @api private
      def define_class(class_name:, example:, base_class: nil, &block)
        klass = Class.new(resolve_base_class(base_class))

        klass.define_singleton_method(:name) { class_name }
        klass.singleton_class.send(:alias_method, :inspect, :name)
        klass.singleton_class.send(:alias_method, :to_s,    :name)

        example.instance_exec(klass, &block) if block_given?

        klass
      end

      private

      def resolve_base_class(value)
        value = value.fetch(:base_class, nil) if value.is_a?(Hash)

        return Object if value.nil?

        return Object.const_get(value) if value.is_a?(String)

        value
      end
    end

    # @api private
    def each_example_constant(&)
      return enum_for(:each_example_constant) unless block_given?

      ancestors.reverse_each do |ancestor|
        next unless ancestor.respond_to?(:defined_example_constants, true)

        ancestor.defined_example_constants.each(&)
      end
    end

    # Defines a temporary class scoped to the current example.
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
    def example_class(class_name, base_class = nil, &block)
      class_name = class_name.to_s if class_name.is_a?(Symbol)

      example_constant(class_name) do
        ExampleConstants.define_class(
          base_class:,
          class_name:,
          example:    self,
          &block
        )
      end
    end

    # @overload example_constant(constant_name, constant_value)
    #   Defines a temporary constant scoped to the current example.
    #
    #   @param constant_name [String] the qualified name of the constant.
    #   @param constant_value [Object] the value of the constant.
    #
    # @overload example_constant(constant_name, &block)
    #
    #   @param constant_name [String] the qualified name of the constant.
    #
    #   @yield generates the constant value. This block is evaluated in the
    #     context of the example, meaning that methods or memoized helpers can
    #     be referenced.
    #   @yieldreturn the value of the constant.
    #
    # @deprecate 2.8.0 with force: true parameter.
    def example_constant( # rubocop:disable Metrics/MethodLength
      constant_name,
      constant_value = nil,
      force: false,
      &block
    )
      if force
        SleepingKingStudios::Tools::Toolbelt
          .instance
          .core_tools
          .deprecate(
            'ExampleConstants.example_constant with force: true',
            message: 'The :force parameter is no longer required.'
          )
      end

      defined_example_constants << ExampleConstant.new(
        constant_name,
        constant_value || block
      )

      # Ensure that the example constants are defined before all other :before
      # hooks, even those defined on parent example groups.
      hoist_example_constants!
    end

    protected

    def defined_example_constants
      @defined_example_constants ||= []
    end

    def hoist_example_constants!
      top_level_example_group =
        ancestors
        .reverse_each
        .find { |ancestor| ancestor < RSpec::Core::ExampleGroup }

      return if top_level_example_group < HoistedMethods

      top_level_example_group.include HoistedMethods

      top_level_example_group.prepend_before(:example) do
        apply_example_constants(self.class.each_example_constant)
      end
    end
  end
end
