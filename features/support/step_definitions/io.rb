# features/step_definitions/io.rb

require 'erb'

Then /^the output should contain consecutive lines:$/ do |table|
  actual    = all_commands.map { |c| c.output }.join("\n")
  lines     = actual.lines.reject { |s| s.strip.empty? }
  expected  =
    table.raw.flatten.map do |str|
      next str unless str =~ /<%/

      ERB.new(str).result(binding)
    end # map
  all_match = nil

  lines.each.with_index do |_, line_index|
    all_match = true

    expected.each.with_index do |expected_line, expected_index|
      line = lines[line_index + expected_index]

      unless line && !line.empty?
        all_match = false

        next
      end # unless

      matcher = include(expected_line)

      next if matcher.matches?(line)

      all_match = false

      break
    end # each

    break if all_match
  end # end

  unless all_match
    message = 'The output did not contain the expected lines.'

    RSpec::Expectations.fail_with message, actual, expected
  end # unless
end # step
