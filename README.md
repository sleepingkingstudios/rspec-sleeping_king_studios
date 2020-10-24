# RSpec::SleepingKingStudios [![Build Status](https://travis-ci.org/sleepingkingstudios/rspec-sleeping_king_studios.svg?branch=master)](https://travis-ci.org/sleepingkingstudios/rspec-sleeping_king_studios)

A collection of matchers and extensions to ease TDD/BDD using RSpec. Extends built-in matchers with new functionality, such as support for Ruby 2.0+ keyword arguments, and adds new matchers for testing boolean-ness, object reader/writer properties, object constructor arguments, ActiveModel validations, and more. Also defines shared example groups for more expressive testing.

## Support

RSpec::SleepingKingStudios is tested against RSpec 3.3 through 3.7.

Currently, the following versions of Ruby are officially supported:

* 2.4
* 2.5
* 2.6

For Ruby 2.0 support, use version 2.1 or earlier: `gem "rspec-sleeping_king_studios", "~> 2.1.1"`.

For RSpec 3.0 to 3.2 support, use version 2.2 or earlier: `gem "rspec-sleeping_king_studios", "~> 2.2.2"`.

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
        # RSpec::SleepingKingStudios configuration can be set here.
      end # config
    end # config

### Configuration Options

#### Examples

##### Handle Missing Failure Message With

    RSpec.configure do |config|
      config.sleeping_king_studios do |config|
        config.examples do |config|
          config.handle_missing_failure_message_with = :ignore
        end # config
      end # config
    end # config

This option is used with the RSpec matcher examples (see Examples, below), and determines the behavior when a matcher is expected to fail, but the corresponding failure message is not defined (via `let(:failure_message)` or `let(:failure_message_when_negated)`). The default option is `:pending`, which marks the generated example as skipped (and will show up as pending in the formatter). Other options include `:ignore`, which marks the generated example as passing, and `:exception`, which marks the generated example as failing.

##### Match String Failure Message As

    RSpec.configure do |config|
      config.sleeping_king_studios do |config|
        config.examples do |config|
          config.match_string_failure_message_as = :exact
        end # config
      end # config
    end # config

This option is used with the RSpec matcher examples (see Examples, below), and determines whether an expected failure message is matched against the actual failure message as an exact match or as a substring. The default option is `:substring`, which means that any failure message that contains the expected message as a substring will match. Alternatively, setting the option to `:exact` will mean that only a failure message that is an exact match for the expected message will match.

#### Matchers

##### Allow Empty Include Matchers

    RSpec.configure do |config|
      config.sleeping_king_studios do |config|
        config.matchers do |config|
          config.allow_empty_include_matchers = false
        end # config
      end # config
    end # config

This option is used with the IncludeMatcher (see `#include`, below). If this option is set to false, an ArgumentError will be raised when attempting to instantiate an IncludeMatcher without any expectations.

This prevents an insidious bug when using the `do..end` block syntax to create a block expectation while the matcher macro is itself an argument to another function, such as ExpectationTarget#to. This bug causes the block to be silently ignored and any enumerable object to match against the matcher, even an empty object.

##### Strict Predicate Matching

    RSpec.configure do |config|
      config.sleeping_king_studios do |config|
        config.matchers do |config|
          config.strict_predicate_matching = true
        end # config
      end # config
    end # config

This option is used with the HavePredicateMatcher (see `#have_predicate`, below). If set to true, ensures that any method that is expected to be a predicate will return either true or false. The matcher will fail if the method returns any other value. The default value is false, which allows for loose matching of predicate methods.

## Concerns

RSpec::SleepingKingStudios defines a few concerns that can be included in or extended into modules or example groups for additional functionality.

