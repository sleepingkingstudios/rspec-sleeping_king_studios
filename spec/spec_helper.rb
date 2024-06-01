# frozen_string_literal: true

require 'rspec'
require 'byebug'

require 'rspec/sleeping_king_studios'

module Spec
  class GemVersion
    include Comparable

    def initialize(version)
      @segments = version.split('.').map do |str|
        str.to_i.to_s == str ? str.to_i : str
      end
    end

    def <=>(other)
      other = GemVersion.new(other) if other.is_a?(String)

      segments
        .zip(other.segments)
        .map { |u, v| u <=> v }
        .find(&:nonzero?) || 0
    end

    protected

    attr_reader :segments
  end

  RSPEC_VERSION = Spec::GemVersion.new(RSpec::Version::STRING)
end

# Require Factories, Custom Matchers, &c
support_path = File.join(__dir__, '/support/**/*.rb')
Dir[support_path].each { |f| require f }

RSpec.configure do |config|
  config.disable_monkey_patching!

  # Limit a spec run to individual examples or groups you care about by tagging
  # them with `:focus` metadata.
  config.filter_run_when_matching :focus

  # Allows RSpec to persist some state between runs.
  config.example_status_persistence_file_path = 'spec/examples.txt'

  # Print the 10 slowest examples and example groups.
  config.profile_examples = 10 if ENV['CI']

  # Allow more verbose output when running an individual spec file.
  config.default_formatter = 'doc' if config.files_to_run.one?

  # Run specs in random order to surface order dependencies.
  config.order = :random
  Kernel.srand config.seed

  # rspec-expectations config goes here.
  config.expect_with :rspec do |expectations|
    # Enable only the newer, non-monkey-patching expect syntax.
    expectations.syntax = :expect

    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  # rspec-mocks config goes here.
  config.mock_with :rspec do |mocks|
    # Enable only the newer, non-monkey-patching expect syntax.
    mocks.syntax = :expect

    # Prevents you from mocking or stubbing a method that does not exist on
    # a real object. This is generally recommended.
    mocks.verify_partial_doubles = true
  end

  # This option will default to `:apply_to_host_groups` in RSpec 4 (and will
  # have no way to turn it off -- the option exists only for backwards
  # compatibility in RSpec 3). It causes shared context metadata to be
  # inherited by the metadata hash of host groups and examples, rather than
  # triggering implicit auto-inclusion in groups with matching metadata.
  config.shared_context_metadata_behavior = :apply_to_host_groups

  config.sleeping_king_studios do |sks|
    sks.examples do |examples|
      examples.handle_missing_failure_message_with = :exception

      examples.match_string_failure_message_as = :exact
    end
  end
end
