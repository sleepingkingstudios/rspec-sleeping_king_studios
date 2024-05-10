# frozen_string_literal: true

require 'rspec/sleeping_king_studios'

module RSpec::SleepingKingStudios
  # Namespace for deferred example functionality.
  module Deferred
    autoload :Call,
      'rspec/sleeping_king_studios/deferred/call'
    autoload :Example,
      'rspec/sleeping_king_studios/deferred/example'
    autoload :Examples,
      'rspec/sleeping_king_studios/deferred/examples'
    autoload :ExampleGroup,
      'rspec/sleeping_king_studios/deferred/example_group'
    autoload :Hook,
      'rspec/sleeping_king_studios/deferred/hook'
  end
end
