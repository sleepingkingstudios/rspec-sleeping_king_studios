# frozen_string_literal: true

require 'rspec/sleeping_king_studios/concerns/example_constants'
require 'rspec/sleeping_king_studios/deferred/calls/example'

require 'support/shared_examples/deferred_call_examples'

RSpec.describe RSpec::SleepingKingStudios::Deferred::Calls::Example do
  extend  RSpec::SleepingKingStudios::Concerns::ExampleConstants
  include Spec::Support::SharedExamples::DeferredCallExamples

  subject(:deferred) do
    described_class.new(method_name, *arguments, **keywords, &block)
  end

  let(:method_name) { :specify }
  let(:arguments)   { [] }
  let(:keywords)    { {} }
  let(:block)       { nil }
  let(:receiver)    { instance_double(Spec::ExampleGroup, specify: nil) }

  example_class 'Spec::ExampleGroup' do |klass|
    klass.define_method(:specify) { |*, **| nil }
  end

  include_examples 'should be a deferred call'

  describe '#type' do
    it { expect(deferred.type).to be :example }
  end
end
