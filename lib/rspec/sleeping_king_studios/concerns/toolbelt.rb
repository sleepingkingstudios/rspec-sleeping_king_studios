# frozen_string_literal: true

require 'sleeping_king_studios/tools/toolbox/mixin'

require 'rspec/sleeping_king_studios/concerns'

module RSpec::SleepingKingStudios::Concerns
  # Defines ::tools and #tools methods for example groups and examples.
  module Toolbelt
    extend SleepingKingStudios::Tools::Toolbox::Mixin

    # Class methods to define when including
    # RSpec::SleepingKingStudios::Concerns::Toolbelt in a class.
    module ClassMethods
      # @return [SleepingKingStudios::Tools::Toolbelt] the shared toolbelt
      #   instance.
      def tools
        @tools ||= SleepingKingStudios::Tools::Toolbelt.instance
      end
    end

    # @return [SleepingKingStudios::Tools::Toolbelt] the shared toolbelt
    #   instance.
    def tools
      @tools ||= SleepingKingStudios::Tools::Toolbelt.instance
    end
  end
end
