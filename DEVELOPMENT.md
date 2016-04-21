# Development Notes

## Version 2.2.0

### Features

- Add #have_constant matcher.
- Add #have_predicate matcher.
- Add shared examples for 'should have constant', 'should have immutable constant'
- Add shared examples for 'should have predicate'
- Add shared examples for 'should not have reader/writer'

### Maintenance

- Update spec files
  - Replace top-level "describe" with "RSpec.describe" in spec files.
  - Remove SCENARIOS from spec files.
  - Matching behavior should be wrapped in a `describe '#matches?'` block.
  - Isolate specs for matchers (#matches?, et al) from example group macros/aliases.
- Clean up code styles
  - Use before/after/around(:example) instead of (:each).
  - Use 'should' variants of examples.
- Alias new syntax as deprecated syntax, not the other way around.

## Tasks

- Resolve Aruba deprecation warnings.

### Planned Features

- Add shared examples for #belongs_to, #has_one, #has_many, #embedded_in, #embeds_one, #embeds_many.
- Add shared examples for core ActiveModel validations.
- Add allow/expect(object).to alias_method(:my_method).to(:other_method)
- Add allow/expect(object).to delegate(:my_method).to(other_object[, :other_method])

### Maintenance

- Revisit how matchers are documented, particularly in README.md
  - Use matcher class name instead of macro names?
  - Clarify documentation of parameters - YARD-like?
- Refactor #respond_to, #be_constructible to use RSpec 3 method reflection.
- Revisit failure messages for #respond_to, #be_constructible - see #received/#have_received for example?
- Pare down Cucumber features for matchers - repurpose as documentation/examples only.
- Ensure behavior of `#have_reader`, `#have_writer`, `#have_property` is consistent (non-compatible; needs version 3.0).

### Icebox

- Implement shared example group for Rails controller, 'should respond with'
- Implement shared example group for Rails routing, 'should route to'
- Extract ActiveModel/Rails functionality to sub-gem?
- Add alt doc test formatter - --format=list ? --format=documentation-list ?
  - Prints full expanded example name for each example
- Add minimal test formatter - --format=smoke ? --format=librarian ? --format=quiet ?
  - Prints nothing for examples
  - Suppress STDOUT output? As configurable option for any formatted?
- Add DSL for shared_examples-heavy specs?
  - #should(name) => include_examples "should #{name}"
  - #with(name)   => wrap_context "with #{name}"
  - #when(name)   => wrap_context "when #{name}"
- Add spy+matcher for expect(my_object, :my_method).to have_changed ?
