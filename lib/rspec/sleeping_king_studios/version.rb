# lib/rspec/sleeping_king_studios/version.rb

module RSpec
  module SleepingKingStudios
    # @api private
    module Version
      MAJOR = 2
      MINOR = 0
      PATCH = 0
      PRERELEASE = 'beta'
      BUILD = 2

      def self.to_gem_version
        str = "#{MAJOR}.#{MINOR}.#{PATCH}"

        prerelease = self.const_defined?(:PRERELEASE) ? PRERELEASE : nil
        str << ".#{prerelease}" unless prerelease.nil? || (prerelease.respond_to?(:empty?) && prerelease.empty?)

        build = self.const_defined?(:BUILD) ? BUILD : nil
        str << ".#{build}" unless build.nil? || (build.respond_to?(:empty?) && build.empty?)

        str
      end # class method to_version
    end # module

    VERSION = Version.to_gem_version
  end # module
end # module
