# lib/rspec/sleeping_king_studios/mocks/custom_double.rb

module RSpec
  module Mocks
    module ExampleMethods
      def custom_double(*args, &block)
        args << {} unless Hash === args.last
        args.last[:__declared_as] = "Custom Double"
        Class.new(&block).new.tap { |obj| RSpec::Mocks::TestDouble.extend_onto obj, *args }
      end # method
    end # module
  end # module
end # module
