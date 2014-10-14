# spec/rspec/sleeping_king_studios/spec_helper.rb

require 'rspec'
require 'factory_girl'
require 'pry'

require 'rspec/sleeping_king_studios'

#=# Require Factories, Custom Matchers, &c #=#
Dir[File.dirname(__FILE__) + "/support/**/*.rb"].each { |f| require f }

RSpec.configure do |config|
  # Limit a spec run to individual examples or groups you care about by tagging
  # them with `:focus` metadata.
  config.filter_run :focus
  config.run_all_when_everything_filtered = true

  # Allow more verbose output when running an individual spec file.
  config.default_formatter = 'doc' if config.files_to_run.one?

  # Run specs in random order to surface order dependencies.
  config.order = :random
  Kernel.srand config.seed

  # Alias "it should behave like" to 2.13-like syntax.
  config.alias_it_should_behave_like_to 'expect_behavior', 'has behavior'

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
      config.handle_missing_failure_message_with = :pending
    end # config
  end # config
end # config
