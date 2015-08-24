# Rakefile

require "rubygems"
require "bundler/setup"
require 'rspec/core/rake_task'
require 'cucumber/rake/task'
require 'open3'

Cucumber::Rake::Task.new

RSpec::Core::RakeTask.new(:spec)

ANSI_COLOR_FORMAT = "\033[%im%s\033[30m"
ANSI_COLOR_VALUES = %w(black red green yellow blue magenta cyan gray).each.with_index.with_object({}) { |(color, index), hsh| hsh[color] = 30 + index }

def ansi_color(color, string)
  ANSI_COLOR_FORMAT % [ANSI_COLOR_VALUES.fetch(color, 41), string]
end # method ansi_color

ANSI_COLOR_VALUES.keys.each do |color|
  define_method "ansi_#{color}" do |string|
    ansi_color color, string
  end # method
end # each

def pluralize(count, singular, plural)
  count == 1 ? singular : plural
end

task :default => :ci

task :ci do
  task_name = ENV['APPRAISAL_INITIALIZED'] ? 'ci:terse' : 'ci:default'

  Rake::Task[task_name].invoke
end # task

namespace :ci do
  task :default => [:cucumber, :spec]

  task :terse do
    print "\n"

    output = 'Cucumber: '

    io = `rake cucumber`

    if match = io.match(/^(?<scenarios>\d+ scenarios) \(((?<failed>\d+ failed), )?((?<undefined>\d+ undefined), )?/)
      output << [
        ansi_green(match[:scenarios]),
        match[:failed] ? ansi_red(match[:failed].sub('failed', pluralize(match[:failed].split(' ')[0].to_i, 'failure', 'failures'))) : ansi_green('0 failures'),
        match[:undefined] ? ansi_yellow(match[:undefined].sub('undefined', 'pending')) : nil
      ].compact.join(', ')

      match = io.match /^(?<minutes>\d+)m(?<seconds>\d+(\.\d+)?)s/
      output << " in #{60 * match[:minutes].to_i + match[:seconds].split('.').first.to_i}.#{match[:seconds].split('.').last.to_i} seconds.\n"

      puts output
    else
      puts io
    end

    output = 'RSpec:    '

    io = `rake spec`

    if match = io.match(/^(?<examples>\d+ examples?), (?<failures>\d+ failures?)(, (?<pending>\d+ pending))?/)
      output << [
        ansi_green(match[:examples]),
        match[:failures] =~ /[1-9]/ ? ansi_red(match[:failures]) : ansi_green(match[:failures]),
        match[:pending] ? ansi_yellow(match[:pending]) : nil
      ].compact.join(', ')

      match = io.match /^Finished in (?<duration>\d+(\.\d+)? seconds)/
      output << ' in ' << match[:duration] << '.' << "\n"

      puts output
    else
      puts io
    end

    print "\n"
  end # task
end # namespace