### Example Constants

    require 'rspec/sleeping_king_studios/concerns/example_constants'

    RSpec.describe 'constants' do
      extend RSpec::SleepingKingStudios::Concerns::ExampleConstants

      example_constant 'THE_ANSWER', 42

      example_class 'Spec::Examples::Question' do |klass|
        value = help_string

        klass.send(:define_method, :answer) { THE_ANSWER }
        klass.send(:define_method, :help)   { value }
      end # example_class

      let(:described_class) { Spec::Examples::Question }
      let(:instance)        { described_class.new }
      let(:help_string) do
        "It looks like you're defining a class. Would you like help?"
      end # let

      it { expect(described_class.name).to be == 'Spec::Examples::Question' }

      it { expect(instance.answer).to be THE_ANSWER }

      it { expect(instance.help).to be == help_string }
    end # describe

Provides a programmatic way to define temporary constants and classes scoped to the current example.

#### `::example_constant`

`param constant_name [String, Symbol]` The name of the constant. Can be a qualified name separated by :: (e.g. `'Spec::Examples::Question'`), in which case any missing modules will be temporarily set as well.

`param constant_value` Defaults to nil. If the constant value is not set and a block is given, the block will be executed in the context of the example (so previously-set constants will be available, as well as example features such as the values of `let` blocks) and the value of the constant will be set to the result of the block call.

`option force [Boolean]` Defaults to false. If the constant is already defined, trying to set the constant value will raise an error unless the force option is set to true.

Sets the value of the named constant to the specified value within the context of the current example.

#### `::example_class`

`param constant_name [String, Symbol]` The name of the constant. Can be a qualified name separated by :: (e.g. `'Spec::Examples::Question'`), in which case any missing modules will be temporarily set as well.

`option base_class [Class]` Defaults to Object. The base class of the generated class.

`yield klass [Class]` If a block is given, it is executed in the context of the example (so previously-set constants will be available, as well as example features such as the values of `let` blocks) and yielded the class.

Creates a new class with the specified base class and sets the value of the named constant to the created class within the context of the current example.

### Focus Examples

    require 'rspec/sleeping_king_studios/concerns/focus_examples'

    RSpec.describe String do
      extend RSpec::SleepingKingStudios::Concerns::FocusExamples

      shared_examples 'should be a greeting' do
        it { expect(salutation).to be =~ /greeting/i }
      end # shared_examples

      shared_examples 'should greet the user by name' do
        it { expect(salutation).to match user.name }
      end # shared_examples

      let(:salutation) { 'Greetings, programs!' }

      # Focused example groups are always run when config.filter_run :focus is
      # set to true.
      finclude_examples 'should be a greeting'

      # Skipped example groups are marked as pending and never run.
      xinclude_examples 'should greet the user by name'
    end # describe

A shorthand for focusing or skipping included shared example groups with a single keystroke, e.g. `include_examples '...'` => `finclude_examples '...'`.

A simplified syntax for re-using shared context or examples without having to explicitly wrap them in `describe` blocks or allowing memoized values or callbacks to change the containing context. In the example above, if the programmer had used the standard `include_context` instead, the first expectation would have failed, as the value of :quote would have been overwritten.

*Important Note:* Do not use these methods with example groups that have side effects, e.g. that define a memoized `#let` helper or a `#before` block that is intended to modify the behavior of sibling examples. Wrapping the example group in a `describe` block breaks that relationship. Best practice is to use the `#wrap_examples` method to safely encapsulate example groups with side effects, and the `#fwrap_examples` method to automatically focus such groups.

#### `::finclude_examples`

(also `::finclude_context`) A shortcut for focusing the example group by wrapping it in a `describe` block, similar to the built-in `fit` and `fdescribe` methods.

#### `::xinclude_examples`

(also `::xinclude_context`) A shortcut for skipping the example group by wrapping it in a `describe` block, similar to the built-in `xit` and `xdescribe` methods.

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

### Toolbelt

    require 'rspec/sleeping_king_studios/concerns/toolbelt'

    RSpec.describe "a String" do
      include RSpec::SleepingKingStudios::Concerns::Toolbelt

      shared_examples 'should process' do |string|
        singular = tools.string.singularize(string)
        plural   = tools.string.pluralize(string)

        it "should singularize #{string} to #{singular}" do
          expect(tools.singularize string).to be_a String
        end # it

        it "should pluralize #{string} to #{plural}" do
          expect(tools.pluralize string).to be_a String
        end # it
      end # shared_examples

      include_examples 'should pluralize', 'light'
    end # describe

