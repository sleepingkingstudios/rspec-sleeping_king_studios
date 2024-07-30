# frozen_string_literal: true

require 'rspec/sleeping_king_studios/sandbox'

RSpec.describe RSpec::SleepingKingStudios::Sandbox do
  describe '.run' do
    shared_examples 'should return a result' do
      it { expect(result).to be_a described_class::Result }

      it { expect(result.output.strip).to start_with(expected_output) }

      it { expect(result.errors).to be == expected_errors }

      it { expect(result.status).to be == expected_status }

      it { expect(result.summary).to be == expected_summary }

      it { expect(result.example_descriptions).to be == expected_examples }
    end

    let(:expected_output)   { '' }
    let(:expected_summary)  { '' }
    let(:expected_errors)   { '' }
    let(:expected_examples) { [] }
    let(:expected_status)   { 0 }
    let(:files)             { [] }
    let(:result)            { described_class.run(*files) }

    it 'should define the class method' do
      expect(described_class)
        .to respond_to(:run)
        .with_unlimited_arguments
    end

    describe 'with an empty Array' do
      let(:error_message) do
        'must specify at least one file or pattern'
      end

      it 'should raise an exception' do
        expect { described_class.run }
          .to raise_error ArgumentError, error_message
      end
    end

    describe 'with a pattern that does not match any files' do
      let(:files)            { ['tmp/invalid_spec.xyz'] }
      let(:expected_output)  { 'No examples found.' }
      let(:expected_summary) { '0 examples, 0 failures' }

      include_examples 'should return a result'
    end

    describe 'with a pattern that matches a file with erroring examples' do
      let(:files) do
        # rubocop:disable Layout/LineLength
        [
          'spec/rspec/sleeping_king_studios/sandbox/erroring_examples_spec.fixture.rb'
        ]
        # rubocop:enable Layout/LineLength
      end
      let(:expected_output) { 'An error occurred while loading' }
      let(:expected_summary) do
        '0 examples, 0 failures, 1 error occurred outside of examples'
      end
      let(:expected_status) { 1 }

      include_examples 'should return a result'
    end

    describe 'with a pattern that matches a file with failing examples' do
      let(:files) do
        # rubocop:disable Layout/LineLength
        [
          'spec/rspec/sleeping_king_studios/sandbox/failing_examples_spec.fixture.rb'
        ]
        # rubocop:enable Layout/LineLength
      end
      let(:expected_output) do
        <<~OUTPUT
          TrueClass
            is expected to equal nil (FAILED - 1)
            is expected to equal false (FAILED - 2)
            is expected to equal true
        OUTPUT
      end
      let(:expected_examples) do
        [
          'TrueClass is expected to equal nil',
          'TrueClass is expected to equal false',
          'TrueClass is expected to equal true'
        ]
      end
      let(:expected_summary) do
        '3 examples, 2 failures'
      end
      let(:expected_status) { 1 }

      include_examples 'should return a result'
    end

    describe 'with a pattern that matches a file with passing examples' do
      let(:files) do
        # rubocop:disable Layout/LineLength
        [
          'spec/rspec/sleeping_king_studios/sandbox/passing_examples_spec.fixture.rb'
        ]
        # rubocop:enable Layout/LineLength
      end
      let(:expected_output) do
        <<~OUTPUT
          Array
            #count
              is expected to equal 3
            #empty?
              is expected to equal false
        OUTPUT
      end
      let(:expected_examples) do
        [
          'Array#count is expected to equal 3',
          'Array#empty? is expected to equal false'
        ]
      end
      let(:expected_summary) do
        '2 examples, 0 failures'
      end

      include_examples 'should return a result'
    end

    describe 'with a pattern that matches multiple files' do
      let(:files) do
        # rubocop:disable Layout/LineLength
        [
          'spec/rspec/sleeping_king_studios/sandbox/*passing_examples_spec.fixture.rb'
        ]
        # rubocop:enable Layout/LineLength
      end
      let(:expected_output) do
        <<~OUTPUT
          Hash
            #keys
              is expected to contain exactly :ok

          Array
            #count
              is expected to equal 3
            #empty?
              is expected to equal false
        OUTPUT
      end
      let(:expected_examples) do
        [
          'Hash#keys is expected to contain exactly :ok',
          'Array#count is expected to equal 3',
          'Array#empty? is expected to equal false'
        ]
      end
      let(:expected_summary) do
        '3 examples, 0 failures'
      end

      include_examples 'should return a result'
    end

    describe 'with multiple file patterns' do
      let(:files) do
        # rubocop:disable Layout/LineLength
        [
          'spec/rspec/sleeping_king_studios/sandbox/more_passing_examples_spec.fixture.rb',
          'spec/rspec/sleeping_king_studios/sandbox/passing_examples_spec.fixture.rb'
        ]
        # rubocop:enable Layout/LineLength
      end
      let(:expected_output) do
        <<~OUTPUT
          Hash
            #keys
              is expected to contain exactly :ok

          Array
            #count
              is expected to equal 3
            #empty?
              is expected to equal false
        OUTPUT
      end
      let(:expected_examples) do
        [
          'Hash#keys is expected to contain exactly :ok',
          'Array#count is expected to equal 3',
          'Array#empty? is expected to equal false'
        ]
      end
      let(:expected_summary) do
        '3 examples, 0 failures'
      end

      include_examples 'should return a result'
    end
  end
end
