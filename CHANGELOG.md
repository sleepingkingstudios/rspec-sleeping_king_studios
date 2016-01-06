# Changelog

## 2.1.1

### Concerns

#### 'FocusExamples' Concern

Added module RSpec::SleepingKingStudios::Concerns::FocusExamples to create a shorthand for quickly focusing/skipping included shared example groups, e.g. `include_examples '...'` => `finclude_examples '...'`.

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

    expect(object).to have_property(:my_method).with(an_instance_of(Fixnum))

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
