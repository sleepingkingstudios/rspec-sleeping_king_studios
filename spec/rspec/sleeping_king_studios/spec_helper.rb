# spec/rspec/sleeping_king_studios/spec_helper.rb

require 'rspec'

# Require meta-matchers
require "rspec/sleeping_king_studios/matchers/rspec/fail_actual.rb"
require "rspec/sleeping_king_studios/matchers/rspec/pass_actual.rb"

RSpec.configure do |config|
  config.color_enabled = true
end # config
