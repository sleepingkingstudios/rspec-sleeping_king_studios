# frozen_string_literal: true

require 'support/integration/deferred/ordinal_examples'
require 'support/models/rocket'

RSpec.describe Spec::Models::Rocket do # rubocop:disable RSpec/EmptyExampleGroup
  class << self
    alias_method :custom_example, :specify

    alias_method :custom_example_group, :describe
  end

  subject(:rocket) { described_class.new('Imp IV') }

  include Spec::Integration::Deferred::OrdinalExamples
end
