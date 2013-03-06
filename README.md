# RSpec::SleepingKingStudios

A collection of matchers and extensions to ease TDD/BDD using RSpec.

## The Matchers

### Core

#### Construct Matcher

Verifies that the actual object can be constructed using :new. Can take an
optional number of arguments. _note:_ Not guaranteed to work with Ruby 2.0
keyword arguments. Caveat lector.

**How To Use:**

    expect(described_class).to construct.with(1).arguments

**Parameters:** None.

**Chaining:**
* **arguments:** Expects one Integer or Range argument. If an Integer, verifies
  that the constructor accepts that number of arguments; if a Range, verifies
  that the constructor accepts both the minimum and maximum number of
  arguments.

### RSpec

These meta-matchers are used to test other custom matchers.

#### Fail_Actual Matcher

Checks if the given matcher will fail to match a specified actual object. Can
take an optional string or regular expression to check the expected failure
message when the matcher is expected to pass, but does not.

_note:_ Do not use the not\_to syntax for this matcher; instead, use the
pass_actual matcher, below.

**How To Use:**

    expect(matcher).to fail_actual(actual).with_message(/expected to/)
    
**Parameters:** Matcher. Expects an object that, at minimum, responds to
:matches? and :failure\_message\_for\_should.

**Chaining:**
* **with\_message:** Takes one String or Regexp argument, which is matched
  against the given matcher's failure\_message\_for\_should.

#### Pass_Actual Matcher

Checks if the given matcher will match a specified actual object. Can take an
optional string or regular expression to check the expected failure message
when the matcher is expected to fail, but does not.

_note:_ Do not use the not\_to syntax for this matcher; instead, use the
fail_actual matcher, above.

**How To Use:**

  expect(matcher).to pass_actual(actual).with_message(/expected not to/)
  
**Parameters:** Matcher. Expects an object that, at minimum, responds to
:matches? and :failure\_message\_for\_should\_not.

**Chaining:**
* **with\_message:** Expects one String or Regexp argument, which is matched
against the given matcher's failure\_message\_for\_should\_not.
