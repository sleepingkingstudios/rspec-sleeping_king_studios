# frozen_string_literal: true

require 'rspec/sleeping_king_studios/deferred'

module RSpec::SleepingKingStudios::Deferred
  # Domain-specific language for defining deferred examples.
  module Dsl; end
end

require 'rspec/sleeping_king_studios/deferred/dsl/examples'
require 'rspec/sleeping_king_studios/deferred/dsl/example_groups'
