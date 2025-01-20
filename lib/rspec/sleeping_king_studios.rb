# frozen_string_literal: true

require 'rspec/core'

module RSpec
  # Hic Iacet Arthurus, Rex Quondam, Rexque Futurus.
  module SleepingKingStudios
    autoload :Concerns, 'rspec/sleeping_king_studios/concerns'
    autoload :Deferred, 'rspec/sleeping_king_studios/deferred'
    autoload :Sandbox,  'rspec/sleeping_king_studios/sandbox'

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

    def self.reflect_on(example)
      descriptions  = [example.description]
      example_group = example.example_group

      while example_group
        if example_group.metadata.key?(:deferred_example_group)
          deferred_group = example_group.metadata[:deferred_example_group]

          while deferred_group
            descriptions << "(deferred: #{deferred_group.description})"

            deferred_group = deferred_group.parent_group
          end
        end

        descriptions << example_group.description

        example_group = example_group.parent_groups[1]
      end

      puts descriptions.reverse.join(' ')
    end
  end
end

require 'rspec/sleeping_king_studios/configuration'
require 'rspec/sleeping_king_studios/version'
