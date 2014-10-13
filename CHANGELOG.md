# Changelog

## 2.0.0

Update the entire library to support RSpec 3. Most of the updates are purely
internal, but there are a few changes that are not backward compatible to be
aware of.

### Ruby 1.9.3 Support

Support for Ruby 1.9.3 is officially dropped.

### Custom Matchers

All matchers have been updated to support the RSpec 3 matcher API.

#### construct Matcher

Now has a fluent method for both #argument and #arguments to support the
singular and plural use cases, similar to the built-in respond_to matcher.

    expect(FooClass).to construct.with(1).argument
    expect(BarClass).to construct.with(3).arguments

#### fail_with_actual Matcher

Now correctly handles the #does_not_match? case for the new matcher API.

#### have_errors Matcher

Adds the `#with` fluent method as an alias to `#with_messages`, as follows:

    expect(model).to have_errors.on(:my_field).with("can't be blank")

In addition, the have_errors matcher will fail on both a positive expectation (`expect().to`) and a negative expectation (`expect().not_to` or `expect().to_not`) if the actual object does not respond to `#valid?`. The failure message has also been clarified for cases like `expect().not_to have_errors.on(attribute)`.

#### respond\_to Matcher

The `#and` fluent method has been removed, and the `#a_block` method for verifying the presence of a block argument has been renamed to `#with_a_block`. In addition, by passing in `true` as the last argument, can check for the presence and arguments of protected or private methods, similar to the Ruby `Object#respond_to?` method.

### Mocks

The #custom_double mock method has been completely removed. The recommended
solution for that use case is `double('My Double').extend(MyModule)`, for some
`MyModule` that implements the desired actual (non-stubbed) functionality.

### Shared Examples

Adds a new category of features, Shared Example groups, that can be included for easier or more expressive spec definitions.

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
