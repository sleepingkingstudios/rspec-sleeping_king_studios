# Development Notes

## Tasks

- Resolve Aruba deprecation warnings.

### Planned Features

- Add `#with_any_keywords` alias to RespondToMatcher.
- Add #have_constant matcher.
- Add #have_predicate matcher.
- Add shared examples for 'should have constant', 'should have immutable constant'
- Add shared examples for 'should have predicate'
- Add shared examples for 'should not have reader/writer'
- Add shared examples for #belongs_to, #has_one, #has_many, #embedded_in, #embeds_one, #embeds_many.
- Add shared examples for core ActiveModel validations.
- Add allow/expect(object).to alias_method(:my_method).to(:other_method)
- Add allow/expect(object).to delegate(:my_method).to(other_object[, :other_method])

### Maintenance

- Remove SCENARIOS from spec files.
- Refactor #respond_to, #be_constructible to use RSpec 3 method reflection.
- Revisit failure messages for #respond_to, #be_constructible.
- Pare down Cucumber features for matchers - repurpose as documentation/examples only.
- Ensure behavior of `#have_reader`, `#have_writer`, `#have_property` is consistent (non-compatible; needs version 3.0).

### Icebox

- Add alt doc test formatter - --format=list ? --format=documentation-list ?
  - Prints full expanded example name for each example
- Add minimal test formatter - --format=smoke ? --format=librarian ? --format=quiet ?
  - Prints nothing for examples
  - Suppress STDOUT output? As configurable option for any formatted?
- Add DSL for shared_examples-heavy specs?
  - #should(name) => include_examples "should #{name}"
  - #with(name)   => wrap_context "with #{name}"
  - #when(name)   => wrap_context "when #{name}"
