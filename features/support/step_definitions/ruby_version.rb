# features/step_definitions/ruby_version.rb

When('the Ruby version is less than {string}') do |version|
  pending unless RUBY_VERSION < version
end

Given(/^Ruby (\d+)\.(\d+) or greater$/) do |major, minor|
  pending unless RUBY_VERSION >= "#{major}.#{minor}.0"
end # Given
