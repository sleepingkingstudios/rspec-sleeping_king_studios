# frozen_string_literal: true

begin
  require 'byebug'
rescue LoadError
  # Probably don't need this.
end

require 'sleeping_king_studios/tasks'

SleepingKingStudios::Tasks.configure do |config|
  config.ci do |ci|
    ci.rspec = ci.rspec.merge(format: 'progress')

    ci.steps =
      if ENV['CI']
        %i(rspec rspec_each cucumber)
      else
        %i(rspec cucumber)
      end
  end

  config.file do |file|
    file.template_paths =
      [
        '../sleeping_king_studios-templates/lib',
        file.class.default_template_path
      ]
  end
end

load 'sleeping_king_studios/tasks/ci/tasks.thor'
load 'sleeping_king_studios/tasks/file/tasks.thor'
