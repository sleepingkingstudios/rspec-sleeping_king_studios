# lib/rspec/sleeping_king_studios/version.rb

require 'sleeping_king_studios/tools/semantic_version'

module RSpec
  module SleepingKingStudios
    module Version
      extend ::SleepingKingStudios::Tools::SemanticVersion

      MAJOR = 2
      MINOR = 0
      PATCH = 0
      PRERELEASE = 'beta'
      BUILD = 0
    end # module

    VERSION = Version.to_gem_version
  end # module
end # module
