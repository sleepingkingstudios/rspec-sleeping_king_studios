# frozen_string_literal: true

require 'stringio'

require 'rspec/core/sandbox'

module Spec::Support
  module Sandbox
    Result = Struct.new(:doc, :errors, :json, :status, keyword_init: true) do
      def example_descriptions
        json['examples'].map { |hsh| hsh['full_description'] }
      end

      def summary
        json['summary_line']
      end
    end

    def self.run(*files) # rubocop:disable Metrics/MethodLength
      err    = StringIO.new
      out    = StringIO.new
      status = nil
      args   = [
        '--format=json',
        '--format=doc',
        '--order=defined',
        "--pattern=#{files.join(',')}"
      ]

      RSpec::Core::Sandbox.sandboxed do
        status = RSpec::Core::Runner.run(args, err, out)
      end

      *doc, raw_json = out.string.lines

      Result.new(
        doc:    doc.join,
        errors: err.string,
        json:   JSON.parse(raw_json),
        status: status
      )
    end
  end
end
