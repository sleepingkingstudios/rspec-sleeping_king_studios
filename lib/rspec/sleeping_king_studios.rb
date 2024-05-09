# frozen_string_literal: true

require 'rspec/core'

module RSpec
  # Hic Iacet Arthurus, Rex Quondam, Rexque Futurus.
  module SleepingKingStudios
    autoload :Concerns, 'rspec/sleeping_king_studios/concerns'
    autoload :Deferred, 'rspec/sleeping_king_studios/deferred'

    # @return [String] the path to the installed gem.
    def self.gem_path
      pattern =
        /#{File::SEPARATOR}lib#{File::SEPARATOR}rspec#{File::SEPARATOR}?\z/

      __dir__.sub(pattern, '')
    end

    # @return [String] the gem version.
    def self.version
      @version ||= RSpec::SleepingKingStudios::Version.to_gem_version
    end
  end
end

require 'rspec/sleeping_king_studios/configuration'
require 'rspec/sleeping_king_studios/version'
