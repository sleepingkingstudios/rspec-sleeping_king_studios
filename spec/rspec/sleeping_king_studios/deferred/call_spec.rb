# frozen_string_literal: true

require 'rspec/sleeping_king_studios/concerns/example_constants'
require 'rspec/sleeping_king_studios/deferred/call'

require 'support/shared_examples/deferred_call_examples'

RSpec.describe RSpec::SleepingKingStudios::Deferred::Call do
  extend  RSpec::SleepingKingStudios::Concerns::ExampleConstants
  include Spec::Support::SharedExamples::DeferredCallExamples

  subject(:deferred) do
    described_class.new(method_name, *arguments, **keywords, &block)
  end

  let(:method_name) { :launch }
  let(:arguments)   { [] }
  let(:keywords)    { {} }
  let(:block)       { nil }
  let(:receiver)    { instance_double(Spec::Rocket, launch: nil) }

  example_class 'Spec::Rocket' do |klass|
    klass.define_method(:launch) { |*, **| nil }
  end

  include_examples 'should be a deferred call'
end
