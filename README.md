# RSpec::SleepingKingStudios

A collection of matchers and extensions to ease TDD/BDD using RSpec.

## The Extensions

To enable an extension, simply require the associated file.

### Mocks

These extensions support the creation and use of mock objects.

#### custom\_double

    require 'rspec/sleeping_king_studios/mocks/custom_double'

As the built-in 'double' method, but accepts a block that is passed to
Class.new when the double is created, allowing you to create functional class
and instance methods on the double. Useful when you need to test a function or
sequence that repeatedly updates or checks the state of the injected object.

**How To Use:**

    custom_double('My Double', :foo => "Foo") { attr_accessor :bar }

## The Matchers

To enable a custom matcher, simply require the associated file. Matchers can be
required individually or by category:

    require 'rspec/sleeping_king_studios/matchers/core'
    #=> requires all of the core matchers
    
    require 'rspec/sleeping_king_studios/matchers/core/construct'
    #=> requires only the :construct matcher

### ActiveModel

    require 'rspec/sleeping_king_studios/matchers/active_model'

These matchers validate ActiveModel functionality, such as validations.

#### have\_errors Matcher

    require 'rspec/sleeping_king_studios/matchers/active_model/have_errors'

Verifies that the actual object has validation errors. Optionally can specify
individual fields to validate, or even specific messages for each attribute.

**How To Use:**

    expect(instance).to have_errors
    
    expect(instance).to have_errors.on(:name)
    
    expect(instance).to have_errors.on(:name).with_message('not to be nil')

**Chaining:**

* **on:** [String, Symbol] Adds a field to validate; the matcher only passes if
  all validated fields have errors.
* **with\_message:** [String] Adds a message to the previously-defined field
  validation. Raises ArgumentError if no field was previously set.

### BuiltIn

    require 'rspec/sleeping_king_studios/matchers/built_in'

These extend the built-in RSpec matchers with additional functionality.

#### be\_kind\_of Matcher

    require 'rspec/sleeping_king_studios/matchers/built_in/be_kind_of'

Now accepts an Array of types. The matcher passes if the actual object is
any of the parameter types.

Also allows nil parameter as a shortcut for NilClass.

**How To Use:**

    expect(instance).to be_kind_of [String, Symbol, nil]
    #=> passes iff instance is a String, a Symbol, or is nil

#### include Matcher

    require 'rspec/sleeping_king_studios/matchers/built_in/include'

Now accepts Proc parameters; items in the actual object are passed into
proc#call, with a truthy response considered a match to the item. In addition,
now accepts an optional block as a shortcut for adding a proc expectation.

**How To Use:**

    expect(instance).to include { |item| item =~ /pattern/ }

#### respond\_to Matcher

    require 'rspec/sleeping_king_studios/matchers/built_in/respond_to'

Now has additional chaining functionality to validate the number of arguments
accepted by the method, and whether the method accepts a block argument.

**How To Use:**

    expect(instance).to respond_to(:foo).with(2..3).arguments.and.a_block

**Chaining:**

* **a\_block:** No parameters. Verifies that the method requires a block
  argument of the form &my_argument. _Important note:_ A negative result does
  _not* mean the method cannot accept a block, merely that it does not require
  one. Also, does _not_ check whether the block is called or yielded.
* **with:** Expects one Integer or Range argument. If an Integer, verifies that
  the method accepts that number of arguments; if a Range, verifies that the
  method accepts both the minimum and maximum number of arguments.

##### Ruby 2.0

Has additional functionality to support Ruby 2.0 keyword arguments.

**How To Use:**
  expect(instance).to respond_to(:foo).with(0, :bar, :baz)

**Chaining:**

* **with:** Expects one Integer, Range, or nil argument, and zero or more
  Symbol arguments corresponding to optional keywords. Verifies that the method
  accepts that keyword, or has a variadic keyword of the form \*\*params.

  _Important note:_ If you do not wish to validate the number of arguments,
  make sure to use nil as the first argument to #with; otherwise, the matcher
  will interpret your first keyword as the number of arguments to expect. And
  then explode.

### Core

    require 'rspec/sleeping_king_studios/matchers/core'

These matchers check core functionality, such as object boolean-ness, the
existence of properties, and so on.

#### be_boolean Matcher

    require 'rspec/sleeping_king_studios/matchers/core/be_boolean'

Checks if the provided object is true or false.

**How To Use:**

    expect(object).to be_boolean

**Parameters:** None.

#### construct Matcher

    require 'rspec/sleeping_king_studios/matchers/core/construct'

