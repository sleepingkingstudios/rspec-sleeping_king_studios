# RSpec::SleepingKingStudios [![Build Status](https://travis-ci.org/sleepingkingstudios/rspec-sleeping_king_studios.svg?branch=master)](https://travis-ci.org/sleepingkingstudios/rspec-sleeping_king_studios)

A collection of matchers and extensions to ease TDD/BDD using RSpec. Extends built-in matchers with new functionality, such as support for Ruby 2.0+ keyword arguments, and adds new matchers for testing boolean-ness, object reader/writer properties, object constructor arguments, ActiveModel validations, and more. Also defines shared example groups for more expressive testing.

## Support

RSpec::SleepingKingStudios is tested against RSpec 3.0, 3.1, 3.2, and 3.3.

Currently, the following versions of Ruby are officially supported:

* 2.0
* 2.1
* 2.2

If you require a previous version of Ruby or RSpec, the 1.0 branch supports Ruby 1.9.3 and RSpec 2: `gem "rspec-sleeping_king_studios", "~> 1.0.1"`. However, changes from 2.0 and higher will not be backported.

## Contribute

### GitHub

The canonical repository for this gem is located at https://github.com/sleepingkingstudios/rspec-sleeping_king_studios.

### A Note From The Developer

Hi, I'm Rob Smith, a Ruby Engineer and the developer of this library. I use these tools every day, but they're not just written for me. If you find this project helpful in your own work, or if you have any questions, suggestions or critiques, please feel free to get in touch! I can be reached on GitHub (see above, and feel encouraged to submit bug reports or merge requests there) or via email at `merlin@sleepingkingstudios.com`. I look forward to hearing from you!

## Configuration

RSpec::SleepingKingStudios now has configuration options available through `RSpec.configuration`. For example, to set the behavior of the matcher examples when a failure message expectation is undefined (see RSpec Matcher Examples, below), put the following in your `spec_helper` or other configuration file:

    RSpec.configure do |config|
      config.sleeping_king_studios do |config|
        config.examples do |config|
          config.handle_missing_failure_message_with = :ignore
        end # config
      end # config
    end # config

### Configuration Options

#### Handle Missing Failure Message With

This option is used with the RSpec matcher examples (see Examples, below), and determines the behavior when a matcher is expected to fail, but the corresponding failure message is not defined (via `let(:failure_message)` or `let(:failure_message_when_negated)`). The default option is `:pending`, which marks the generated example as skipped (and will show up as pending in the formatter). Other options include `:ignore`, which marks the generated example as passing, and `:exception`, which marks the generated example as failing.

## Concerns

RSpec::SleepingKingStudios defines a few concerns that can be included in or extended into modules or example groups for additional functionality.

### Shared Example Groups

    require 'rspec/sleeping_king_studios/concerns/shared_example_group'

    module MyCustomExamples
      extend RSpec::SleepingKingStudios::Concerns::SharedExampleGroup

      shared_examples 'has custom behavior' do
        # Define expectations here...
      end # shared_examples
      alias_shared_examples 'should have custom behavior', 'has custom behavior'
    end # module

Utility functions for defining shared examples. If included in a module, any shared examples defined in that module are scoped to the module, rather than placed in a global scope. This allows you to define different shared examples with the same name in different contexts, similar to the current behavior when defining a shared example inside an example group. To use the defined examples, simply `include` the module in an example group. **Important Note:** Shared examples and aliases must be defined **before** including the module in an example group. Any shared examples or aliases defined afterword will not be available inside the example group.

#### `::alias_shared_examples`

(also `::alias_shared_context`) Aliases a defined shared example group, allowing it to be accessed using a new name. The example group must be defined in the current context using `shared_examples`. The aliases must be defined before including the module into an example group, or they will not be available in the example group.

#### `::shared_examples`

(also `::shared_context`) Defines a shared example group within the context of the current module. Unlike a top-level example group defined using RSpec#shared_examples, these examples are not globally available, and must be mixed into an example group by including the module. The shared examples must be defined before including the module, or they will not be available in the example group.

