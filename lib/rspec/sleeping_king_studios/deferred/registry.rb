# frozen_string_literal: true

require 'sleeping_king_studios/tools/toolbelt'

require 'rspec/sleeping_king_studios/deferred'

module RSpec::SleepingKingStudios::Deferred
  # Methods for registering deferred examples.
  module Registry
    # Exception raised when the requested deferred examples are not defined.
    class DeferredExamplesNotFoundError < StandardError; end

    # Class methods for registering deferred examples.
    module ClassMethods
      # @api private
      def add_deferred_examples(description, &block)
        raise ArgumentError, 'block is required' unless block_given?

        tools.assertions.validate_name(description, as: 'description')

        defined_deferred_examples[description.to_s] = block

        nil
      end

      # @api private
      def defined_deferred_examples
        @defined_deferred_examples ||= {}
      end

      # @api private
      def find_deferred_examples(description)
        tools.assertions.validate_name(description, as: 'description')

        deferred = find_deferred_by_description(description.to_s)

        return deferred if deferred

        message =
          'deferred examples not found with description ' \
          "#{description.to_s.inspect}"

        raise DeferredExamplesNotFoundError, message
      end

      protected

      def find_deferred_by_name(description, const_name, full_name)
        if defined_deferred_examples.key?(description)
          return defined_deferred_examples[description]
        end

        return const_get(const_name) if const_defined?(const_name, false)

        const_get(full_name) if full_name && const_defined?(full_name, false)
      end

      private

      def find_deferred_by_description(description) # rubocop:disable Metrics/MethodLength
        const_name =
          tools.string_tools.camelize(description.tr(' ', '_').tr('-', ' '))
        full_name  =
          const_name.end_with?('Examples') ? nil : "#{const_name}Examples"

        ancestors.each do |ancestor|
          break unless ancestor.respond_to?(:defined_deferred_examples)

          deferred =
            ancestor.find_deferred_by_name(description, const_name, full_name)

          return deferred if deferred
        end

        nil
      end

      def tools
        SleepingKingStudios::Tools::Toolbelt.instance
      end
    end

    # Callback invoked when the module is included in another module or class.
    #
    # Extends ClassMethods into the other module.
    #
    # @param other [Module] the other module or class.
    def self.included(other)
      super

      other.extend(ClassMethods)
    end
  end
end
