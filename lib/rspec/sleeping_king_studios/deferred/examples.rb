# frozen_string_literal: true

require 'rspec/sleeping_king_studios/deferred'
require 'rspec/sleeping_king_studios/deferred/definitions'
require 'rspec/sleeping_king_studios/deferred/dsl'

module RSpec::SleepingKingStudios::Deferred
  # Defines a deferred example group for declaring shared tests.
  module Examples
    # Class methods for deferred examples.
    module ClassMethods
      # @return [Array<String, Integer>] the Ruby source filename and line
      #   number where the deferred example group was defined.
      attr_accessor :source_location

      # @return [String] the description for the deferred examples. By default,
      #   formats the last segment of the module name in lowercase words,
      #   excepting any trailing "Context" or "Examples".
      def description
        return @description if @description

        return @description = '(anonymous examples)' if name.nil?

        @description = format_description
      end

      # @param value [String] the description for the deferred examples.
      def description=(value)
        tools.assertions.validate_name(value, as: 'description')

        @description = value.to_s.tr('_', ' ')
      end

      # @return [Boolean] flag indicating that the included module has deferred
      #   examples, rather than including another deferred examples module.
      def deferred_examples?
        true
      end

      private

      def format_description
        name
          .split('::')
          .last
          .gsub(/(Context|Examples?)\z/, '')
          .then { |str| tools.string_tools.underscore(str) }
          .tr('_', ' ')
      end

      def tools
        SleepingKingStudios::Tools::Toolbelt.instance
      end
    end

    # Callback invoked when the module is included in another module or class.
    #
    # Extends the class or module with the Deferred::Definitions
    # and Deferred::Examples::DSL modules.
    #
    # @param other [Module] the other module or class.
    #
    # @see RSpec::SleepingKingStudios::Deferred::Definitions.
    # @see RSpec::SleepingKingStudios::Deferred::Examples::Dsl.
    def self.included(other)
      super

      other.extend  ClassMethods
      other.extend  RSpec::SleepingKingStudios::Deferred::Definitions
      other.extend  RSpec::SleepingKingStudios::Deferred::Dsl
      other.include RSpec::SleepingKingStudios::Deferred::Provider
      other.include RSpec::SleepingKingStudios::Deferred::Consumer

      location = caller_locations(1, 1).first

      other.source_location = [location.path, location.lineno]
    end
  end
end
