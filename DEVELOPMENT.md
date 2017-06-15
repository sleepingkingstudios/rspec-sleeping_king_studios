# Development Notes

## Version 2.3

### Features - Functionality

### Features - Quality of Life

- Add 'should have private reader/writer/property' shared examples.

### Features - Syntactic Sugar

- Alias `have_reader`, etc as `define_reader`.
  - Also alias shared examples.
- Alias `have_constant` as `define_constant`.
  - Alias #immutable as #frozen.
  - Also alias shared examples.

## Future Tasks

- Resolve Aruba deprecation warnings.

### Bug Fixes

- false negative on #alias_method?
  - need reproduction steps!
  - compare via Method#source_location equality and Method#original_name is expected?

### Features - Functionality

- Add spy+matcher for expect(my_object, :my_method).to have_changed ?

### Features - Quality of Life

- Implement RespondToMatcher#with_optional_keywords, #with_required_keywords.
- Implement be_immutable matcher.
- Enhance RSpec matcher examples to display the #failure_message on a failed "should pass/fail with" example.
- let?(:name) { } # Defines a memoized helper, but only if one is not already defined.

### Features - Syntactic Sugar

- Implement RespondToMatcher#with_at_least(N).arguments, equivalent to with(N).arguments.and_unlimited_arguments.

### Maintenance

- Update all Concerns to be #include-d, not #extend-ed.
- Update SharedExampleGroup concern to use Ruby paradigms:
  - overload #include_examples
  - use proper method-based lookup, inheritance, etc
  - less fragility than hooking into existing RSpec internals
- Revisit failure messages for #respond_to, #be_constructible - see #received/#have_received for example?
- Revisit how matchers are documented, particularly in README.md
  - Use matcher class name instead of macro names?
  - Clarify documentation of parameters - YARD-like?
- Integration specs for shared example groups
  - Run in external process, parse output for expected values (similar to Aruba)
  - Allows testing of failing example groups
- Pare down Cucumber features for matchers - repurpose as documentation/examples only.
  - Break down into smaller (bite-sized?) individual examples.
- RuboCop - use RSpec rule file as starting point?

## Icebox

- Chainable examples: |

  it 'should do something' do
    # Always run.
  end.
    then 'should do something else' do
      # Only runs if first example passes.
    end.
    then 'should do a third thing' do
      # Only runs if first and second examples pass.
    end

- Implement Matchers::define_negated_matcher.
- Implement RespondTo#with_optional_keywords.
- Implement negated compound matchers, e.g. expect().to match().and_not other_match()
  - Alias as "but_not"?
- Implement benchmarking specs:
  - Generate benchmarks for each test, save as file.
  - Each time the benchmark specs are run, compare the results to the expected values.
  - If the result is out of the expected range, fail the tests.
  - Configure to run on first test, expected/permitted range.
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
- General project for using matchers as Ruby objects
  - Inspectable - expectations, comparison results exposed via readers
  - Favor readers over instance variables.
