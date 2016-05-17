# Development Notes

## Version 2.2.0

### Features

- Add #have_constant matcher.
- Add shared examples for 'should have constant', 'should have immutable constant'
- Add shared examples for 'should have predicate'
- Add shared examples for 'should not have reader/writer'

### Maintenance

## Tasks

- Resolve Aruba deprecation warnings.

### Planned Features

- Implement RespondToMatcher#with_at_least(N).arguments, equivalent to with(N).arguments.and_unlimited_arguments

### Maintenance

- Revisit how matchers are documented, particularly in README.md
  - Use matcher class name instead of macro names?
  - Clarify documentation of parameters - YARD-like?
- Revisit failure messages for #respond_to, #be_constructible - see #received/#have_received for example?
- Pare down Cucumber features for matchers - repurpose as documentation/examples only.

## Icebox

- Extract ActiveModel/Rails functionality to sub-gem?
  - Add shared examples for #belongs_to, #has_one, #has_many, #embedded_in, #embeds_one, #embeds_many.
  - Add shared examples for core ActiveModel validations.
  - Implement shared example group for Rails controller, 'should respond with'
  - Implement shared example group for Rails routing, 'should route to'
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
