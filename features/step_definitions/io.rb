# features/step_definitions/io.rb

Then /^the output should contain consecutive lines:$/ do |table|
  match = table.raw.flatten.map do |string|
    Regexp.escape(string.strip)
  end.join('\s*\n\s*')

  assert_matching_output(match, all_output)
end
