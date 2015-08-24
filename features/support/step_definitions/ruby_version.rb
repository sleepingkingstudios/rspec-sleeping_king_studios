# features/step_definitions/ruby_version.rb

Given(/^Ruby (\d+)\.(\d+) or greater$/) do |major, minor|
  pending unless RUBY_VERSION >= "#{major}.#{minor}.0"
end # Given
