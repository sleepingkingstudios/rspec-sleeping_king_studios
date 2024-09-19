# frozen_string_literal: true

module Spec
  module Support
    class MockExampleGroup
      def self.around(_scope, &block)
        hooks << lambda { |example|
          example.instance_exec(example, &block)
        }
      end

      def self.before(scope, &block)
        around(scope) do |example|
          example.instance_exec(example, &block)

          example.call
        end
      end

      def self.example
        @example ||= new
      end

      def self.hooks
        @hooks ||= []
      end

      def self.run_example
        wrapped =
          hooks.reverse.reduce(example) do |wrapped_example, hook|
            -> { hook.call(wrapped_example) }
          end

        wrapped.call
      end

      def call; end

      def example
        self
      end

      def inspect
        '#<MockExampleGroup>'
      end
      alias to_s inspect
    end
  end
end
