# lib/rspec/sleeping_king_studios/concerns/example_constants.rb

require 'rspec/sleeping_king_studios/concerns'

module RSpec::SleepingKingStudios::Concerns
  module ExampleConstants
    DEFAULT_VALUE = Object.new.freeze
    private_constant :DEFAULT_VALUE

    def self.assign_constant namespace, constant_name, constant_value
      prior_value = DEFAULT_VALUE

      if namespace.const_defined?(constant_name)
        prior_value = namespace.const_get(constant_name)
      end # if

      namespace.const_set(constant_name, constant_value)

      yield
    ensure
      if prior_value == DEFAULT_VALUE
        namespace.send :remove_const, constant_name
      else
        namespace.const_set(constant_name, prior_value)
      end # if-else
    end # class method assign_constant

    def self.guard_existing_constant! namespace, constant_name
      return unless namespace.const_defined?(constant_name)

      message =
        "constant #{constant_name} is already defined with value "\
        "#{namespace.const_get(constant_name).inspect}"

      raise NameError, message
    end # class method guard_existing_constant!

    def self.resolve_base_class value
      return Object if value.nil?

      return Object.const_get(value) if value.is_a?(String)

      value
    end

    def self.resolve_namespace module_names
      last_defined = nil

      resolved =
        module_names.reduce(Object) do |ns, module_name|
          next ns.const_get(module_name) if ns.const_defined?(module_name)

          last_defined ||= { :namespace => ns, :module_name => module_name }

          ns.const_set(module_name, Module.new)
        end # reduce

      yield resolved
    ensure
      if last_defined
        last_defined[:namespace].send(:remove_const, last_defined[:module_name])
      end # if
    end # class method resolve_namespace

    def example_class class_name, base_class: Object, &block
      class_name = class_name.to_s if class_name.is_a?(Symbol)

      example_constant(class_name) do
        klass = Class.new(ExampleConstants.resolve_base_class(base_class))

        klass.define_singleton_method(:name) { class_name }
        klass.singleton_class.send(:alias_method, :inspect, :name)
        klass.singleton_class.send(:alias_method, :to_s,    :name)

        instance_exec(klass, &block) if block_given?

        klass
      end # example_constant
    end # method example_class

    def example_constant qualified_name, constant_value = DEFAULT_VALUE, force: false, &block
      around(:example) do |wrapped_example|
        example = wrapped_example.example

        resolved_value =
          if constant_value == DEFAULT_VALUE
            block ? example.instance_exec(&block) : nil
          else
            constant_value
          end # if

        module_names  = qualified_name.to_s.split('::')
        constant_name = module_names.pop

        ExampleConstants.resolve_namespace(module_names) do |namespace|
          ExampleConstants.guard_existing_constant!(namespace, constant_name) unless force

          ExampleConstants.assign_constant(namespace, constant_name, resolved_value) do
            wrapped_example.call
          end # assign_constant
        end # resolve_namespace
      end # before example
    end # method example_constant
  end # module
end # module
