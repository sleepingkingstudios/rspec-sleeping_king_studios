# lib/rspec/sleeping_king_studios/concerns/wrap_env.rb

require 'sleeping_king_studios/tools/toolbox/mixin'

require 'rspec/sleeping_king_studios/concerns'

module RSpec::SleepingKingStudios::Concerns
  # Methods for temporarily overwriting values in the environment, which are
  # safely and automatically reset after the block or example.
  module WrapEnv
    extend SleepingKingStudios::Tools::Toolbox::Mixin

    # Class methods to define when including
    # RSpec::SleepingKingStudios::Concerns::WrapEnv in a class.
    module ClassMethods
      def wrap_env key, value = nil, &block
        around(:example) do |wrapped_example|
          begin
            if block_given?
              example = wrapped_example.example
              value   = example.instance_exec(&block)
            end # if

            prior_value = ENV[key]
            ENV[key]    = value

            wrapped_example.call
          ensure
            ENV[key]    = prior_value
          end # begin-ensure
        end # around example
      end # class method wrap_env
      alias_method :stub_env, :wrap_env
    end # module

    def wrap_env key, value
      prior_value = ENV[key]
      ENV[key]    = value

      yield
    ensure
      ENV[key]    = prior_value
    end # method wrap_env
    alias_method :stub_env, :wrap_env
  end # module
end # module
