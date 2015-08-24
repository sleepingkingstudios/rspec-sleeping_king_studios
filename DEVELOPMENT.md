# Development Notes

## Tasks

### Planned Features

- Add #have_constant matcher.
- Add shared examples for 'should have constant', 'should have immutable constant'
- Add shared examples for 'should not have reader/writer/property'
- Add shared examples for #belongs_to, #has_one, #has_many, #embedded_in, #embeds_one, #embeds_many.
- Add shared examples for core ActiveModel validations.

### Maintenance

- Remove SCENARIOS from spec files.
- Refactor #respond_to, #be_constructible to use RSpec 3 method reflection.
- Revisit failure messages for #respond_to, #be_constructible.
- Pare down Cucumber features for matchers - repurpose as documentation/examples only.
- - Ensure behavior of `#have_reader`, `#have_writer`, `#have_property` is consistent (non-compatible; needs version 3.0).

### Icebox

- Add alt doc test formatter - --format=list ? --format=documentation-list ?
  - Prints full expanded example name for each example
- Add minimal test formatter - --format=smoke ? --format=librarian ?
  - Prints nothing for examples
  - Suppress STDOUT output? As configurable option for any formatted?
