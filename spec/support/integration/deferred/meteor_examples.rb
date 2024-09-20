# frozen_string_literal: true

require 'rspec/sleeping_king_studios'

require 'support/integration/deferred'

module Spec::Integration::Deferred
  module MeteorExamples
    include RSpec::SleepingKingStudios::Deferred::Examples

    example_class 'Meteor', Struct.new(:altitude) do |klass|
      klass.define_method(:space?) do
        altitude >= SPACE
      end
    end

    example_constant 'SPACE', 100
  end
end
