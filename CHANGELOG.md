# Changelog

## 1.0.1

### New Features

* The #construct and #respond_to matchers now support 2.1.0 required keyword
  arguments, of the form def foo(bar:, baz:). If the class constructor or
  method requires one or more keyword arguments, and one or more of those 
  keywords are not provided when checking arguments using the #with
  method, the matcher will fail with the message "missing keywords" and a list of the keywords that were not provided as arguments to #with.

## 1.0.0

* Official release.
