# RSpec::SleepingKingStudios [![Build Status](https://travis-ci.org/sleepingkingstudios/rspec-sleeping_king_studios.svg?branch=master)](https://travis-ci.org/sleepingkingstudios/rspec-sleeping_king_studios)

A collection of matchers and extensions to ease TDD/BDD using RSpec. Extends built-in matchers with new functionality, such as support for Ruby 2.0+ keyword arguments, and adds new matchers for testing boolean-ness, object reader/writer properties, object constructor arguments, ActiveModel validations, and more. Also defines shared example groups for more expressive testing.

## Supported Ruby Versions

Currently, the following versions of Ruby are officially supported:

* 2.0.0
* 2.1.0

## Contribute

- https://github.com/sleepingkingstudios/rspec-sleeping_king_studios

### A Note From The Developer

Hi, I'm Rob Smith, the maintainer of this library. As a professional Ruby
developer, I use these tools every day. If you find this project helpful in
your own work, or if you have any questions, suggestions or critiques, please
feel free to get in touch! I can be reached on GitHub (see above, and feel
encouraged to submit bug reports or merge requests there) or via email at
merlin@sleepingkingstudios.com. I look forward to hearing from you!

## Configuration

RSpec::SleepingKingStudios now has configuration options available through `RSpec.configuration`. For example, to set the behavior of the matcher examples when a failure message expectation is undefined (see RSpec Matcher Examples, below), put the following in your `spec_helper` or other configuration file:

    RSpec.configure do |config|
      config.sleeping_king_studios do |config|
        config.examples do |config|
          config.handle_missing_failure_message_with = :ignore
        end # config
      end # config
    end # config

## Custom Matchers

To enable a custom matcher, simply require the associated file. Matchers can be
required individually or by category:

    require 'rspec/sleeping_king_studios/all'
    #=> requires all features, including matchers

    require 'rspec/sleeping_king_studios/matchers/core/all'
    #=> requires all of the core matchers
    
    require 'rspec/sleeping_king_studios/matchers/core/construct'
    #=> requires only the :construct matcher

### ActiveModel

    require 'rspec/sleeping_king_studios/matchers/active_model/all'

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
* **with:** [Array<String>] Adds one or more messages to the previously-defined
  field validation. Raises ArgumentError if no field was previously set.
* **with\_message:** [String] Adds a message to the previously-defined field
  validation. Raises ArgumentError if no field was previously set.
* **with\_messages:** [Array<String>] Adds one or more messages to the
  previously-defined field validation. Raises ArgumentError if no field was
  previously set.

### BuiltIn

    require 'rspec/sleeping_king_studios/matchers/built_in/all'

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

Now has additional chaining functionality to validate the number of arguments accepted by the method, the keyword arguments (if any) accepted by the method, and whether the method accepts a block argument.

**How To Use:**

    # With a variable number of arguments.
    expect(instance).to respond_to(:foo).with(2..3).arguments.with_a_block

    # With keyword arguments.
    expect(instance).to respond_to(:foo).with(0, :bar, :baz)

**Chaining:**

* **with:** Expects at most one Integer or Range argument, and zero or more Symbol arguments corresponding to optional keywords. Verifies that the method accepts that keyword, or has a variadic keyword of the form `**params`. As of 2.1.0 and required keywords, verifies that all required keywords are provided.
* **with\_a\_block:** No parameters. Verifies that the method requires a block argument of the form `&my_argument`. _Important note:_ A negative result _does not_ mean the method cannot accept a block, merely that it does not require one. Also, _does not_ check whether the block is called or yielded.

### Core

    require 'rspec/sleeping_king_studios/matchers/core/all'

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

##### Ruby 2.0+

Has additional functionality to support Ruby 2.0 keyword arguments.

**How To Use:**
  expect(instance).to construct.with(0, :bar, :baz)

**Chaining:**

* **with:** Expects one Integer, Range, or nil argument, and zero or more
  Symbol arguments corresponding to optional keywords. Verifies that the
  class's constructor accepts that keyword, or has a variadic keyword of the
  form \*\*params.  As of 2.1.0 and required keywords, verifies that all 
  required keywords are provided.

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

* **with:** Expects one object, which is checked against the current value of actual.property if actual responds to :property. Can also be used with an RSpec matcher:

    expect(instance).to have_reader(:bar).with(an_instance_of(String))

#### have\_writer Matcher

    require 'rspec/sleeping_king_studios/matchers/core/have_writer'

Checks if the actual object responds to :property=.

**How To Use:**

    expect(instance).to have_writer(:foo=)

**Parameters:** Property. Expects a string or symbol that is a valid
identifier. An equals sign '=' is automatically added if the identifier does
not already terminate in '='.

#### include\_matching Matcher

    require 'rspec/sleeping_king_studios/matchers/core/include_matching'

Loops through an enumerable actual object and checks if any of the items
matches the given pattern.

**How To Use:**

    expect(instance).to include_matching(/[01]+/)

**Parameters:** Pattern. Expects a Regexp.

### Meta

    require 'rspec/sleeping_king_studios/matchers/meta/all'

These meta-matchers are used to test other custom matchers.

#### fail\_with\_actual Matcher

    require 'rspec/sleeping_king_studios/matchers/meta/fail_with_actual'

Checks if the given matcher will fail to match a specified actual object. Can
take an optional string to check the expected failure message when the matcher
is expected to pass, but does not.

_Note:_ Do not use the not\_to syntax for this matcher; instead, use the
pass\_with\_actual matcher, below.

**How To Use:**

    expect(matcher).to fail_with_actual(actual).with_message(/expected to/)
    
