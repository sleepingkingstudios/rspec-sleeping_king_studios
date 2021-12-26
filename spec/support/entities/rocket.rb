# frozen_string_literal: true

require 'support/entities'

module Spec::Support::Entities
  class Rocket < Struct.new(:engine)
    def launch
      engine&.activate
    end
  end
end
