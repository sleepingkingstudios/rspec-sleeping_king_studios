# frozen_string_literal: true

require 'rspec/sleeping_king_studios/deferred'

module RSpec::SleepingKingStudios::Deferred
  # Class methods for defining a registry of deferred calls.
  module Definitions
    # Invokes the deferred examples on the given example group.
    #
    # @param example_group [RSpec::Core::ExampleGroup] the example group.
    #
    # @return [void]
    def call(example_group)
      deferred_calls.each do |deferred|
        deferred.call(example_group)
      end
    end

    # @api private
    def deferred_calls
      @deferred_calls ||= []
    end

    # Callback invoked when the module is included in another module or class.
    #
    # Calls the deferred calls with the other module as the receiver if the
    # module is an RSpec::Core::ExampleGroup.
    #
    # @param other [Module] the other module or class.
    def included(other)
      super

      return unless other < RSpec::Core::ExampleGroup

      ancestors.reverse_each do |ancestor|
        next unless ancestor.singleton_class.method_defined?(:deferred_calls)

        ancestor.call(other)
      end
    end
  end
end
