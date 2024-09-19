# frozen_string_literal: true

require 'rspec/sleeping_king_studios/concerns'

module RSpec::SleepingKingStudios::Concerns
  # Methods for defining example-scoped classes and constants.
  module ExampleConstants # rubocop:disable Metrics/ModuleLength
    DEFAULT_VALUE = Object.new.freeze
    private_constant :DEFAULT_VALUE

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

      # @api private
      def with_constant( # rubocop:disable Metrics/MethodLength
        constant_name:,
        constant_value:,
        namespace:,
        force: false
      )
        guard_existing_constant!(namespace, constant_name) unless force

        prior_value = DEFAULT_VALUE

        if namespace.const_defined?(constant_name)
          prior_value = namespace.const_get(constant_name)
        end

        namespace.const_set(constant_name, constant_value)

        yield
      ensure
        if prior_value == DEFAULT_VALUE
          namespace.send :remove_const, constant_name
        else
          namespace.const_set(constant_name, prior_value)
        end
      end

      # @api private
      def with_namespace(module_names) # rubocop:disable Metrics/MethodLength
        last_defined = nil

        resolved =
          module_names.reduce(Object) do |namespace, module_name|
            if namespace.const_defined?(module_name)
              next namespace.const_get(module_name)
            end

            last_defined ||= { namespace:, module_name: }

            namespace.const_set(module_name, Module.new)
          end

        yield resolved
      ensure
        if last_defined
          last_defined[:namespace]
            .send(:remove_const, last_defined[:module_name])
        end
      end

      private

      def guard_existing_constant!(namespace, constant_name)
        return unless namespace.const_defined?(constant_name)

        message =
          "constant #{constant_name} is already defined with value " \
          "#{namespace.const_get(constant_name).inspect}"

        raise NameError, message
      end

      def resolve_base_class(value)
        value = value.fetch(:base_class, nil) if value.is_a?(Hash)

        return Object if value.nil?

        return Object.const_get(value) if value.is_a?(String)

        value
      end
    end

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

    def example_constant( # rubocop:disable Metrics/MethodLength
      qualified_name,
      constant_value = DEFAULT_VALUE,
      force: false,
      &block
    )
      around(:example) do |wrapped_example|
        resolved_value =
          if constant_value == DEFAULT_VALUE && block_given?
            wrapped_example.example.instance_exec(&block)
          else
            constant_value
          end

        *module_names, constant_name = qualified_name.to_s.split('::')

        ExampleConstants.with_namespace(module_names) do |namespace|
          ExampleConstants.with_constant(
            constant_name:,
            constant_value: resolved_value,
            namespace:,
            force:
          ) \
          do
            wrapped_example.call
          end
        end
      end
    end
  end
end