A helper module for exposing SleepingKingStudios::Tools methods in examples and example groups.

### Wrap Environment

    require 'rspec/sleeping_king_studios/concerns/wrap_env'

    RSpec.describe 'environment' do
      include RSpec::SleepingKingStudios::Concerns::WrapEnv

      it { expect(ENV['VAR_NAME']).to be nil }

      context 'when the variable is set in the example group' do
        wrap_env 'VAR_NAME', 'custom_value'

        it { expect(ENV['VAR_NAME']).to be == 'custom_value' }
      end # context

      context 'when the variable is set in the example group with a block' do
        let(:calculated_value) { 'calculated_value' }

        wrap_env('VAR_NAME') { calculated_value }

        it { expect(ENV['VAR_NAME']).to be == calculated_value }
      end # context

      context 'when the variable is set inside an example' do
        it 'should set the variable' do
          expect(ENV['VAR_NAME']).to be nil

          begin
            wrap_env('VAR_NAME', 'new_value') do
              expect(ENV['VAR_NAME']).to be == 'new_value'

              raise RuntimeError, 'must handle errors and reset the var'
            end # wrap_env
          rescue RuntimeError
          end # begin-rescue

          expect(ENV['VAR_NAME']).to be nil
        end # it
      end # context
    end # describe

Provides helper methods for temporarily overwriting values in the environment, which are safely and automatically reset after the example or block.

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

(also `::fwrap_context`) A shortcut for wrapping the context or examples in an automatically-focused `describe` block, similar to the built-in `fit` and `fdescribe` methods.

#### `::xwrap_examples`

(also `::xwrap_context`) A shortcut for wrapping the context or examples in an automatically-skipped `describe` block, similar to the built-in `xit` and `xdescribe` methods.

## Contracts

```ruby
require 'rspec/sleepingkingstudios/contract'
```

A Contract encapsulates a set of RSpec expectations, which can then be used when defining a spec.

```ruby
module GreetContract
  extend RSpec::SleepingKingStudios::Contract

  describe '#greet' do
    it { expect(subject).to respond_to(:greet).with(1).argument }

    it { expect(subject.greet 'programs').to be == 'Greetings, programs!' }
  end
end

RSpec.describe Greeter do
  include GreetContract
end
```

Using a contract allows for examples to be shared between different specs, or even between projects.

### Contract Methods

Not all RSpec methods are defined in a Contract. Only methods that define an example (`it`) or an example group (`context` or `describe`) can be used at the top level of a Contract. However, all RSpec methods (including methods that modify the current scope, such as `let` and the `before`/`around`/`after` filters) can be used inside an example group as normal.

#### `::context`

Defines an example group inside the contract. This example group will be defined on all specs that include the contract.

```ruby
module TransformationContract
  extend RSpec::SleepingKingStudios::Contract

  context 'when the moon is full' do
    let(:moon_phase) { :full }

    it { expect(werewolf).to be_transformed }
  end
end
```

#### `::describe`

Defines an example group inside the contract. This example group will be defined on all specs that include the contract.

```ruby
module SilverContract
  extend RSpec::SleepingKingStudios::Contract

  describe 'with a silver weapon' do
    before(:example) do
      weapon.material = 'silver'
    end

    it 'should kill the werewolf' do
      expect(attack(werewolf, weapon)).to change(werewolf, :alive?).to be false
    end
  end
end
```

#### `::it`

Defines an example inside the contract.

```ruby
module HowlingContract
  extend RSpec::SleepingKingStudios::Contract

  it { expect(werewolf).to respond_to(:howl) }
end
```

#### `::shared_context`

Defines a shared example group.

```ruby
module MoonContract
  extend RSpec::SleepingKingStudios::Contract

  shared_context 'when the moon is full' do
    before(:example) { moon.phase = :full }
  end
end
```

