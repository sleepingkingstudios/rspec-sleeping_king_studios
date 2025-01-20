# frozen_string_literal: true

require 'rspec/sleeping_king_studios/deferred/consumer'
require 'rspec/sleeping_king_studios/deferred/provider'

# @todo:
#   - Wrap included deferred example modules in an anonymous module.
#   - Store a reference to the parent included deferred examples, if any.
#   - Store a reference to the deferred examples when defining an example group
#     inside deferred examples.
#   - Define helper to report full path of example.

module Spike
  class Rocket
    def launch; end
  end

  module RocketExamples
    include RSpec::SleepingKingStudios::Deferred::Provider

    deferred_examples 'should be launchable' do
      describe '#launch' do
        it 'should be defined' do; end
      end
    end

    deferred_examples 'should be a Rocket' do
      include Spike::RocketExamples

      include_deferred 'should be launchable'
    end
  end
end

RSpec.describe Spike::Rocket do
  include RSpec::SleepingKingStudios::Deferred::Consumer
  include Spike::RocketExamples

  shared_examples 'should be launchable' do
    describe '#launch' do
      it 'should be defined' do; end
    end
  end

  after(:example) do |example|
    RSpec::SleepingKingStudios.reflect_on(example)
  end

  include_deferred 'should be a Rocket'
end
