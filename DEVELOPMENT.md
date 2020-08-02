# Development Notes

## Version 2.6

- Support ActiveModel 6
- Support RSpec 3.9

### Features - Matchers

- RespondToMatcher: |
    update to match core respond_to matcher
    - uses the signature from initialize to validate checks for new
    - see https://github.com/rspec/rspec-expectations/blob/master/Changelog.md
  subclass BeConstructibleMatcher from RespondTo ?

## Version 2.6+

- DeepMatcher: |
  - indifferent - symbol/string keys
  - ordered - pre-sort arrays?
    - only homogenous arrays?
    - odd results unless equality comparison

## Version 3.0

- Extract out Rails-specific matchers to RSpec::SleepingKingStudios::Rails.
- Refactor property, constant matchers to Define$1Matcher.
  - HaveConstantMatcher, HaveReaderMatcher, HavePredicateMatcher, HavePropertyMatcher, HaveWriterMatcher.
  - Designate define_* macros as primary, have_* as aliases.
  - Designate 'should define \*' examples as primary.
- Add RuboCop CI step.
  - Modernize code conventions.
- Add SimpleCov CI step.

## Future Tasks

### Bug Fixes

- false negative on #alias_method?
  - need reproduction steps!
  - compare via Method#source_location equality and Method#original_name is expected?
- when using a shared example from another context, ensure that the rspec-sleeping_king_studios definitions are NOT excluded from the backtrace on a failure.
  - can do this for now: |

    RSpec.configure do |config|
      examples_path = File.join(RSpec::SleepingKingStudios.gem_path, 'lib', 'rspec', 'sleeping_king_studios', 'examples')

      config.project_source_dirs << examples_path
    end

### Features - Core

- let?(:name) { } # Defines a memoized helper, but only if one is not already defined.

### Features - Examples

- matcher examples:
  - Enhance RSpec matcher examples to display the #failure_message on a failed "should pass/fail with" example.

### Features - Matchers

- BeImmutableMatcher (NEW):
  - Implement be_immutable matcher.
- RespondToMatcher:
  - Implement RespondToMatcher#with_optional_keywords, #with_required_keywords.
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
  - Run in external process, parse output for expected values (use Aruba?)
  - Allows testing of failing example groups
- Pare down Cucumber features for matchers - repurpose as documentation/examples only.
  - Break down into smaller (bite-sized?) individual examples.
- RuboCop - use RSpec rule file as starting point?
- frozen_string_literals pragma?

## Icebox

- Implement Matchers::define_negated_matcher.
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
  - Allows basic diffing of "what tests were run?"
- Add minimal test formatter - --format=smoke ? --format=librarian ? --format=quiet ?
  - Prints nothing for examples
  - Suppress STDOUT output? As configurable option for any formatter?
- Add DSL for shared_examples-heavy specs?
  - #should(name) => include_examples "should #{name}"
  - #with(name)   => wrap_context "with #{name}"
  - #when(name)   => wrap_context "when #{name}"
- General project for using matchers as Ruby objects
  - Inspectable - expectations, comparison results exposed via readers
  - Favor readers over instance variables.
- Ordering options:
  - group_by: option - allows grouping of examples, e.g. group_by: :fixtures. Groups all examples by each value of the given metadata. Also before/after/around(:group, fixtures: true)?
  - example group-level ordering
    - order :defined_and_fail_fast - run the specs in given order, but after a spec fails all further specs in that example group are marked as pending.