**Note:** When the `Contract` is included in an RSpec example group, any shared example groups defined at the top level of a contract are also included in that example group, even outside of the contract itself. This may cause namespace collisions with shared example groups defined elsewhere in the example group or by other included contracts.

#### `::shared_examples`

Defines a shared example group.

```ruby
module HairContract
  extend RSpec::SleepingKingStudios::Contract

  shared_examples 'should be hairy' do
    describe '#hairy?' do
      it { expect(werewolf.hairy?).to be true }
    end
  end
end
```

**Note:** When the `Contract` is included in an RSpec example group, any shared example groups defined at the top level of a contract are also included in that example group, even outside of the contract itself. This may cause namespace collisions with shared example groups defined elsewhere in the example group or by other included contracts.

### Developing Contracts

```ruby
module VampireContract
  extend RSpec::SleepingKingStudios::Contract
  extend RSpec::SleepingKingStudios::Contracts::Development

  fdescribe '#drink' do
    it { expect(drink 'blood').to be true }

    xit { expect(drink 'holy water').to be false }
  end

  pending
end
```

The `RSpec::SleepingKingStudios::Contracts::Development` module provides methods for defining focused or pending examples and example groups. These are intended for use when developing a contract, and should not be included in the final version. Having skipped or focused example groups in a shared contract can have unexpected effects when the contract is included by the end user.

#### `::fcontext`

Defines a focused example group inside the contract.

#### `::fdescribe`

Defines a focused example group inside the contract.

#### `::fit`

Defines a focused example inside the contract.

#### `::pending`

Marks the contract as pending.

#### `::xcontext`

Defines a skipped example group inside the contract.

#### `::xdescribe`

Defines a skipped example group inside the contract.

#### `::xit`

Defines a skipped example inside the contract.

## Matchers

To enable a custom matcher, simply require the associated file. Matchers can be required individually or by category:

    require 'rspec/sleeping_king_studios/all'
    #=> requires all features, including matchers

    require 'rspec/sleeping_king_studios/matchers/core/all'
    #=> requires all of the core matchers

    require 'rspec/sleeping_king_studios/matchers/core/construct'
    #=> requires only the :construct matcher

As of version 2.2, you can also load only the matcher, without adding the associated macro to your example groups. This can be useful in case of naming conflicts with other libraries, or if you need only the matcher in isolation.

    require 'rspec/sleeping_king_studios/matchers/core/be_boolean_matcher'
    #=> requires the matcher itself as RSpec::SleepingKingStudios::Matchers::Core::BeBooleanMatcher,
    #   but does not add a #be_boolean macro to example groups.

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
    expect(instance).to respond_to(:foo).with_keywords(:bar, :baz)

    # With both arguments and keywords.
    expect(instance).to respond_to(:foo).with(2).arguments.and_keywords(:bar, :baz)

**Chaining:**

* **`#with`:** Expects at most one Integer or Range argument, and zero or more Symbol arguments corresponding to optional keywords. Verifies that the method accepts that keyword, or has a variadic keyword of the form `**kwargs`. As of 2.1.0 and required keywords, verifies that all required keywords are provided.
* **`#with_unlimited_arguments`:** (also `and_unlimited_arguments`) No parameters. Verifies that the method accepts any number of arguments via a variadic argument of the form `*args`.
* **`#with_a_block`:** (also `and_a_block`) No parameters. Verifies that the method requires a block argument of the form `&my_argument`. _Important note:_ A negative result _does not_ mean the method cannot accept a block, merely that it does not require one. Also, _does not_ check whether the block is called or yielded.
* **`#with_keywords`:** (also `and_keywords`) Expects one or more String or Symbol arguments. Verifies that the method accepts each provided keyword or has a variadic keyword of the form `**kwargs`. As of 2.1.0 and required keywords, verifies that all required keywords are provided.
* **`#with_any_keywords`:** (also `and_any_keywords`, `and_arbitrary_keywords`, `and_arbitrary_keywords`) No parameters. Verifies that the method accepts any keyword arguments via a variadic keyword of the form `**kwargs`.

### Core

    require 'rspec/sleeping_king_studios/matchers/core/all'

