# RSpec::SleepingKingStudios

A collection of matchers and extensions to ease TDD/BDD using RSpec.

## The Matchers

### ActiveModel

These matchers validate ActiveModel functionality, such as validations.

#### have\_errors Matcher

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

These extend the built-in RSpec matchers with additional functionality.

#### be\_kind\_of Matcher

Now accepts an Array of types. The matcher passes if the actual object is
any of the parameter types.

Also allows nil parameter as a shortcut for NilClass.

**How To Use:**

    expect(instance).to be_kind_of [String, Symbol, nil]
    #=> passes iff instance is a String, a Symbol, or is nil

#### respond\_to Matcher

Now has additional chaining functionality to validate the number of arguments
accepted by the method, and whether the method accepts a block argument.

_Note:_ Not guaranteed to work with Ruby 2.0 keyword arguments. Caveat lector.

**How To Use:**

    expect(instance).to respond_to(:foo).with(2..3).arguments.and.a_block

**Chaining:**
* **a\_block:** No parameters. Verifies that the method accepts a block
  argument. _Important note:_ Does _not_ check whether the block is called or
  yielded.
* **with:** Expects one Integer or Range argument. If an Integer, verifies that
  the method accepts that number of arguments; if a Range, verifies that the
  method accepts both the minimum and maximum number of arguments.

### Core

#### construct Matcher

Verifies that the actual object can be constructed using :new. Can take an
optional number of arguments.

_Note:_ Not guaranteed to work with Ruby 2.0 keyword arguments. Caveat lector.

**How To Use:**

    expect(described_class).to construct.with(1).arguments

**Parameters:** None.

**Chaining:**
* **arguments:** Expects one Integer or Range argument. If an Integer, verifies
  that the constructor accepts that number of arguments; if a Range, verifies
  that the constructor accepts both the minimum and maximum number of
  arguments.

#### have\_accessor Matcher

Checks if the actual object responds to :property, and optionally if the
current value of actual.property is equal to a specified value.

**How To Use:**

    expect(instance).to have_accessor(:foo).with("foo")

**Parameters:** Property. Expects a string or symbol that is a valid
identifier.

**Chaining:**
* **with:** Expects one object, which is checked against the current value of
  actual.property if actual responds to :property.
  
#### have\_mutator Matcher

Checks if the actual object responds to :property=, and optionally if setting
object.property = value sets object.property to value.

**How To Use:**

    expect(instance).to have_mutator(:foo=).with("foo")

**Parameters:** Property. Expects a string or symbol that is a valid
identifier. An equals sign '=' is automatically added if the identifier does
not already terminate in '='.

**Chaining:**
* **with:** Expects one object. The matcher attempts to set the actual's value
  using actual.property=, then compare the value with actual.property.
  
  _Note:_ Currently, write-only properties cannot be checked using with().
  Attempting to do so will raise an exception.

#### include\_matching Matcher

Loops through an enumerable actual object and checks if any of the items
matches the given pattern.

**How To Use:**

    expect(instance).to include_matching(/[01]+/)

**Parameters:** Pattern. Expects a Regexp.

### RSpec

These meta-matchers are used to test other custom matchers.

#### fail\_with\_actual Matcher

Checks if the given matcher will fail to match a specified actual object. Can
take an optional string or regular expression to check the expected failure
message when the matcher is expected to pass, but does not.

_Note:_ Do not use the not\_to syntax for this matcher; instead, use the
pass_actual matcher, below.

**How To Use:**

    expect(matcher).to fail_actual(actual).with_message(/expected to/)
    
**Parameters:** Matcher. Expects an object that, at minimum, responds to
:matches? and :failure\_message\_for\_should.

**Chaining:**
* **with\_message:** Expects one String or Regexp argument, which is matched
  against the given matcher's failure\_message\_for\_should.

#### pass\_with\_actual Matcher

Checks if the given matcher will match a specified actual object. Can take an
optional string or regular expression to check the expected failure message
when the matcher is expected to fail, but does not.

_Note:_ Do not use the not\_to syntax for this matcher; instead, use the
fail_actual matcher, above.

**How To Use:**

  expect(matcher).to pass_actual(actual).with_message(/expected not to/)
  
**Parameters:** Matcher. Expects an object that, at minimum, responds to
:matches? and :failure\_message\_for\_should\_not.

**Chaining:**
* **with\_message:** Expects one String or Regexp argument, which is matched
against the given matcher's failure\_message\_for\_should\_not.