Verifies that the actual object can be constructed using :new. Can take an
optional number of arguments.

**How To Use:**

    expect(described_class).to construct.with(1).arguments

**Parameters:** None.

**Chaining:**

* **with:** Expects one Integer or Range argument. If an Integer, verifies that
  the class's constructor accepts that number of arguments; if a Range,
  verifies that the constructor accepts both the minimum and maximum number of
  arguments.

##### Ruby 2.0

Has additional functionality to support Ruby 2.0 keyword arguments.

**How To Use:**
  expect(instance).to construct.with(0, :bar, :baz)

**Chaining:**

* **with:** Expects one Integer, Range, or nil argument, and zero or more
  Symbol arguments corresponding to optional keywords. Verifies that the
  class's constructor accepts that keyword, or has a variadic keyword of the
  form \*\*params.

  _Important note:_ If you do not wish to validate the number of arguments,
  make sure to use nil as the first argument to #with; otherwise, the matcher
  will interpret your first keyword as the number of arguments to expect. And
  then explode.

#### have\_property Matcher

    require 'rspec/sleeping_king_studios/matchers/core/have_property'

Checks if the actual object responds to :property and :property=, and
optionally if a value written to actual.property= can then be read by
actual.property.

**How To Use:**

    expect(instance).to have_property(:foo).with("foo")

**Parameters:** Property. Expects a string or symbol that is a valid
identifier.

**Chaining:**

* **with:** Expects one object, which is written to actual.property= and then
  read from actual.property.

#### have\_reader Matcher

    require 'rspec/sleeping_king_studios/matchers/core/have_reader'

Checks if the actual object responds to :property, and optionally if the
current value of actual.property is equal to a specified value.

**How To Use:**

    expect(instance).to have_reader(:foo).with("foo")

**Parameters:** Property. Expects a string or symbol that is a valid
identifier.

**Chaining:**

* **with:** Expects one object, which is checked against the current value of
  actual.property if actual responds to :property.
  
#### have\_writer Matcher

    require 'rspec/sleeping_king_studios/matchers/core/have_writer'

Checks if the actual object responds to :property=, and optionally if setting
object.property = value sets object.property to value.

**How To Use:**

    expect(instance).to have_writer(:foo=).with("foo")

**Parameters:** Property. Expects a string or symbol that is a valid
identifier. An equals sign '=' is automatically added if the identifier does
not already terminate in '='.

**Chaining:**

* **with:** Expects one object. The matcher attempts to set the actual's value
  using actual.property=, then compare the value with actual.property.
  
  _Note:_ Currently, write-only properties cannot be checked using with().
  Attempting to do so will raise an exception.

#### include\_matching Matcher

    require 'rspec/sleeping_king_studios/matchers/core/include_matching'

Loops through an enumerable actual object and checks if any of the items
matches the given pattern.

**How To Use:**

    expect(instance).to include_matching(/[01]+/)

**Parameters:** Pattern. Expects a Regexp.

### RSpec

    require 'rspec/sleeping_king_studios/matchers/rspec'

These meta-matchers are used to test other custom matchers.

#### fail\_with\_actual Matcher

    require 'rspec/sleeping_king_studios/matchers/rspec/fail_with_actual'

Checks if the given matcher will fail to match a specified actual object. Can
take an optional string to check the expected failure message when the matcher
is expected to pass, but does not.

_Note:_ Do not use the not\_to syntax for this matcher; instead, use the
pass\_with\_actual matcher, below.

**How To Use:**

    expect(matcher).to fail\_with\_actual(actual).with\_message(/expected to/)
    
**Parameters:** Matcher. Expects an object that, at minimum, responds to
:matches? and :failure\_message\_for\_should.

**Chaining:**

* **with\_message:** Expects one String or Regexp argument, which is matched
  against the given matcher's failure\_message\_for\_should.

#### pass\_with\_actual Matcher

    require 'rspec/sleeping_king_studios/matchers/rspec/pass_with_actual'

Checks if the given matcher will match a specified actual object. Can take an
optional string to check the expected failure message when the matcher is
expected to fail, but does not.

_Note:_ Do not use the not\_to syntax for this matcher; instead, use the
fail\_with\_actual matcher, above.

**How To Use:**

    expect(matcher).to pass\_with\_actual(actual)
  
**Parameters:** Matcher. Expects an object that, at minimum, responds to
:matches? and :failure\_message\_for\_should\_not.

**Chaining:**

* **with\_message:** Expects one String or Regexp argument, which is matched
  against the given matcher's failure\_message\_for\_should\_not.