These matchers check core functionality, such as object boolean-ness, the existence of properties, and so on.

#### `#alias_method` Matcher

    require 'rspec/sleeping_king_studios/matchers/core/alias_method'

Checks if the object aliases the specified method with the specified other name. Matches if and only if the object responds to both the old and new method names, and if the old method and the new method are the same method.

**How To Use**:

    expect(object).to alias_method(:old_method).as(:new_method)

**Parameters:** Old method name. Expects the name of the method which has been aliased as a String or Symbol.

**Chaining:**

* **`#as`:** Required. Expects one String or Symbol, which is the name of the generated method.

#### `#be_a_uuid` Matcher

    require 'rspec/sleeping_king_studios/matchers/core/be_a_uuid'

**Aliases:** `#a_uuid`.

**How To Use:**

    # With an object comparison.
    expect(string).to be_a_uuid

    # Inside a composable matcher.
    expect(array).to include(a_uuid)

**Parameters:** None.

#### `#be_boolean` Matcher

    require 'rspec/sleeping_king_studios/matchers/core/be_boolean'

Checks if the provided object is true or false.

**Aliases:** `#a_boolean`.

**How To Use:**

    # With an object comparison.
    expect(object).to be_boolean

    # Inside a composable matcher.
    expect(array).to include(a_boolean)

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

#### `#deep_match` Matcher

    require 'rspec/sleeping_king_studios/matchers/core/deep_match'

Performs a recursive comparison between two object or data structures. Also supports using RSpec matchers as values in the expected object.

**How To Use:**

    expected = {
      status: 200,
      body: {
        order: {
          id:    an_instance_of(Integer),
          total: '9.99'
        }
      }
    }
    expect(response).to deep_match(expected)

When the value does not match the expectation, the failure message will provide a detailed diff showing added, missing, and changed values.

    response = {
      status: 400,
      body: {
        order: {
          fulfilled: false,
          total:     '19.99'
        }
      },
      errors: ['Insufficient funds']
    }
    expect(response).to deep_match(expected)
    # Failure/Error: expect(response).to deep_match(expected)
    #
    #   expected: == {:body=>{:order=>{:id=>an instance of Integer, :total=>"9.99"}}, :status=>200}
    #        got:    {:status=>400, :body=>{:order=>{:fulfilled=>false, :total=>"19.99"}}, :errors=>["Insufficient funds"]}
    #
    #   (compared using HashDiff)
    #
    #   Diff:
    #   + :body.:order.:fulfilled => got false
    #   - :body.:order.:id => expected an instance of Integer
    #   ~ :body.:order.:total => expected "9.99", got "19.99"
    #   + :errors => got ["Insufficient funds"]
    #   ~ :status => expected 200, got 400

#### `#delegate_method` Matcher

    require 'rspec/sleeping_king_studios/matchers/core/delegate_method'

Checks if the actual object forwards the specified method to the specified target. Can also specify that arguments, keywords, and/or a block are passed to the target, and that the object returns the specified values.

**How To Use:**

    expect(object).to delegate_method(:my_method).to(target)

    # Specify that arguments must be passed to the target.
    expect(object).to delegate_method(:my_method).to(target).with_arguments(:ichi, :ni, :san)
    expect(object).to delegate_method(:my_method).to(target).with_keywords(:foo => 'foo', :bar => 'bar')
    expect(object).to delegate_method(:my_method).to(target).with_a_block

    # Specify that the method must return the specified value.
    expect(object).to delegate_method(:my_method).to(target).and_return(true)    # Called 1 time.
    expect(object).to delegate_method(:my_method).to(target).and_return(0, 1, 2) # Called 3 times.

**Parameters:** Method name. Expects a string or symbol that is a valid identifier.

**Chaining:**

