# frozen_string_literal: true

require 'rspec/sleeping_king_studios'

module RSpec::SleepingKingStudios
  # Namespace for deferred example functionality.
  module Deferred
    autoload :Call,
      'rspec/sleeping_king_studios/deferred/call'
    autoload :Calls,
      'rspec/sleeping_king_studios/deferred/calls'
    autoload :Definitions,
      'rspec/sleeping_king_studios/deferred/definitions'
    autoload :Examples,
      'rspec/sleeping_king_studios/deferred/examples'
  end
end
