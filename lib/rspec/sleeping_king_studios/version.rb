# frozen_string_literal: true

module RSpec
  module SleepingKingStudios
    # @api private
    #
    # The current version of the gem.
    #
    # @see http://semver.org/
    module Version
      # Major version.
      MAJOR = 2
      # Minor version.
      MINOR = 8
      # Patch version.
      PATCH = 0
      # Prerelease version.
      PRERELEASE = :alpha
      # Build metadata.
      BUILD = nil

      class << self
        # Generates the gem version string from the Version constants.
        #
        # Inlined here because dependencies may not be loaded when processing a
        # gemspec, which results in the user being unable to install the gem for
        # the first time.
        #
        # @see SleepingKingStudios::Tools::SemanticVersion#to_gem_version
        def to_gem_version
          str = "#{MAJOR}.#{MINOR}.#{PATCH}"

          prerelease = value_of(:PRERELEASE)
          str = "#{str}.#{prerelease}" if prerelease

          build = value_of(:BUILD)
          str = "#{str}.#{build}" if build

          str
        end

        private

        def value_of(constant)
          return nil unless const_defined?(constant)

          value = const_get(constant)

          return nil if value.respond_to?(:empty?) && value.empty?

          value
        end
      end
    end

    # The current version of the gem.
    VERSION = Version.to_gem_version
  end
end
