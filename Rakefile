# Rakefile

require "rubygems"
require "bundler/setup"
require 'rspec/core/rake_task'
require 'cucumber/rake/task'
require 'open3'

Cucumber::Rake::Task.new

RSpec::Core::RakeTask.new(:spec)

def capture_io(task)
  io = ''

  Open3::popen3("rake #{task}") do |stdin, stdout, stderr|
    begin
      while line = stdout.readline
        io << line
      end #  while
    rescue EOFError
    end # begin-rescue
  end # open pipe

  io
end # method capture_io

def pluralize(count, singular, plural)
  count == 1 ? singular : plural
end

task :default do
  task_name = ENV['APPRAISAL_INITIALIZED'] ? 'ci:terse' : 'ci:default'

  Rake::Task[task_name].invoke
end # task

namespace :ci do
  task :default => [:spec, :cucumber]

  task :terse do
    print "\n"

    output = 'Cucumber: '

    io = capture_io 'cucumber'

    match = io.match /^(?<scenarios>\d+ scenarios) \(((?<failed>\d+ failed), )?((?<undefined>\d+ undefined), )?/
    output << [
      match[:scenarios],
      match[:failed] ? match[:failed].sub('failed', pluralize(match[:failed].split(' ')[0].to_i, 'failure', 'failures')) : '0 failures',
      match[:undefined] ? match[:undefined].sub('undefined', 'pending') : nil
    ].compact.join(', ')

    match = io.match /^(?<minutes>\d+)m(?<seconds>\d+(\.\d+)?)s/
    output << " in #{60 * match[:minutes].to_i + match[:seconds].split('.').first.to_i}.#{match[:seconds].split('.').last.to_i} seconds.\n"

    puts output

    output = 'RSpec:    '

    io = capture_io 'spec'

    match = io.match /^(?<examples>\d+ examples?), (?<failures>\d+ failures?)(, (?<pending>\d+ pending))?/
    output << [
      match[:examples],
      match[:failures],
      match[:pending]
    ].compact.join(', ')

    match = io.match /^Finished in (?<duration>\d+(\.\d+)? seconds)/
    output << ' in ' << match[:duration] << '.' << "\n"

    puts output

    print "\n"
  end # task
end # namespace
