# frozen_string_literal: true

require 'stringio'

require 'rspec/core/sandbox'

require 'rspec/sleeping_king_studios'

module RSpec::SleepingKingStudios
  # Helper for running RSpec files in isolation.
  #
  # Sandboxed files can be used to test enhancements to RSpec itself, such as
  # custom matchers or shared or deferred example groups.
  module Sandbox
    # Value class for the result of calling a sandboxed spec file.
    Result = Struct.new(:output, :errors, :json, :status, keyword_init: true) do
      # @return [Array<String>] the full description for each run example.
      def example_descriptions
        json['examples'].map { |hsh| hsh['full_description'] }
      end

      # @return [Array<String>] the full description for each run example with
      #   status "failed".
      def failing_examples
        json['examples']
          .select { |hsh| hsh['status'] == 'failed' }
          .map { |hsh| hsh['full_description'] }
      end

      # @return [Array<String>] the full description for each run example with
      #   status "passed".
      def passing_examples
        json['examples']
          .select { |hsh| hsh['status'] == 'passed' }
          .map { |hsh| hsh['full_description'] }
      end

      # @return [Array<String>] the full description for each run example with
      #   status "pending".
      def pending_examples
        json['examples']
          .select { |hsh| hsh['status'] == 'pending' }
          .map { |hsh| hsh['full_description'] }
      end

      # @return [String] the summary of the sandboxed spec run.
      def summary
        json['summary_line']
      end
    end

    class << self
      # Runs the specified spec files in a sandbox.
      #
      # The examples and other RSpec code in the files will *not* be added to
      # the current RSpec process.
      #
      # @param files [Array<String>] the file names or patterns for the spec
      #   files to run.
      #
      # @return [RSpec::SleepingKingStudios::Result] the status and output of
      #   the spec run.
      def run(*files) # rubocop:disable Metrics/MethodLength
        if files.empty?
          raise ArgumentError, 'must specify at least one file or pattern'
        end

        err    = StringIO.new
        out    = StringIO.new
        status = nil
        args   = format_args(*files)

        RSpec::Core::Sandbox.sandboxed do |config|
          config.filter_run_when_matching :focus

          status = RSpec::Core::Runner.run(args, err, out)
        end

        build_result(err:, out:, status:)
      end

      private

      def build_result(err:, out:, status:)
        *output, raw_json = out.string.lines

        Result.new(
          output: output.join,
          errors: err.string,
          json:   JSON.parse(raw_json),
          status:
        )
      end

      def format_args(*files)
        [
          '--format=json',
          '--format=doc',
          '--order=defined',
          "--pattern=#{files.join(',')}"
        ]
      end
    end
  end
end
