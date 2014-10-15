# lib/rspec/sleeping_king_studios/examples/shared_example_group.rb

require 'rspec/sleeping_king_studios/examples'

module RSpec::SleepingKingStudios::Examples
  module SharedExampleGroup
    def included other
      merge_shared_example_groups other
    end # method included

    # @api private
    def alias_shared_examples new_name, old_name
      proc = shared_example_groups[self][old_name]

      self.shared_examples new_name, &proc
    end # method alias_shared_examples

    # @api private
    def apply base, proc, *args, &block
      method_name = :__temporary_method_for_applying_proc__
      metaclass   = class << base; self; end
      metaclass.send :define_method, method_name, &proc

      value = base.send method_name, *args, &block

      metaclass.send :remove_method, method_name

      value
    end # method apply

    # @api private
    def shared_examples name, *metadata_args, &block
      RSpec.world.shared_example_group_registry.add(self, name, *metadata_args, &block)
    end # method shared_examples

    private

    # @api private
    def merge_shared_example_groups other
      shared_example_groups[self].each do |name, proc|
        RSpec.world.shared_example_group_registry.add(other, name, &proc)
      end # each
    end # method merge_shared_example_groups

    # @api private
    def shared_example_groups
      RSpec.world.shared_example_group_registry.send :shared_example_groups
    end # method shared_example_groups
  end # module
end # module
