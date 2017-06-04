# lib/rspec/sleeping_king_studios/concerns/toolbelt.rb

require 'sleeping_king_studios/tools/toolbox/mixin'

require 'rspec/sleeping_king_studios/concerns'

module RSpec::SleepingKingStudios::Concerns
  # Defines ::tools and #tools methods for example groups and examples, exposing
  # an instance of SleepingKingStudios::Tools::Toolbelt.
  module Toolbelt
    extend SleepingKingStudios::Tools::Toolbox::Mixin

    # Class methods to define when including
    # RSpec::SleepingKingStudios::Concerns::Toolbelt in a class.
    module ClassMethods
      def tools
        @tools ||= SleepingKingStudios::Tools::Toolbelt.instance
      end # class method tools
    end # module

    def tools
      @tools ||= self.class.tools
    end # method tools
  end # module
end # module