**Parameters:** Matcher. Expects an object that, at minimum, responds to
:matches? and :failure\_message.

**Chaining:**

* **with\_message:** Expects one String or Regexp argument, which is matched
  against the given matcher's failure\_message.

#### pass\_with\_actual Matcher

    require 'rspec/sleeping_king_studios/matchers/meta/pass_with_actual'

Checks if the given matcher will match a specified actual object. Can take an
optional string to check the expected failure message when the matcher is
expected to fail, but does not.

_Note:_ Do not use the not\_to syntax for this matcher; instead, use the
fail\_with\_actual matcher, above.

**How To Use:**

    expect(matcher).to pass_with_actual(actual).with_message(/expected not to/)
  
**Parameters:** Matcher. Expects an object that, at minimum, responds to
:matches? and :failure\_message\_when\_negated.

**Chaining:**

* **with\_message:** Expects one String or Regexp argument, which is matched
  against the given matcher's failure\_message\_when\_negated.

## Shared Examples

To use a custom example group, `require` the associated file and then `include`
the module in your example group:

    require 'rspec/sleeping_king_studios/examples/some_examples'

    RSpec.describe MyCustomMatcher do
      include RSpec::SleepingKingStudios::Examples::SomeExamples

      # You can use the custom shared examples here.
      include_examples 'some examples'
    end # describe

Unless otherwise noted, these shared examples expect the example group to define either an explicit `#instance` method (using `let(:instance) {}`) or an implicit `subject`. Their behavior is **undefined** if neither `#instance` nor `subject` is defined.

### RSpec Matcher Examples

These examples are used for validating custom RSpec matchers. They are used
internally by RSpec::SleepingKingStudios to verify the functionality of the
new and modified matchers.

    require 'rspec/sleeping_king_studios/examples/rspec_matcher_examples'

    RSpec.describe MyCustomMatcher do
      include RSpec::SleepingKingStudios::Examples::RSpecMatcherExamples

      # You can use the custom shared examples here.
    end # describe

The `#instance` or `subject` for these examples should be an instance of a class matching the RSpec matcher API. For example, consider a matcher that checks if a number is a multiple of another number. This matcher would be used as follows:

    expect(12).to be_a_multiple_of(3)
    #=> true

    expect(14).to be_a_multiple_of(3)
    #=> false

Therefore, the `#instance` or `subject` should be defined as `BeAMultipleMatcher.new(3)`. If the custom matcher has additional fluent methods or options, these can be added to the instance as well, e.g. `expect(15).to be_a_multiple_of(3).and_of(5)` would be tested as `BeAMultipleMatcher.new(3).and_of(5)`.

In addition, all of these examples require a defined `#actual` method in the example group containing the object to be tested. The actual object is the object used in the expectation. In the above examples, the actual object is `12` in the first example, and `14` in the second. You can define the `#actual` method using `#let()`, e.g. `let(:actual) { Object.new }`.

Putting it all together:

    require 'rspec/sleeping_king_studios/examples/rspec_matcher_examples'

    RSpec.describe BeAMultipleOfMatcher do
      include RSpec::SleepingKingStudios::Examples::RSpecMatcherExamples

      let(:instance) { BeAMultipleOfMatcher.new(3) }

      describe 'with a valid number' do
        let(:actual) { 15 }

        # Include examples here.

        describe 'with a second factor' do
          let(:instance) { BeAMultipleOfMatcher.new(3).and_of(5) }

          # Include examples here.
        end # describe
      end # describe
    end # describe

#### Passes With A Positive Expectation

    include_examples 'passes with a positive expectation'

Verifies that the instance matcher will pass with a positive expectation (e.g. `expect().to`). Equivalent to verifying the result of the following:

    expect(actual).to match_my_custom_matcher(*expected_values)
    #=> passes

#### Passes With A Negative Expectation

    include_examples 'passes with a negative expectation'

Verifies that the instance matcher will pass with a negative expectation (e.g. `expect().not_to`). Equivalent to verifying the result of the following:

    expect(actual).not_to match_my_custom_matcher(*expected_values)
    #=> passes

#### Fails With A Positive Expectation

    include_examples 'fails with a positive expectation'

Verifies that the instance matcher will fail with a positive expectation (e.g. `expect().to`), and have the expected failure message. Equivalent to verifying the result of the following:

    expect(actual).to match_my_custom_matcher(*expected_values)
    #=> fails

In addition, verifies the `#failure_message` of the matcher by comparing it against a `#failure_message` method in the example group. This should be defined using `let(:failure_message) { 'expected to match' }`.

The behavior if the example group does not define `#failure_message` depends on the value of the `RSpec.configure.sleeping_king_studios.examples.handle_missing_failure_message_with` option (see Configuration, above). Accepted values are `:ignore`, `:pending` (default; marks the example as pending), and `:exception` (raises an exception).

#### Fails With A Negative Expectation

    include_examples 'fails with a negative expectation'

Verifies that the instance matcher will fail with a negative expectation (e.g. `expect().not_to`), and have the expected failure message. Equivalent to verifying the result of the following:

    expect(actual).not_to match_my_custom_matcher(*expected_values)
    #=> fails

In addition, verifies the `#failure_message_when_negated` of the matcher by comparing it against a `#failure_message_when_negated` method in the example group. This should be defined using `let(:failure_message_when_negated) { 'expected not to match' }`.

See Fails With A Positive Expectatio, above, for behavior when the example group does not define `#failure_message_when_negated`.

## License

RSpec::SleepingKingStudios is released under the [MIT License](http://www.opensource.org/licenses/MIT).
