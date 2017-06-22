# lib/rspec/sleeping_king_studios/concerns/shared_example_group.rb

require 'rspec/sleeping_king_studios/concerns'

module RSpec::SleepingKingStudios::Concerns
  # Methods for creating reusable shared example groups and shared contexts in
  # a module that can be mixed into multiple RSpec example groups.
  #
  # @example
  #   module MySharedExamples
  #     extend RSpec::SleepingKingStudios::Concerns::SharedExampleGroup
  #
  #     shared_examples 'my examples' do
  #       # Define shared examples here.
  #     end # shared_examples
  #   end # module
  #
  #   RSpec.describe MyObject do
  #     include MySharedExamples
  #
  #     include_examples 'my examples'
  #   end # describe
  module SharedExampleGroup
    # Aliases a defined shared example group, allowing it to be accessed using
    # a new name. The example group must be defined in the current context
    # using `shared_examples`. The aliases must be defined before including the
    # module into an example group, or they will not be available in the
    # example group.
    #
    # @param [String] new_name The new name to alias the shared example group
    #   as.
    # @param [String] old_name The name under which the shared example group is
    #   currently defined.
    #
    # @raise ArgumentError If the referenced shared example group does not
    #   exist.
    def alias_shared_examples new_name, old_name
      example_group = shared_example_groups[self][old_name]
      definition    = example_group_definition(example_group)

      raise ArgumentError.new(%{Could not find shared examples "#{old_name}"}) if definition.nil?

      self.shared_examples new_name, &definition
    end # method alias_shared_examples
    alias_method :alias_shared_context, :alias_shared_examples

    # @api private
    #
    # Hook to merge defined example groups when included in another module.
    def included other
      super

      merge_shared_example_groups other
    end # method included

    # @overload shared_examples(name, &block)
    #   @param [String] name Identifer to use when looking up this shared group.
    #   @param block Used to create the shared example group definition.
    # @overload shared_examples(name, metadata, &block)
    #   @param [String] name Identifer to use when looking up this shared group.
    #   @param metadata [Array<Symbol>, Hash] Metadata to attach to this group;
    #     any example group with matching metadata will automatically include
    #     this shared example group.
    #   @param block Used to create the shared example group definition.
    #
    # Defines a shared example group within the context of the current module.
    # Unlike a top-level example group defined using RSpec#shared_examples,
    # these examples are not globally available, and must be mixed into an
    # example group by including the module. The shared examples must be
    # defined before including the module, or they will not be available in the
    # example group.
    def shared_examples name, *metadata_args, &block
      RSpec.world.shared_example_group_registry.add(self, name, *metadata_args, &block)
    end # method shared_examples
    alias_method :shared_context, :shared_examples

    private

    def example_group_definition example_group
      if example_group.is_a?(Proc)
        example_group
      elsif defined?(RSpec::Core::SharedExampleGroupModule) && example_group.is_a?(RSpec::Core::SharedExampleGroupModule)
        example_group.definition
      else
        nil
      end # if-elsif-else
    end # method example_group_definition

    # @api private
    def merge_shared_example_groups other
      shared_example_groups[self].each do |name, example_group|
        definition = example_group_definition(example_group)

        # Skip the warning if the shared example group is already defined with the
        # same definition.
        existing_group = shared_example_groups[other][name]
        next if existing_group == example_group || example_group_definition(existing_group) == definition

        RSpec.world.shared_example_group_registry.add(other, name, &definition)
      end # each
    end # method merge_shared_example_groups

    # @api private
    def shared_example_groups
      RSpec.world.shared_example_group_registry.send :shared_example_groups
    end # method shared_example_groups
  end # module
end # module
