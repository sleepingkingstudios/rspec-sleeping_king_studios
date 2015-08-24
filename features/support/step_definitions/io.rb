# features/step_definitions/io.rb

Then /^the output should contain consecutive lines:$/ do |table|
  actual   = all_output
  expected = table.raw.flatten.map do |string|
    Regexp.escape(string.strip)
  end.join('\s*\n\s*')

  expect(actual).to match(expected)
end