### Wrap Examples

    require 'rspec/sleeping_king_studios/concerns/wrap_examples'

    RSpec.describe String do
      extend RSpec::SleepingKingStudios::Concerns::WrapExamples

      shared_context 'with a long quote' do
        let(:quote) do
          'Greetings, starfighter! You have been recruited by the Star League'\
          ' to defend the frontier against Xur and the Ko-Dan armada!'
        end # let
      end # shared context

      shared_context 'with a short quote' do`
        let(:quote) { 'Greetings, programs!' }
      end # shared_context

      describe '#length' do
        wrap_context 'with a long quote' do
          it { expect(quote.length).to be == 124 }
        end # wrap_context

        wrap_context 'with a short quote' do
          it { expect(quote.length).to be == 20 }
        end # wrap_context
      end # describe
    end # describe

A simplified syntax for re-using shared context or examples without having to explicitly wrap them in `describe` blocks or allowing memoized values or callbacks to change the containing context. In the example above, if the programmer had used the standard `include_context` instead, the first expectation would have failed, as the value of :quote would have been overwritten.

#### `::wrap_examples`

(also `::wrap_context`) Creates an implicit `describe` block and includes the context or examples within the `describe` block to avoid leaking values or callbacks to the outer context. Any parameters or keywords will be passed along to the `include_examples` call. If a block is given, it is evaluated in the context of the `describe` block after the `include_examples` call, allowing you to define additional examples or customize the values and callbacks defined in the shared examples.

#### `::fwrap_examples`

(also `::fwrap_examples`) A shortcut for wrapping the context or examples in an automatically-focused `describe` block, similar to the built-in `fit` and `fdescribe` methods.

## Custom Matchers

To enable a custom matcher, simply require the associated file. Matchers can be required individually or by category:

    require 'rspec/sleeping_king_studios/all'
    #=> requires all features, including matchers

    require 'rspec/sleeping_king_studios/matchers/core/all'
    #=> requires all of the core matchers

    require 'rspec/sleeping_king_studios/matchers/core/construct'
    #=> requires only the :construct matcher

### ActiveModel

    require 'rspec/sleeping_king_studios/matchers/active_model/all'

These matchers validate ActiveModel functionality, such as validations.

#### `#have_errors` Matcher

    require 'rspec/sleeping_king_studios/matchers/active_model/have_errors'

Verifies that the actual object has validation errors. Optionally can specify individual fields to validate, or even specific messages for each attribute.

**How To Use:**

    expect(instance).to have_errors

    expect(instance).to have_errors.on(:name)

    expect(instance).to have_errors.on(:name).with_message('not to be nil')

**Chaining:**

* **`#on`:** [String, Symbol] Adds a field to validate; the matcher only passes if all validated fields have errors.
* **`#with`:** [Array<String>] Adds one or more messages to the previously-defined field validation. Raises ArgumentError if no field was previously set.
* **`#with_message`:** [String] Adds a message to the previously-defined field validation. Raises ArgumentError if no field was previously set.
* **`#with_messages`:** [Array<String>] Adds one or more messages to the previously-defined field validation. Raises ArgumentError if no field was previously set.

### BuiltIn

    require 'rspec/sleeping_king_studios/matchers/built_in/all'

These extend the built-in RSpec matchers with additional functionality.

#### `#be_kind_of` Matcher

    require 'rspec/sleeping_king_studios/matchers/built_in/be_kind_of'

Now accepts an Array of types. The matcher passes if the actual object is any of the parameter types.

Also allows nil parameter as a shortcut for NilClass.

**How To Use:**

    expect(instance).to be_kind_of [String, Symbol, nil]
    #=> passes iff instance is a String, a Symbol, or is nil

#### `#include` Matcher

    require 'rspec/sleeping_king_studios/matchers/built_in/include'

Now accepts Proc parameters; items in the actual object are passed into proc#call, with a truthy response considered a match to the item. In addition, now accepts an optional block as a shortcut for adding a proc expectation.

**How To Use:**

    expect(instance).to include { |item| item =~ /pattern/ }

#### `#respond_to` Matcher

    require 'rspec/sleeping_king_studios/matchers/built_in/respond_to'

Now has additional chaining functionality to validate the number of arguments accepted by the method, the keyword arguments (if any) accepted by the method, and whether the method accepts a block argument.

**How To Use:**

    # With a block.
    expect(instance).to respond_to(:foo).with_a_block.

    # With a variable number of arguments and a block.
    expect(instance).to respond_to(:foo).with(2..3).arguments.and_a_block

    # With keyword arguments.
    expect(instance).to respond_to(:foo).with(0, :bar, :baz)

**Chaining:**

* **`#with`:** Expects at most one Integer or Range argument, and zero or more Symbol arguments corresponding to optional keywords. Verifies that the method accepts that keyword, or has a variadic keyword of the form `**params`. As of 2.1.0 and required keywords, verifies that all required keywords are provided.
* **`#with_unlimited_arguments`:** (also `and_unlimited_arguments`) No parameters. Verifies that the method accepts any number of arguments via a variadic argument of the form `*args`.
* **`#with_a_block`:** (also `and_a_block`) No parameters. Verifies that the method requires a block argument of the form `&my_argument`. _Important note:_ A negative result _does not_ mean the method cannot accept a block, merely that it does not require one. Also, _does not_ check whether the block is called or yielded.
* **`#with_keywords`:** (also `and_keywords`) Expects one or more String or Symbol arguments. Verifies that the method accepts each provided keyword or has a variadic keyword of the form `**params`. As of 2.1.0 and required keywords, verifies that all required keywords are provided.
* **`#with_arbitrary_keywords`:** (also `and_arbitrary_keywords`) No parameters. Verifies that the method accepts any keyword arguments via a variadic keyword of the form `**params`.

