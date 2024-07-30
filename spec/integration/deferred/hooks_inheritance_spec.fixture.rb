# frozen_string_literal: true

require 'support/integration/deferred/hooks_inheritance_examples'

RSpec.describe Spec::Models::Rocket do # rubocop:disable RSpec/EmptyExampleGroup
  include Spec::Integration::Deferred::HooksInheritanceExamples
end