* **`#to`:** Required. Expects an object, which is the target the method should be forwarded to.
* **`#with_arguments`:** (also `and_arguments`) Expects one or more arguments. Specifies that when the method is called on the actual object with the given arguments, those arguments are then passed on to the target object when the method is called on the target.
* **`#with_keywords:`** (also `and_keywords`) Expects a hash of keywords and values. Specifies that when the method is called on the actual object with the given keywords, those keywords are then passed on to the target object when the method is called on the target.
* **`#with_a_block:`** (also `and_a_block`) Specifies that when the method is called on the actual object a block argument, thhe block is then passed on to the target object when the method is called on the target.
* **`#and_return`:** Expects one or more arguments. The method is called on the actual object one time for each value passed into `#and_return`. Specifies that the return value of calling the method on the actual object is the corresponding value passed into `#and_return`.

#### `#have_changed` Matcher

    require 'rspec/sleeping_king_studios/matchers/core/have_changed'

Checks that a watched value has changed. The `have_changed` matcher must be paired with a value spy (see `#watch_value`, below), which is typically created with the `watch_value` helper. This is an alternative to the core RSpec `change` matcher, but allows you track changes to multiple values without nested expectations or other workarounds.

**How To Use**

    spy = watch_value(object, property)

    object.property = 'new value'

    expect(spy).to have_changed

You can also create a value spy with a block:

    spy = watch_value { object.property }

**Parameters:** None.

**Chaining:**

* **by:** Expects one argument. If the value has changed, then the current value will be subtracted from the initial value and the difference compared with the expected value given to `#by`. *Note:* `not_to have_changed.by()` is not supported and will raise an error.
* **from:** Expects one argument. The initial value of the spy (at the time the spy was initialized) must be equal to the given value.
* **to:** Expects one argument. The current value of the spy (at the time `expect().to have_changed` is evaluated) must be equal to the given value.

**Warning:** Make sure that the value spy is initialized before running whatever code is expected to change the value. In particular, if you are setting up your spies using RSpec `let()` statements, it is recommended to use the imperative `let!()` form to ensure that the spies are initialized before running the example.

#### `#have_constant` Matcher

    require 'rspec/sleeping_king_studios/matchers/core/have_constant'

Checks for the presence of a defined constant `:CONSTANT_NAME` and optionally the value of the constant. Can also check that the value is immutable, e.g. for an additional layer of protection over important constants.

**How To Use:**

    expect(instance).to have_constant(:FOO)

    expect(instance).to have_constant(:BAR).with_value('Bar')

    expect(instance).to have_immutable_constant(:BAZ).with_value('Baz')

**Parameters:** Constant name. Expects a string or symbol that is a valid identifier.

**Chaining:**

* **`#immutable`:** Sets a mutability expectation, which passes if the value of the constant is immutable. Values of `nil`, `false`, `true` are always immutable, as are `Numeric` and `Symbol` primitives. `Array` values must be frozen and all array items must be immutable. `Hash` values must be frozen and all hash keys and values must be immutable. All other objects must be frozen.

* **`#with`:** (also `#with_value`) Expects `true` or `false`, which is checked against the current value of `actual.property?()` if actual responds to `#property?`.

#### `#have_predicate` Matcher

    require 'rspec/sleeping_king_studios/matchers/core/have_predicate'

Checks if the actual object responds to `#property?`, and optionally if the current value of `actual.property?()` is equal to a specified value. If `config.sleeping_king_studios.matchers.strict_predicate_matching` is set to true, will also validate that the `#property?` returns either `true` or `false`.

**How To Use:**

  expect(instance).to have_predicate(:foo?).with(true)

**Parameters:** Property. Expects a string or symbol that is a valid identifier.

**Chaining:**

* **`#with`:** (also `#with_value`) Expects `true` or `false`, which is checked against the current value of `actual.property?()` if actual responds to `#property?`.

#### `#have_property` Matcher

    require 'rspec/sleeping_king_studios/matchers/core/have_property'

Checks if the actual object responds to `#property` and `#property=`, and optionally if the current value of `actual.property()` is equal to a specified value.

**How To Use:**

    expect(instance).to have_property(:foo).with("foo")

    expect(instance).to have_property(:foo, :allow_private => true).with("foo")

**Parameters:**

`param property [String, Symbol]` The name of the property.

