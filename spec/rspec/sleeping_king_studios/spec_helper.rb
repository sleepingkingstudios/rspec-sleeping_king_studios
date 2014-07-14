# spec/rspec/sleeping_king_studios/spec_helper.rb

require 'rspec'
require 'factory_girl'
require 'pry'

# Require meta-matchers
require "rspec/sleeping_king_studios/matchers/meta/fail_with_actual.rb"
require "rspec/sleeping_king_studios/matchers/meta/pass_with_actual.rb"

#=# Require Factories, Custom Matchers, &c #=#
Dir[File.dirname(__FILE__) + "/support/**/*.rb"].each { |f| require f }

RSpec.configure do |config|
  config.raise_errors_for_deprecations!
end # config
