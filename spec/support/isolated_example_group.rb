# frozen_string_literal: true

module Spec
  module Support
    def self.isolated_example_group(
      parent_class = RSpec::Core::ExampleGroup,
      &block
    )
      subclass = Class.new(parent_class)

      subclass.module_exec(&block) if block

      RSpec::Core::MemoizedHelpers.define_helpers_on(subclass)

      subclass
    end
  end
end
