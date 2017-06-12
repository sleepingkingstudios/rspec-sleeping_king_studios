# spec/support/mock_example_group.rb

module Spec
  module Support
    class MockExampleGroup
      def self.around(_scope, &block)
        hooks << ->(example) {
          example.instance_exec(example, &block)
        } # end hook
      end # class method around

      def self.before(scope, &block)
        around(scope) do |example|
          example.instance_exec(example, &block)

          example.call
        end # around
      end # class method before

      def self.example
        @example ||= new
      end # class method example

      def self.hooks
        @hooks ||= []
      end # class method hooks

      def self.run_example
        wrapped =
          hooks.reverse.reduce(example) do |wrapped_example, hook|
            ->() { hook.call(wrapped_example) }
          end # hook

        wrapped.call
      end # class method run_example

      def call; end

      def example
        self
      end # method example
    end # class
  end # module
end # module
