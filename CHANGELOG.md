# Changelog

## 2.3.0

### Concerns

Added ExampleConstants concern to define named, example-scoped constants and classes.

Added Toolbelt concern to automatically expose SleepingKingStudios::Tools methods in examples and example groups.

Added WrapEnv concern to cleanly control environment variables per example or within example blocks.

## 2.2.4

Reverted support for RSpec 3.0 to 3.2.

## 2.2.3

Added support for RSpec 3.6, dropped support for RSpec 3.0 to 3.2.

## 2.2.2

Added configuration option to catch empty #include matchers.

## 2.2.1

Fixed dependency on a pre-release SleepingKingStudios::Tools.

## 2.2.0

### Examples

#### PropertyExamples

Added examples 'should have constant' and 'should have immutable constant', which provide shortcuts for the new 'have_constant' matcher.

Added examples 'should have predicate' as a shortcut for the new 'have_predicate' matcher.

Added negated examples 'should not have reader' and 'should not have writer'.

#### RSpecMatcherExamples

Updated matcher testing examples (e.g. 'should pass with positive expectation', 'should fail with negative expectation') to support matching failure messages against strings, regular expressions, or RSpec matchers. Added configuration option for string matches to select exact match or partial/substring match.

### Matchers

Internally refactored all matcher definitions to *\_matcher.rb, while the previous *.rb files define the macros which are added to example groups. The file names now accurately reflect what they define. In addition, the matchers can be required separately from the macros, e.g. to get around a naming conflict with another library. Also added support for aliasing matchers.

#### `alias_method` Matcher

Added the `alias_method` matcher, which checks if the object aliases the specified method with the specified other name.

#### `be_boolean` Matcher

Now aliases as `a_boolean`, e.g. `expect(my_object).to have_reader(:my_method).with_value(a_boolean)`.

### `construct` and `respond_to` Matchers

The `construct` and `respond_to` matcher is now stricter about accepting methods with undefined argument counts. Specifically, if a method requires a minimum number of arguments, and the matcher does not have an argument count expectation but does have at least one other argument expectation (unlimited arguments, keywords, block argument, and so on), the expectation would pass on pre-2.2 versions. This is considered a bug and has been fixed. These matchers should either only check if the method is defined (if there are no argument expectations), or check that the exact argument expectations given are valid for that method.

Major internal refactoring to DRY parameter matching and ensure consistent behavior between the `construct` and `respond_to` matchers.

#### `delegate_method` Matcher

Added the `delegate_method` matcher, which checks if the object forwards the specified method to the specified target.

#### `have_constant` Matcher

Added the `have_constant` matcher, which checks for the presence of a defined constant `:CONSTANT_NAME` and optionally the value of the constant. Can also check that the value is immutable.

#### `have_predicate` Matcher

Added the `have_predicate` matcher, which checks for the presence of a predicate method `#property?` and optionally the value returned by `#property?()`.

#### `have_reader` Matcher

The `have_reader` matcher is not stricter about rejecting methods with a value expectation when negated. Previously, if the matcher was negated and had a value expectation, the matcher would only fail if the object responded to the method and returned the specified value, but would pass if the object returned another value. This is considered a bug and has been fixed, bringing this matcher in line with the behavior of the `have_property` matcher. A negated `have_reader` matcher should fail if the object responds to the method, whether or not the expected value is the same.

## 2.1.1

### Concerns

#### `FocusExamples` Concern

Added module RSpec::SleepingKingStudios::Concerns::FocusExamples to create a shorthand for quickly focusing/skipping included shared example groups, e.g. `include_examples '...'` => `finclude_examples '...'`.

#### `WrapExamples` Concern

Ensured correct behavior when passing an empty keywords hash to a method with optional arguments.

### Matchers

#### `respond_to` Matcher

Added methods `#with_any_keywords` and `#and_any_keywords`, which are both equivalent to the existing `#with_arbitrary_keywords`.

## 2.1.0

### Concerns

#### `WrapExamples` Concern

Added module RSpec::SleepingKingStudios::Concerns::WrapExamples to support a common use case for shared examples/shared contexts and avoid surprising behavior when using multiple adjacent shared contexts (or shared examples that have side effects).

## 2.0.3

Internal update to add support for RSpec 3.3.

## 2.0.2

### Matchers

#### `construct` and `respond_to` Matchers

Added new fluent syntax for keyword expectations:

    expect(my_object).to respond_to(:my_method).with(1..2).arguments.and_keywords(:foo, :bar)

Also added support for expecting splatted arguments (`*args`) or keywords (`**kwargs`) using the `#with_unlimited_arguments` and `#with_arbitrary_keywords` methods.

