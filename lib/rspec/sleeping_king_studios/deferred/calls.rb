# frozen_string_literal: true

require 'rspec/sleeping_king_studios/deferred'

module RSpec::SleepingKingStudios::Deferred
  # Namespace for deferred call implementations.
  module Calls
    autoload :Example,
      'rspec/sleeping_king_studios/deferred/calls/example'
    autoload :ExampleGroup,
      'rspec/sleeping_king_studios/deferred/calls/example_group'
    autoload :Hook,
      'rspec/sleeping_king_studios/deferred/calls/hook'
    autoload :IncludedExamples,
      'rspec/sleeping_king_studios/deferred/calls/included_examples'
    autoload :SharedExamples,
      'rspec/sleeping_king_studios/deferred/calls/shared_examples'
  end
end
