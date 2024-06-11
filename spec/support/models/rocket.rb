# frozen_string_literal: true

module Spec
  module Models
    class Vehicle
      def initialize(name, type)
        @name = name
        @type = type
      end

      attr_reader \
        :name,
        :type
    end

    class Rocket < Vehicle
      def initialize(name)
        super(name, :rocket)

        @crew        = []
        @launched    = false
        @launch_site = nil
        @orbit       = nil
        @payload     = {}
      end

      attr_reader \
        :crew,
        :launch_site,
        :orbit,
        :payload

      def launch(launch_site:, crew: [], orbit: nil, payload: {})
        @launched    = true
        @crew        = crew
        @launch_site = launch_site
        @orbit       = orbit
        @payload     = payload
      end

      def launched?
        @launched
      end

      def ordinal
        return @ordinal if @ordinal

        @program, @ordinal = name.split(' ')

        @ordinal
      end

      def program
        return @program if @program

        @program, @ordinal = name.split(' ')

        @program
      end
    end
  end
end
