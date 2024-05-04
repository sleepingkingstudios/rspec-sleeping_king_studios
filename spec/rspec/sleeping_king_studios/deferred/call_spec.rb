# frozen_string_literal: true

require 'rspec/sleeping_king_studios/deferred/call'

require 'support/shared_examples/deferred_call_examples'

RSpec.describe RSpec::SleepingKingStudios::Deferred::Call do
  include Spec::Support::SharedExamples::DeferredCallExamples

  subject(:deferred) do
    described_class.new(method_name, *arguments, **keywords, &block)
  end

  let(:method_name) { :launch }
  let(:arguments)   { [] }
  let(:keywords)    { {} }
  let(:block)       { nil }

  include_examples 'should be a deferred call'
end
