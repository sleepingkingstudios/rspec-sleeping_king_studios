# frozen_string_literal: true

require 'rspec/sleeping_king_studios'

module RSpec::SleepingKingStudios
  # Namespace for deferred example functionality.
  module Deferred
    autoload :Call,        'rspec/sleeping_king_studios/deferred/call'
    autoload :Calls,       'rspec/sleeping_king_studios/deferred/calls'
    autoload :Consumer,    'rspec/sleeping_king_studios/deferred/consumer'
    autoload :Definitions, 'rspec/sleeping_king_studios/deferred/definitions'
    autoload :Dsl,         'rspec/sleeping_king_studios/deferred/dsl'
    autoload :Examples,    'rspec/sleeping_king_studios/deferred/examples'
    autoload :Missing,     'rspec/sleeping_king_studios/deferred/missing'
    autoload :Provider,    'rspec/sleeping_king_studios/deferred/provider'
  end
end
