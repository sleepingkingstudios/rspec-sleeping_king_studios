# frozen_string_literal: true

require 'rspec/sleeping_king_studios'

module RSpec::SleepingKingStudios
  # Namespace for deferred example functionality.
  module Deferred
    autoload :Call,         'rspec/sleeping_king_studios/deferred/call'
    autoload :Calls,        'rspec/sleeping_king_studios/deferred/calls'
    autoload :Consumer,     'rspec/sleeping_king_studios/deferred/consumer'
    autoload :Definitions,  'rspec/sleeping_king_studios/deferred/definitions'
    autoload :Dependencies, 'rspec/sleeping_king_studios/deferred/dependencies'
    autoload :Dsl,          'rspec/sleeping_king_studios/deferred/dsl'
    autoload :Examples,     'rspec/sleeping_king_studios/deferred/examples'
    autoload :Missing,      'rspec/sleeping_king_studios/deferred/missing'
    autoload :Provider,     'rspec/sleeping_king_studios/deferred/provider'

    class << self
      # Returns the full path of an example, including deferred example groups.
      #
      # By default, returns the path in a single-line format similar to an
      # example group description. Deferred example groups are parenthesized.
      # When the :source_locations flag is set to true, it instead returns each
      # example group or deferred group on its own line, along with the source
      # location for that group.
      #
      # @param example [RSpec::Core::Example] the example to examine.
      # @param source_locations [true, false] if true, returns the path in a
      #   multi-line format including the source location for each group.
      #
      # @return [String] the generated example path.
      #
      # @example Displaying the full path of failing specs:
      #   config.after(:example) do |example|
      #     next unless ENV['REFLECT_ON_FAILURE']
      #     next unless example.metadata[:last_run_status] == 'failed'
      #
      #     STDERR.puts "\nFailing spec at:"
      #
      #     path =
      #       RSpec::SleepingKingStudios::Deferred
      #       .reflect(example, source_locations: true)
      #     path =
      #       SleepingKingStudios::Tools::Toolbelt
      #         .instance
      #         .string_tools
      #         .indent(path)
      #
      #     STDERR.puts path
      #   end
      def reflect(example, source_locations: false)
        return short_description_for(example) unless source_locations

        each_ancestor_group_for(example)
          .reverse_each
          .reduce([]) do |lines, group|
            lines << format_full_description(group)
          end
          .join("\n")
      end

      private

      def constant_or_method?(description)
        description.start_with?('::') ||
          description.start_with?('#') ||
          description.start_with?('.')
      end

      def deferred_group?(example_group)
        return false unless example_group.is_a?(Module)
        return false if example_group.is_a?(Class)

        example_group < RSpec::SleepingKingStudios::Deferred::Consumer
      end

      def each_ancestor_group_for(example, &) # rubocop:disable Metrics/MethodLength
        return enum_for(:each_ancestor_group_for, example) unless block_given?

        each_parent_group_for(example.metadata[:deferred_example_group], &)

        example
          .example_group
          .ancestors
          .select do |ancestor|
            ancestor.is_a?(Class) && ancestor < RSpec::Core::ExampleGroup
          end # rubocop:disable Style/MultilineBlockChain
          .each do |ancestor|
            yield ancestor

            each_parent_group_for(ancestor.metadata[:deferred_example_group], &)
          end
      end

      def each_parent_group_for(maybe_deferred, &)
        unless block_given?
          return enum_for(:each_parent_group_for, maybe_deferred)
        end

        loop do
          break unless deferred_group?(maybe_deferred)

          yield maybe_deferred

          maybe_deferred = maybe_deferred.parent_group
        end
      end

      def format_description(group)
        return group.description unless deferred_group?(group)

        "(#{group.description})"
      end

      def format_full_description(group)
        "#{format_description(group)} at #{format_source_location(group)}"
      end

      def format_source_location(group)
        source_location =
          if group < RSpec::Core::ExampleGroup
            group.metadata[:block].source_location
          else
            group.source_location
          end

        source_location.join(':')
      end

      def short_description_for(example)
        each_ancestor_group_for(example)
          .reverse_each
          .reduce('') do |description, group|
            description += ' ' unless constant_or_method?(group.description)

            description + format_description(group)
          end
          .strip
      end
    end
  end
end
