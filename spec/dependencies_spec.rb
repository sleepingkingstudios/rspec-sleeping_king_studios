# frozen_string_literal: true

require 'sleeping_king_studios/tools/toolbox/mixin'

require 'rspec/sleeping_king_studios/deferred'

module RSpec::SleepingKingStudios::Deferred
  module Dependencies
    extend SleepingKingStudios::Tools::Toolbox::Mixin

    class MissingDependenciesError < StandardError; end

    module ClassMethods
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
      def deferred_dependencies
        @deferred_dependencies ||= []
      end

      def depends_on(method_name, description = nil)
        deferred_dependencies << {
          deferred_group: self,
          description:,
          method_name:
        }
      end
    end

    class << self
      def check_dependencies_for(example)
        missing = missing_dependencies_for(example)

        return if missing.empty?

        messages = [before_message]

        missing
          .group_by { |item| item[:deferred_group] }
          .each do |deferred_group, dependencies|
            messages << message_for(deferred_group, dependencies)
          end

        messages << [after_message]

        raise MissingDependenciesError, messages.join("\n\n")
      end

      private

      def after_message
        'Please define the missing methods or :let helpers.'
      end

      def all_dependencies_for(example)
        example
          .class
          .ancestors
          .select { |ancestor| ancestor.respond_to?(:deferred_dependencies) }
          .flat_map(&:deferred_dependencies)
      end

      def before_message
        'Unable to run specs with deferred example groups because the ' \
          'following methods are not defined in the examples:'
      end

      def message_for(deferred_group, dependencies)
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

module Spec
  Spaceship = Struct.new(:name, :launched)

  class LaunchSpaceship
    def call(spaceship:)
      spaceship.launched = true
    end

    private

    def name(entity)
      entity.name
    end
  end

  module LaunchExamples
    include RSpec::SleepingKingStudios::Deferred::Provider

    module ShouldDefineTheMethod
      include RSpec::SleepingKingStudios::Deferred::Dependencies
      include RSpec::SleepingKingStudios::Deferred::Examples

      depends_on :command

      describe '#call' do
        it { expect(command).to respond_to(:call) }
      end
    end

    deferred_examples 'should launch the spaceship' do
      include RSpec::SleepingKingStudios::Deferred::Dependencies

      depends_on :command, 'The command to be called.'

      depends_on :spaceship, 'An instance of Spec::Spaceship.'

      describe '#call' do
        it 'should launch the spaceship' do
          expect { command.call(spaceship:) }
            .to change(spaceship, :launched)
            .to be true
        end
      end
    end
  end
end

RSpec.describe Spec::LaunchSpaceship do
  include RSpec::SleepingKingStudios::Deferred::Consumer
  include Spec::LaunchExamples

  subject(:command) { described_class.new }

  let(:spaceship) { Spec::Spaceship.new }

  include_deferred 'should define the method'

  include_deferred 'should launch the spaceship'
end
