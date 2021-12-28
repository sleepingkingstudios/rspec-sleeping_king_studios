# frozen_string_literal: true

require 'support/entities'

module Spec::Support::Entities
  class RocketEngine < Struct.new(:fuel_type)
    def initialize(fuel_type = nil)
      super

      @active = false
    end

    def activate
      @active = true
    end

    def active?
      @active
    end
  end
end