### Core

    require 'rspec/sleeping_king_studios/matchers/core/all'

These matchers check core functionality, such as object boolean-ness, the existence of properties, and so on.

#### `#be_boolean` Matcher

    require 'rspec/sleeping_king_studios/matchers/core/be_boolean'

Checks if the provided object is true or false.

**How To Use:**

    expect(object).to be_boolean

**Parameters:** None.

#### `#construct` Matcher

    require 'rspec/sleeping_king_studios/matchers/core/construct'

Verifies that the actual object can be constructed using `::new`. Can take an optional number of arguments.

**How To Use:**

    # With an expected number of arguments.
    expect(described_class).to construct.with(1).arguments

    # With an expected number of arguments and set of keywords.
    expect(instance).to construct.with(0, :bar, :baz)

**Parameters:** None.

**Chaining:**

* **`#with`:** Expects one Integer, Range, or nil argument, and zero or more Symbol arguments corresponding to optional keywords. Verifies that the class's constructor accepts that keyword, or has a variadic keyword of the form `**params`.  As of Ruby 2.1 and required keywords, verifies that all required keywords are provided.
* **`#with_unlimited_arguments`:** (also `and_unlimited_arguments`) No parameters. Verifies that the class's constructor accepts any number of arguments via a variadic argument of the form `*args`.
* **`#with_keywords`:** (also `and_keywords`) Expects one or more String or Symbol arguments. Verifies that the class's constructor accepts each provided keyword or has a variadic keyword of the form `**params`. As of 2.1.0 and required keywords, verifies that all required keywords are provided.
* **`#with_arbitrary_keywords`:** (also `and_arbitrary_keywords`) No parameters. Verifies that the class's constructor accepts any keyword arguments via a variadic keyword of the form `**params`.

#### `#have_property` Matcher

    require 'rspec/sleeping_king_studios/matchers/core/have_property'

Checks if the actual object responds to `#property` and `#property=`, and optionally if the current value of `actual.property()` is equal to a specified value.

**How To Use:**

    expect(instance).to have_property(:foo).with("foo")

**Parameters:** Property. Expects a string or symbol that is a valid identifier.

**Chaining:**

* **`#with`:** (also `#with_value`) Expects one object, which is checked against the current value of `actual.property()` if actual responds to `#property`. Can also be used with an RSpec matcher:

    expect(instance).to have_property(:bar).with(an_instance_of(String))

#### `#have_reader` Matcher

    require 'rspec/sleeping_king_studios/matchers/core/have_reader'

Checks if the actual object responds to `#property`, and optionally if the current value of `actual.property()` is equal to a specified value.

**How To Use:**

    expect(instance).to have_reader(:foo).with("foo")

**Parameters:** Property. Expects a string or symbol that is a valid identifier.

**Chaining:**

* **`#with`:** (also `#with_value`) Expects one object, which is checked against the current value of `actual.property()` if actual responds to `#property`. Can also be used with an RSpec matcher:

    expect(instance).to have_reader(:bar).with(an_instance_of(String))

#### `#have_writer` Matcher

    require 'rspec/sleeping_king_studios/matchers/core/have_writer'

Checks if the actual object responds to `#property=`.

**How To Use:**

    expect(instance).to have_writer(:foo=)

**Parameters:** Property. Expects a string or symbol that is a valid identifier. An equals sign '=' is automatically added if the identifier does not already terminate in '='.

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

### Property Examples

These examples are shorthand for defining a reader and/or writer expectation.

#### Has Property

    include_examples 'has property', :foo, 42

Delegates to the `#has_reader` and `#has_writer` matchers (see Core/#has\_reader and Core/#has\_writer, above) and passes if the actual object responds to the specified property and property writer methods. If a value is specified, the object must respond to the property and return the specified value. Alternatively, you can set a proc as the expected value, which can contain a comparison, an RSpec expectation, or a more complex expression:

    include_examples 'has property', :bar, ->() { an_instance_of(String) }

    include_examples 'has property', :baz, ->(value) { value.count = 3 }

#### Has Reader

    include_examples 'has reader', :foo, 42

Delegates to the `#has_reader` matcher (see Core/#has_reader, above) and passes if the actual object responds to the specified property. If a value is specified, the object must respond to the property and return the specified value. Alternatively, you can set a proc as the expected value, which can contain a comparison, an RSpec expectation, or a more complex expression:

    include_examples 'has reader', :bar, ->() { an_instance_of(String) }

    include_examples 'has reader', :baz, ->(value) { value.count = 3 }

#### Has Writer

    include_examples 'has writer', :foo=

Delegates to the `#has_writer` matcher (see Core/#has_writer, above) and passes if the actual object responds to the specified property writer.

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

See Fails With A Positive Expectation, above, for behavior when the example group does not define `#failure_message_when_negated`.

## License

RSpec::SleepingKingStudios is released under the [MIT License](http://www.opensource.org/licenses/MIT).
