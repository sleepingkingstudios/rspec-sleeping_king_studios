# frozen_string_literal: true

require 'rspec/sleeping_king_studios'

require 'support/integration/deferred'

module Spec::Integration::Deferred
  module HooksOrderingExamples
    include RSpec::SleepingKingStudios::Deferred::Examples

    class Recorder
      def self.instance
        @instance ||= new
      end

      def initialize
        @records = []
      end

      attr_reader :records
    end

    def record(scope, entry, *rest)
      Recorder.instance.records <<
        "#{entry}.#{scope}#{rest.map { |obj| ".#{obj}" }.join}"
    end

    before(:example) { record 'example', 'before', 1 }

    before(:example) { record 'example', 'before', 2 }

    prepend_before(:example) { record 'example', 'before.prepend', 1 }

    prepend_before(:example) { record 'example', 'before.prepend', 2 }

    after(:example) { record 'example', 'after', 1 }

    after(:example) { record 'example', 'after', 2 }

    append_after(:example) { record 'example', 'after.append', 1 }

    append_after(:example) { record 'example', 'after.append', 2 }

    around(:example) do |example|
      record 'example', 'around.before', 1

      example.call

      record 'example', 'around.after', 1
    end

    around(:example) do |example|
      record 'example', 'around.before', 2

      example.call

      record 'example', 'around.after', 2
    end

    it { record 'example', 'example' } # rubocop:disable RSpec/NoExpectationExample
  end
end