`option allow_private [Boolean]` Defaults to false. If true, the matcher will also match a private or protected reader or writer method.

**Chaining:**

* **`#with`:** (also `#with_value`) Expects one object, which is checked against the current value of `actual.property()` if actual responds to `#property`. Can also be used with an RSpec matcher:

    expect(instance).to have_property(:bar).with(an_instance_of(String))

#### `#have_reader` Matcher

    require 'rspec/sleeping_king_studios/matchers/core/have_reader'

Checks if the actual object responds to `#property` with 0 arguments, and optionally if the current value of `actual.property()` is equal to a specified value.

**How To Use:**

    expect(instance).to have_reader(:foo).with("foo")

    expect(instance).to have_reader(:foo, :allow_private => true).with("foo")

**Parameters:**

`param property [String, Symbol]` The name of the reader method.

`option allow_private [Boolean]` Defaults to false. If true, the matcher will also match a private or protected method.

**Chaining:**

* **`#with`:** (also `#with_value`) Expects one object, which is checked against the current value of `actual.property()` if actual responds to `#property`. Can also be used with an RSpec matcher: `expect(instance).to have_reader(:bar).with(an_instance_of(String))`

#### `#have_writer` Matcher

    require 'rspec/sleeping_king_studios/matchers/core/have_writer'

Checks if the actual object responds to `#property=`.

**How To Use:**

    expect(instance).to have_writer(:foo=)

    expect(instance).to have_writer(:foo=, :allow_private => true)

**Parameters:**

`param property [String, Symbol]` The name of the writer method. An equals sign '=' is automatically added if the identifier does not already terminate in '='.

`option allow_private [Boolean]` Defaults to false. If true, the matcher will also match a private or protected method.

#### `#watch_value` Helper

    require 'rspec/sleeping_king_studios/matchers/core/have_changed'

Creates a value spy that watches the value of a method call or block. The spy also caches the initial value at the time the spy was created; this allows comparisons between the initial and current values. Value spies are used with the `#have_changed` matcher (see above).

**How To Use:**

    spy = watch_value(object, property)

    spy = watch_value { object.property }

**Parameters:**

`param object [Object]` The object to watch. Ignored if given a block.

`param method_name [String, Symbol]` The name of the method to watch. Ignored if given a block.

**Chaining:** None.

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

These examples are shorthand for defining a property expectation.

    require 'rspec/sleeping_king_studios/examples/property_examples'

    RSpec.describe MyClass do
      include RSpec::SleepingKingStudios::Examples::PropertyExamples

      # You can use the custom shared examples here.
    end # describe

#### Should Have Class Property

    include_examples 'should have class property', :foo, 42

