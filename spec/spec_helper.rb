# spec/spec_helper.rb

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

    def <=>(version)
      version = GemVersion.new(version) if version.is_a?(String)

      segments
        .zip(version.segments)
        .map { |u, v| u <=> v }
        .find(&:nonzero?) || 0
    end

    protected

    attr_reader :segments
  end

  RSPEC_VERSION = Spec::GemVersion.new(RSpec::Version::STRING)
end

#=# Require Factories, Custom Matchers, &c #=#
Dir[File.dirname(__FILE__) + "/support/**/*.rb"].each { |f| require f }

RSpec.configure do |config|
  config.disable_monkey_patching!

  # Limit a spec run to individual examples or groups you care about by tagging
  # them with `:focus` metadata.
  config.filter_run :focus
  config.run_all_when_everything_filtered = true

  # Allow more verbose output when running an individual spec file.
  config.default_formatter = 'doc' if config.files_to_run.one?

  # Run specs in random order to surface order dependencies.
  config.order = :random
  Kernel.srand config.seed

  # rspec-expectations config goes here.
  config.expect_with :rspec do |expectations|
    # Enable only the newer, non-monkey-patching expect syntax.
    expectations.syntax = :expect
  end # expect_with

  # rspec-mocks config goes here.
  config.mock_with :rspec do |mocks|
    # Enable only the newer, non-monkey-patching expect syntax.
    mocks.syntax = :expect

    # Prevents you from mocking or stubbing a method that does not exist on
    # a real object. This is generally recommended.
    mocks.verify_partial_doubles = true
  end # mock_with

  config.sleeping_king_studios do |config|
    config.examples do |config|
      config.handle_missing_failure_message_with = :exception

      config.match_string_failure_message_as = :exact
    end # config
  end # config
end # config
