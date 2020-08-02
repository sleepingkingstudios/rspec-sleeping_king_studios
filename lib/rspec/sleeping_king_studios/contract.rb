# frozen_string_literal: true

require 'rspec/sleeping_king_studios'

module RSpec::SleepingKingStudios
  # Defines a set of expectations that can be used in an RSpec example group.
  #
  # @example Defining a Contract.
  #   module GreetsContract
  #     extend RSpec::SleepingKingStudios::Contract
  #
  #     describe '#greets' do
  #       it { expect(subject).to respond_to(:greet).with(1).argument }
  #
  #       it { expect(subject.greet 'programs').to be == 'Greetings, programs!' }
  #     end
  #
  # @example Using a Defined Contract
  #   class Greeter
  #     def greet(person)
  #       "Greetings, #{person}!"
  #     end
  #   end
  #
  #   RSpec.describe Greeter do
  #     include GreetsContract
  #   end
  #
  # @example Composing Contracts
  #   module QuacksContract
  #     extend RSpec::SleepingKingStudios::Contract
  #   end
  #
  #   module SwimsContract
  #     extend RSpec::SleepingKingStudios::Contract
  #   end
  #
  #   module WaddlesContract
  #     extend RSpec::SleepingKingStudios::Contract
  #   end
  #
  #   module DuckContract
  #     extend RSpec::SleepingKingStudios::Contract
  #
  #     include QuacksContract
  #     include SwimsContract
  #     include WaddlesContract
  #   end
  module Contract
    # Defines an example group.
    #
    # @param description [String] The description for the example group.
    #
    # @yield The block is used to define the example group.
    #
    # @see RSpec::Core::ExampleGroup.context
    def context(description, &block)
      add_example :context, description, &block
    end

    # Defines an example group.
    #
    # @param description [String] The description for the example group.
    #
    # @yield The block is used to define the example group.
    #
    # @see RSpec::Core::ExampleGroup.describe
    def describe(description, &block)
      add_example :describe, description, &block
    end

    # Reflects on the examples defined for the contract.
    #
    # This includes examples defined by another contract that is itself included
    # in the current contract.
    #
    # @return [Array<Hash>] The examples defined for the contract.
    def examples
      each_example.to_a.tap(&:freeze)
    end

    # Defines an example.
    #
    # @param description [String] The description for the example.
    #
    # @yield The block is used to define the example.
    #
    # @see RSpec::Core::ExampleGroup.it
    def it(description, &block)
      add_example :it, description, &block
    end

    protected

    def own_examples
      return enum_for :own_examples unless block_given?

      (@examples ||= []).each { |example| yield example }
    end

    private

    def add_example(method_name, description, &block)
      validate_description(description)

      unless block_given?
        raise ArgumentError, 'called without a block', caller(1..-1)
      end

      (@examples ||= []) << {
        block:       block,
        description: description,
        method_name: method_name
      }
    end

    def define_example(context, block:, description:, method_name:)
      context.send(method_name, description, &block)
    end

    def each_example
      return enum_for :each_example unless block_given?

      ancestors
        .reverse_each
        .select do |ancestor|
          ancestor.singleton_class < RSpec::SleepingKingStudios::Contract
        end
        .each do |ancestor|
          ancestor.own_examples.each { |example| yield example }
        end
    end

    def included(other)
      super

      return unless other < RSpec::Core::ExampleGroup

      examples.each do |definition|
        define_example(other, **definition)
      end
    end

    def validate_description(description)
      if description.nil?
        raise ArgumentError, "description can't be blank", caller(2..-1)
      end

      unless description.is_a?(String) || description.is_a?(Symbol)
        raise ArgumentError,
          'description must be a String or a Symbol',
          caller(1..-1)
      end

      return unless description.to_s.empty?

      raise ArgumentError, "description can't be blank", caller(2..-1)
    end
  end
end
