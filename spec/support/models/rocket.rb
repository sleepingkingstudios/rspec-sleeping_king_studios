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

        @launched    = false
        @launch_site = nil
        @payload     = []
      end

      attr_reader \
        :launch_site,
        :payload

      def launch(launch_site:, payload: [])
        @launched    = true
        @launch_site = launch_site
        @payload     = payload
      end

      def launched?
        @launched
      end

      def program
        return @program if @program

        @program, @ordinal = name.split(' ')

        @program
      end
    end
  end
end
