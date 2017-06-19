# spec/support/file_examples.rb

require 'fileutils'

require 'sleeping_king_studios/tools/toolbox/mixin'

require 'rspec/sleeping_king_studios/concerns/shared_example_group'

module Spec
  module Support
    module FileExamples
      extend SleepingKingStudios::Tools::Toolbox::Mixin
      extend RSpec::SleepingKingStudios::Concerns::SharedExampleGroup

      module ClassMethods
        def spec_filename
          @spec_filename ||=
            parent_groups.
              reverse.map(&:description).map do |desc|
                desc =~ /::/ ? nil : format_description(desc)
              end. # end map
              compact.
              tap { |ary| ary << 'spec.rb' }.
              join('_')
        end # class method spec_filename

        def spec_filepath
          return spec_filename if spec_namespace.empty?

          File.join(*Array(spec_namespace), spec_filename)
        end # class method spec_filepath

        def spec_namespace
          []
        end # class method spec_namespace

        private

        def format_description desc
          desc = desc.sub(/\A["']/, '').sub(/["']\z/, '')

          tools.string.underscore(desc).gsub(/\s+|-/, '_')
        end # class method format_description

        def tools
          SleepingKingStudios::Tools::Toolbelt.instance
        end # class method tools
      end # module

      shared_context 'with a file named' do |filename, contents|
        before(:example) do
          FileUtils.mkdir_p File.dirname(filename)

          File.write(filename, trim_contents(contents))
        end # before example
      end # shared context

      shared_context 'with a temporary file named' do |filename, contents|
        filename = File.join('tmp', 'spec', filename)

        include_examples 'with a file named', filename, contents

        after(:example) do
          File.delete(filename) unless ENV['DEBUG']
        end # after example
      end # shared context

      shared_context 'with a spec file containing' do |contents|
        include_examples 'with a temporary file named', spec_filepath, contents
      end # shared context

      def run_spec_file filename = nil
        filename ||= self.class.spec_filepath
        filename = "#{filename}_spec.rb" unless filename.end_with?('_spec.rb')

        `rspec #{File.join 'tmp', 'spec', filename}`
      end # method run_spec_file

      def tools
        SleepingKingStudios::Tools::Toolbelt.instance
      end # class method tools

      def trim_contents raw
        trim =
          raw.each_line.reduce(80) do |memo, line|
            next memo if line.rstrip.empty?

            match = line.match(/\A\s*/)

            [memo, match[0].length].min
          end # reduce

        tools.string.map_lines(raw) { |line| line[trim..-1] || line }
      end # method trim_contents
    end # module
  end # module
end # module
