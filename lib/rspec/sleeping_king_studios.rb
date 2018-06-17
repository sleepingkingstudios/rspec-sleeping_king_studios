# lib/rspec/sleeping_king_studios.rb

require 'rspec/core'

module RSpec
  # Hic Iacet Arthurus, Rex Quondam, Rexque Futurus.
  module SleepingKingStudios
    def self.gem_path
      pattern =
        /#{File::SEPARATOR}lib#{File::SEPARATOR}rspec#{File::SEPARATOR}?\z/

      __dir__.sub(pattern, '')
    end

    def self.version
      @version ||= RSpec::SleepingKingStudios::Version.to_gem_version
    end # class method version
  end # end module
end # module

require 'rspec/sleeping_king_studios/configuration'
require 'rspec/sleeping_king_studios/version'