The old syntax (`respond_to(:my_method).with(1, :foo, :bar)`) will be supported through 3.0.

## 2.0.1

Created suite of [Cucumber features](features) to validate and document the gem.

### Matchers

#### `construct` Matcher

Aliased as `be_constructible` for more fluent specs, and the error messages have been changed from 'expected ... to construct' to 'expected ... to be constructible'.

## 2.0.0

Update the entire library to support RSpec 3. Most of the updates are purely internal, but there are a few changes that are not backward compatible to be aware of.

### Ruby 1.9.3 Support

Support for Ruby 1.9.3 is officially dropped.

### Concerns

Added module RSpec::SleepingKingStudios::Concerns::SharedExampleGroup as a mixin for defining scoped shared example groups. Extend into a module to define shared example groups scoped to that module (and automatically included in example groups when the module is included), or extend into an example group to allow aliasing shared example groups with alternate or more expressive names.

### Custom Examples

Added custom shared example groups for easier/more expressive tests.

#### Property Examples

Added 'has reader', 'has writer', and 'has property' examples as shorthand for defining property and attribute expectations.

#### RSpec Matcher Examples

Added custom examples for testing RSpec matchers. Replaces the (now removed) `pass_with_actual` and `fail_with_actual` matchers, which were fiddly and confusing (even for me) and couldn't handle all cases (such as failing on both `expect().to` and `expect().not_to`).

### Custom Matchers

All matchers have been updated to support the RSpec 3 matcher API.

#### `construct` Matcher

Now has a fluent method for both `#argument` and `#arguments` to support the singular and plural use cases, similar to the built-in `respond_to` matcher.

    expect(FooClass).to construct.with(1).argument
    expect(BarClass).to construct.with(3).arguments

#### `fail_with_actual` Matcher

Removed. To test custom matchers, use the new shared examples (see Shared Examples, below).

#### `have_errors` Matcher

Adds the `#with` fluent method as an alias to `#with_messages`, as follows:

    expect(model).to have_errors.on(:my_field).with("can't be blank")

In addition, the have_errors matcher will fail on both a positive expectation (`expect().to`) and a negative expectation (`expect().not_to` or `expect().to_not`) if the actual object does not respond to `#valid?`. The failure message has also been clarified for cases like `expect().not_to have_errors.on(attribute)`.

#### `have_property` Matcher

Removed the functionality checking the value of `:property` after `:property=` has been invoked. The syntax for doing so was not expressive, and the feature was rarely used. To verify that invoking `:property=` will change `:property` to the desired value, set up the change expectation directly using a `#change` matcher.

Now supports composable matchers, as follows:

    expect(object).to have_property(:my_method).with(an_instance_of(Integer))

Also added `#with_value` as an alias for `with`, and the error messages have been edited for clarity.

#### `have_reader` Matcher

Now supports composable matchers, as follows:

    expect(object).to have_reader(:my_method).with(an_instance_of(String))

Also added `#with_value` as an alias for `with`, and the error messages have been edited for clarity.

#### `have_writer` Matcher

Removed the functionality checking the value of `:property` after `:property=` has been invoked. The syntax for doing so was not expressive, and the feature was rarely used. To verify that invoking `:property=` will change `:property` to the desired value, set up the change expectation directly using a `#change` matcher.

The error messages have also been edited for clarity.

#### `pass_with_actual` Matcher

Removed. To test custom matchers, use the new shared examples (see Shared Examples, below).

#### `respond_to` Matcher

The `#and` fluent method has been removed, and the `#a_block` method for verifying the presence of a block argument has been renamed to `#with_a_block`. In addition, by passing in `true` as the last argument, can check for the presence and arguments of protected or private methods, similar to the Ruby `Object#respond_to?` method.

### Mocks

The #custom_double mock method has been completely removed. The recommended solution for that use case is `double('My Double').extend(MyModule)`, for some `MyModule` that implements the desired actual (non-stubbed) functionality.

### Shared Examples

Adds a new category of features, Shared Example groups, that can be included for easier or more expressive spec definitions.

#### Examples for Custom RSpec Matchers

Added four new shared examples to test custom matchers:

    include_examples 'passes with a positive expectation'
    include_examples 'passes with a negative expectation'
    include_examples 'fails with a positive expectation'
    include_examples 'fails with a negative expectation'

## 1.0.1

### New Features

* The #construct and #respond_to matchers now support 2.1.0 required keyword
  arguments, of the form def foo(bar:, baz:). If the class constructor or
  method requires one or more keyword arguments, and one or more of those
  keywords are not provided when checking arguments using the #with
  method, the matcher will fail with the message "missing keywords" and a list
  of the keywords that were not provided as arguments to #with.

## 1.0.0

* Official release.
