# spec/rspec/sleeping_king_studios/support/mock_example_group.rb

module Spec
  module Support
    module MockExampleGroup
      attr_accessor :examples_included, :is_describe_block, :is_focus, :is_skipped

      def describe name, &block
        self.is_describe_block = true
        self.is_focus          = false
        self.is_skipped        = false

        instance_eval(&block)

        self.is_describe_block = false
      end # method describe

      def fdescribe name, &block
        self.is_describe_block = true
        self.is_focus          = true
        self.is_skipped        = false

        instance_eval(&block)

        self.is_describe_block = false
        self.is_focus          = false
      end # method fdescribe

      def xdescribe name, &block
        self.is_describe_block = true
        self.is_focus          = false
        self.is_skipped        = true

        instance_eval(&block)

        self.is_describe_block = false
        self.is_skipped        = false
      end # method fdescribe

      def include_examples name, *args, **kwargs, &block
        instance_eval(&block)
      end # method include_examples
    end # module
  end # module
end # module
