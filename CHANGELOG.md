# Changelog

## 2.0.0.alpha

Update the entire library to support RSpec 3. Most of the updates are purely
internal, but there are a few changes that are not backward compatible to be
aware of.

### Matchers

All matchers have been updated to support the RSpec 3 matcher API.

#### fail_with_actual Matcher

Now correctly handles the #does_not_match? case for the new matcher API.

#### respond\_to Matcher

The #and fluent method has been removed, and the #a_block method for verifying
the presence of a block argument has been renamed to #with_a_block.

### Mocks

The #custom_double mock method has been completely removed. The recommended
solution for that use case is `double('My Double').extend(MyModule)`, for some
`MyModule` that implements the desired actual (non-stubbed) functionality.

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