Delegates to the `#have_property` matcher (see Core/#have\_property, above) and passes if `described_class` responds to the specified reader and writer methods. If a value is specified, the described class must respond to the property and return the specified value. Alternatively, you can set a proc as the expected value, which can contain a comparison, an RSpec expectation, or a more complex expression:

    include_examples 'should have class property', :bar, ->() { an_instance_of(String) }

    include_examples 'should have class property', :baz, ->(value) { value.count = 3 }

#### Should Have Class Reader

    include_examples 'should have class reader', :foo, 42

Delegates to the `#have_reader` matcher (see Core/#have_reader, above) and passes if `described_class` responds to the specified property reader. If a value is specified, the described class must respond to the property and return the specified value. Alternatively, you can set a proc as the expected value, which can contain a comparison, an RSpec expectation, or a more complex expression:

    include_examples 'should have class reader', :bar, ->() { an_instance_of(String) }

    include_examples 'should have class reader', :baz, ->(value) { value.count = 3 }

#### Should Have Class Writer

    include_examples 'should have class writer', :foo=

Delegates to the `#have_writer` matcher (see Core/#have_writer, above) and passes if `described_class` responds to the specified property writer.

#### Should Have Constant

    include_examples 'should have constant', :FOO, 42

Delegates to the `#have_constant` matcher (see Core/#have_constant, above) and passes if the described class defines the specified constant. If a value is specified, the class or module must define the constant with the specified value. Alternatively, you can set a proc as the expected value, which can contain a comparison, an RSpec expectation, or a more complex expression:

    include_examples 'should have constant', :BAR, ->() { an_instance_of(String) }

    include_examples 'should have constant', :BAZ, ->(value) { value.count = 3 }

#### Should Have Immutable Constant

    include_examples 'should have immutable constant', :FOO, 42

As the 'should have constant' example, but sets a mutability expectation on the constant. See Core/#have_constant for specifics on which objects are considered mutable.

#### Should Have Predicate

    include_examples 'should have predicate', :foo, true

    include_examples 'should have predicate', :foo?, true

Delegates to the `#have_predicate` matcher (see Core/#have_predicate, above) and passes if the actual object responds to the specified predicate. If a value is specified, the object must respond to the predicate and return the specified value, which must be true or false. Alternatively, you can set a proc as the expected value, which can contain a comparison, an RSpec expectation, or a more complex expression:

    include_examples 'should have predicate', :bar, ->() { a_boolean }

    include_examples 'should have predicate', :baz, ->(value) { value == true }

#### Should Have Property

    include_examples 'should have property', :foo, 42

Delegates to the `#have_property` matcher (see Core/#have\_property, above) and passes if the actual object responds to the specified reader and writer methods. If a value is specified, the object must respond to the property and return the specified value. Alternatively, you can set a proc as the expected value, which can contain a comparison, an RSpec expectation, or a more complex expression:

    include_examples 'should have property', :bar, ->() { an_instance_of(String) }

    include_examples 'should have property', :baz, ->(value) { value.count = 3 }

You can also set the :allow_private option to allow the examples to match a private reader and/or writer method:

    include_examples 'should have property', :foo, :allow_private => true

    include_examples 'should have property', :foo, 42, :allow_private => true

#### Should Have Private Property

    include_examples 'should have private property', :foo

    include_examples 'should have private property', :foo, 42

Passes if the actual object has the specified private or protected property reader and writer, and fails if the actual object does not have the specified reader and writer or if the specified reader or writer is a public method. If a value is specified, the value of the private reader must match the specified value.

#### Should Have Reader

    include_examples 'should have reader', :foo, 42

Delegates to the `#have_reader` matcher (see Core/#have_reader, above) and passes if the actual object responds to the specified property reader. If a value is specified, the object must respond to the property and return the specified value. Alternatively, you can set a proc as the expected value, which can contain a comparison, an RSpec expectation, or a more complex expression:

    include_examples 'should have reader', :bar, ->() { an_instance_of(String) }

    include_examples 'should have reader', :baz, ->(value) { value.count = 3 }

You can also set the :allow_private option to allow the examples to match a private reader method:

    include_examples 'should have reader', :foo, :allow_private => true

    include_examples 'should have reader', :foo, 42, :allow_private => true

#### Should Not Have Reader

    include_examples 'should not have reader', :foo

Delegates to the `#have_reader` matcher (see Core/#have_reader, above) and passes if the actual object does not respond to to the specified property reader.

#### Should Have Private Reader

    include_examples 'should have private reader', :foo

    include_examples 'should have private reader', :foo, 42

Passes if the actual object has the specified private or protected property reader, and fails if the actual object does not have the specified reader or if the specified reader is a public method. If a value is specified, the value of the private reader must match the specified value.

#### Should Have Writer

    include_examples 'should have writer', :foo=

Delegates to the `#have_writer` matcher (see Core/#have_writer, above) and passes if the actual object responds to the specified property writer.

You can also set the :allow_private option to allow the examples to match a private writer method:

    include_examples 'should have writer', :foo=, :allow_private => true

#### Should Not Have Writer

    include_examples 'should not have writer', :foo=

Delegates to the `#have_writer` matcher (see Core/#have_writer, above) and passes if the actual object does not respond to to the specified property writer.

#### Should Have Private Writer

    include_examples 'should have private writer', :foo=

Passes if the actual object has the specified private or protected property writer, and fails if the actual object does not have the specified writer or if the specified writer is a public method.

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
