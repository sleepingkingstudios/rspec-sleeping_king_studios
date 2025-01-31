# frozen_string_literal: true

require 'rspec/sleeping_king_studios/deferred'

module RSpec::SleepingKingStudios::Deferred
  # Mixin for declaring dependent methods for deferred example groups.
  #
  # Each dependent method is expected to have a definition, either as a direct
  # method definition (using the `def` keyword or `define_method`), or via  a
  # memoized helper (such as `let`).
  #
  # When the deferred examples are included in an example group and that example
  # group is run, a before(:context) hook will check for all of the declared
  # dependencies of that example group. If any of the expected dependencies are
  # not defined, the hook will raise an exception listing the missing methods,
  # the deferred examples that expect that method, and the description provided.
  #
  # @example
  #   module RocketExamples
  #     include RSpec::SleepingKingStudios::Deferred::Provider
  #
  #     deferred_examples 'should launch the rocket' do
  #       include RSpec::SleepingKingStudios::Deferred::Dependencies
  #
  #       depends_on :rocket,
  #         'an instance of Rocket where #launched? returns false'
  #
  #       describe '#launch' do
  #         it 'should launch the rocket' do
  #           expect { rocket.launch }.to change(rocket, :launched?).to be true
  #         end
  #       end
  #     end
  #   end
  module Dependencies
    extend SleepingKingStudios::Tools::Toolbox::Mixin

    # Exception raised when declared dependencies are not defined.
    class MissingDependenciesError < StandardError; end

    # Class methods for declaring dependent methods.
    module ClassMethods
      # @private
      def call(example_group)
        super

        metadata_key = :deferred_dependencies_check_added

        return if example_group.metadata[metadata_key]

        example_group.metadata[metadata_key] = true

        example_group.before(:context) do
          RSpec::SleepingKingStudios::Deferred::Dependencies
            .check_dependencies_for(self)
        end
      end

      # @private
      def dependent_methods
        @dependent_methods ||= []
      end

      # Declares an external method dependency.
      #
      # @param method_name [String, Symbol] the name of the expected method.
      # @param description [String] a short description of the method.
      #
      # @return [void]
      def depends_on(method_name, description = nil)
        dependent_methods << {
          deferred_group: self,
          description:,
          method_name:    method_name.to_s.sub(/\A#/, '').intern
        }

        nil
      end
    end

    class << self
      # Checks for missing dependent methods for the given example.
      #
      # @param example [RSpec::Core::Example] the example to check.
      #
      # @raise [MissingDependenciesError] if there are any dependencies missing
      #   for the given example.
      def check_dependencies_for(example)
        missing = missing_dependencies_for(example)

        return if missing.empty?

        raise MissingDependenciesError, generate_missing_message(missing)
      end

      private

      def all_dependencies_for(example)
        example
          .class
          .ancestors
          .select { |ancestor| ancestor.respond_to?(:dependent_methods) }
          .flat_map(&:dependent_methods)
      end

      def generate_missing_message(missing) # rubocop:disable Metrics/MethodLength
        [
          'Unable to run specs with deferred example groups because the ' \
          'following methods are not defined in the examples:',
          *missing
            .group_by { |item| item[:deferred_group] }
            .map do |deferred_group, dependencies|
              message_for_group(deferred_group, dependencies)
            end,
          'Please define the missing methods or :let helpers.'
        ]
          .join("\n\n")
      end

      def message_for_group(deferred_group, dependencies)
        message = "Missing methods for #{deferred_group.description.inspect}:"

        dependencies.each do |hsh|
          message += "\n  ##{hsh[:method_name]}"
          message += ": #{hsh[:description]}" if hsh[:description]
        end

        message
      end

      def missing_dependencies_for(example)
        all_dependencies_for(example).reject do |hsh|
          example.respond_to?(hsh[:method_name])
        end
      end
    end
  end
end
