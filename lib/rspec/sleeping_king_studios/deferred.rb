# frozen_string_literal: true

require 'rspec/sleeping_king_studios'

module RSpec::SleepingKingStudios
  # Namespace for deferred example functionality.
  module Deferred
    autoload :Call,    'rspec/sleeping_king_studios/deferred/call'
    autoload :Example, 'rspec/sleeping_king_studios/deferred/example'
  end
end
