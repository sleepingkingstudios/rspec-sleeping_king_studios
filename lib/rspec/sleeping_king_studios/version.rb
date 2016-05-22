# lib/rspec/sleeping_king_studios/version.rb

require 'sleeping_king_studios/tools/semantic_version'

module RSpec
  module SleepingKingStudios
    # @api private
    #
    # The current version of the gem.
    #
    # @see http://semver.org/
    module Version
      extend ::SleepingKingStudios::Tools::SemanticVersion

      # Major version.
      MAJOR = 2
      # Minor version.
      MINOR = 2
      # Patch version.
      PATCH = 0
      # Prerelease version.
      PRERELEASE = 'rc'
      # Build metadata.
      BUILD = 0
    end # module

    VERSION = Version.to_gem_version
  end # module
end # module
