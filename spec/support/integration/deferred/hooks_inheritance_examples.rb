# frozen_string_literal: true

require 'rspec/sleeping_king_studios'

require 'support/integration/deferred'

module Spec::Integration::Deferred
  module HooksInheritanceExamples
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

    module EarlyHooksExamples
      include RSpec::SleepingKingStudios::Deferred::Examples

      before(:example) { record 'early', 'before' }

      prepend_before(:example) { record 'early', 'before.prepend' }

      after(:example) { record 'early', 'after' }

      append_after(:example) { record 'early', 'after.append' }

      around(:example) do |example|
        record 'early', 'around.before'

        example.call

        record 'early', 'around.after'
      end
    end

    module InnerHooksExamples
      include RSpec::SleepingKingStudios::Deferred::Examples

      before(:example) { record 'inner', 'before' }

      prepend_before(:example) { record 'inner', 'before.prepend' }

      after(:example) { record 'inner', 'after' }

      append_after(:example) { record 'inner', 'after.append' }

      around(:example) do |example|
        record 'inner', 'around.before'

        example.call

        record 'inner', 'around.after'
      end
    end

    module InheritedHooksExamples
      include RSpec::SleepingKingStudios::Deferred::Examples
      include InnerHooksExamples

      before(:example) { record 'inherited', 'before', 1 }

      before(:example) { record 'inherited', 'before', 2 }

      prepend_before(:example) { record 'inherited', 'before.prepend', 1 }

      prepend_before(:example) { record 'inherited', 'before.prepend', 2 }

      after(:example) { record 'inherited', 'after', 1 }

      after(:example) { record 'inherited', 'after', 2 }

      append_after(:example) { record 'inherited', 'after.append', 1 }

      append_after(:example) { record 'inherited', 'after.append', 2 }

      around(:example) do |example|
        record 'inherited', 'around.before', 1

        example.call

        record 'inherited', 'around.after', 1
      end

      around(:example) do |example|
        record 'inherited', 'around.before', 2

        example.call

        record 'inherited', 'around.after', 2
      end
    end

    module OtherHooksExamples
      include RSpec::SleepingKingStudios::Deferred::Examples

      before(:example) { record 'other', 'before' }

      prepend_before(:example) { record 'other', 'before.prepend' }

      after(:example) { record 'other', 'after' }

      append_after(:example) { record 'other', 'after.append' }

      around(:example) do |example|
        record 'other', 'around.before'

        example.call

        record 'other', 'around.after'
      end
    end

    include EarlyHooksExamples
    include InheritedHooksExamples
    include OtherHooksExamples

    def record(scope, entry, *rest)
      Recorder.instance.records <<
        "#{entry}.#{scope}#{rest.map { |obj| ".#{obj}" }.join}"
    end

    before(:example) { record 'example', 'before' }

    prepend_before(:example) { record 'example', 'before.prepend' }

    after(:example) { record 'example', 'after' }

    append_after(:example) { record 'example', 'after.append' }

    around(:example) do |example|
      record 'example', 'around.before'

      example.call

      record 'example', 'around.after'
    end

    it { record 'example', 'example' } # rubocop:disable RSpec/NoExpectationExample
  end
end
