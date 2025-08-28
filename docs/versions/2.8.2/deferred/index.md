---
breadcrumbs:
  - name: Documentation
    path: '../../../'
  - name: Versions
    path: '../../'
  - name: '2.8.2'
    path: '../'
---

# Deferred Examples

Deferred example groups define a mechanism for reusing and sharing RSpec context and examples, even between libraries or projects.

## Contents

- [Why Deferred Examples](#why-deferred-examples)
- [Defining Examples](#defining-examples)
- [Including Examples](#including-examples)
- [Parameterized Examples](#parameterized-examples)
- [Methods And Inheritance](#methods-and-inheritance)
- [Dependent Methods](#dependent-methods)
- [Configuration](#configuration)
- [Reflection](#reflection)

## Why Deferred Examples

RSpec already defines a way to reuse specs and context between example groups, `shared_examples`. Why then use a solution from a library? Three reasons.

1. *Scope*. RSpec shared examples are either defined within a single example group, or globally. Deferred examples are scoped to a module, giving you more control over where they are used. You can define and publish deferred examples without worrying about a namespace collision elsewhere.
2. *Inheritance*. Each deferred example group defines a module, meaning that you can `include_deferred` multiple contexts that modify the same `let` value and use `super()` to chain the results.
3. *Tooling*. Deferred example groups provide tooling for [declaring dependent methods](#dependent-methods) and [reflecting on the example stack](#reflection).

## Defining Examples

The recommended way to define a deferred example group is by including the `Deferred::Provider` module and calling the `deferred_examples` or `deferred_context` methods.

```ruby
module RocketryExamples
  include RSpec::SleepingKingStudios::Deferred::Provider

  deferred_context 'with an unlaunched rocket' do
    let(:rocket) { Rocket.new(name: 'Charon III', launched: false) }
  end

  deferred_examples 'should launch the rocket' do
    describe '#launch' do
      it { expect { rocket.launch }.to change(rocket, :launched?).to be true }
    end
  end
end
```

As you can see, inside a deferred example group you can use the familiar RSpec DSL to define examples, example groups, memoized helpers, and `before`/`after`/`around` hooks.

A deferred example group can also be defined as a module by including `Deferred::Examples`.

```ruby
module RocketryExamples
  include RSpec::SleepingKingStudios::Deferred::Provider

  module ShouldHaveFuelExamples
    include RSpec::SleepingKingStudios::Deferred::Examples

    it { expect(rocket.fuel).to be > 0 }
  end
end
```

## Including Examples

Once you have defined a deferred example group, you can import it into an RSpec example group by including `Deferred::Consumer` and the module defining the deferred examples, then calling `include_deferred` and the description for the example group.

```ruby
RSpec.describe Rocket do
  include RSpec::SleepingKingStudios::Deferred::Consumer
  include RocketryExamples

  context 'when the rocket has not been launched' do
    include_deferred 'with an unlaunched rocket'

    include_deferred 'should launch the rocket'
  end

  context 'when the rocket has fuel' do
    let(:rocket) { Rocket.new(name: 'Charon III', fuel: 1_000) }

    include_deferred 'should have fuel'
  end
end
```

When the deferred example group is included, it applies all of the deferred RSpec DSL methods to the current example group. Examples, child example groups, hooks, and memoized helpers can all be applied from a deferred example group. In addition, because each deferred example group is itself a module, you can define instance or class methods, modules, and classes inside deferred examples and have them available to the examples.

RSpec::SleepingKingStudios also defines helpers for wrapping the deferred examples in a context, and for temporarily marking them as focused or pending.

```ruby
RSpec.describe Rocket do
  # Wraps the deferred examples in a describe block with focus: true.
  finclude_deferred 'should aim the pointy end at space'

  # Wraps the deferred examples in a describe block with skip: true.
  xinclude_deferred 'should check the engine light'

  # Wraps the deferred examples in a describe block with the same description.
  #
  # You can also focus the context with fwrap_deferred, or skip the context with
  # xwrap_deferred.
  wrap_deferred 'when the rocket has a crew' do
    it { expect(rocket.crew.empty?).to be false }
  end
end
```

You can even include deferred examples provided by libraries or other projects into your tests. This allows you to define an interface and test it independently for each implementation.

```ruby
require 'rocketry/deferred_examples'

RSpec.describe Rocket do
  include RSpec::SleepingKingStudios::Deferred::Consumer
  include Rocketry::DeferredExamples

  include_deferred 'should be a chemical rocket'

  include_deferred 'should have enough delta-V to reach orbit'
end
```

**Note:** Unlike core RSpec shared examples, there is no global context - only the deferred examples you explicitly include are available in your test.

## Parameterized Examples

Deferred example groups can also be defined with parameters, which can be used to configure the contents. This allows a deferred example group to be reused in different contexts.

```ruby
module VehicleExamples
  include RSpec::SleepingKingStudios::Deferred::Provider

  deferred_examples 'should be a vehicle' do |**example_options|
    it { expect(subject).to be_a Vehicle }

    it { expect(subject.type).to eq example_options[:type] }
  end
end

RSpec.describe Boat do
  include RSpec::SleepingKingStudios::Deferred::Consumer
  include VehicleExamples

  include_deferred 'should be a vehicle', type: 'boat'
end

RSpec.describe Rocket do
  include RSpec::SleepingKingStudios::Deferred::Consumer
  include VehicleExamples

  include_deferred 'should be a vehicle', type: 'spaceship'
end
```

In the above examples, we are configuring the `"should be a vehicle"` deferred examples with an expected type parameter.

## Methods And Inheritance

One advantage of deferred examples over core RSpec shared examples is that each deferred example group is a module. Therefore, when including multiple deferred examples they can reference the parent value. This is most useful when configuring a value for a test.

```ruby
module PayloadExamples
  include RSpec::SleepingKingStudios::Deferred::Provider

  deferred_examples 'when the payload includes a probe' do
    let(:probe)   { { name: 'Voyager III', type: :probe } }
    let(:payload) { super() << probe }
  end

  deferred_examples 'when the payload includes a satellite' do
    let(:satellite) { { name: 'Top Secret', type: :satellite } }
    let(:payload)   { super() << satellite }
  end
end

RSpec.describe Rocket do
  include RSpec::SleepingKingStudios::Deferred::Consumer
  include VehicleExamples

  let(:rocket)  { Rocket.new(name: 'Charon III', payload:) }
  let(:payload) { [] }

  context 'when the rocket has multiple payloads' do
    include_deferred 'when the payload includes a probe'
    include_deferred 'when the payload includes a satellite'

    it { expect(rocket.payload).to include probe }

    it { expect(rocket.payload).to include satellite }
  end
end
```

When defining a deferred example group using `deferred_context`, remember that a Ruby function call does not create a scope. Use the `define_method` method to define an instance method for use in an example, rather than defining the method using the `def` keyword. Likewise, use `const_set` to define any constant values, modules, or classes.

## Dependent Methods

In some cases, deferred example groups can rely on external context. For example, many of the above deferred example groups implictly rely on the presence of a `rocket` method or memoized helper; if included into an example group that does not define `rocket`, they will raise a `NoMethodError` when that example is executed.

To provide a better user experience, you can declare these external dependencies using `Deferred::Dependencies`.

```ruby
module RocketryExamples
  include RSpec::SleepingKingStudios::Deferred::Provider

  deferred_examples 'should be a Rocket' do
    include RSpec::SleepingKingStudios::Deferred::Dependencies

    depends_on :rocket, 'an instance of Rocket'

    it 'should be a Rocket' do
      expect(rocket).to be_a Rocket
    end
  end
end
```

When a deferred example group that includes `Deferred::Dependencies` is included in an example group, it registers a `before(:context)` hook that checks all of the included deferred examples for declared dependencies. For each declared method, it checks for the presence of either a defined method (using `def` or `define_method`) or a memoized helper (using `let`, `let!`, or a named `subject`).

If there are any missing methods, the hook will raise an exception with a list of the expected method names, the description provided to `depends_on` (if any), and the deferred example group that expects that method.

Declaring dependent methods can be particularly useful for deferred examples that are meant to be shared between projects.

## Configuration

To reduce clutter, the `Provider` and `Consumer` modules can be included at the top level in the RSpec configuration:

```ruby
RSpec.configure do |config|
  config.include RSpec::SleepingKingStudios::Deferred::Provider
  config.include RSpec::SleepingKingStudios::Deferred::Consumer
end
```

## Reflection

One disadvantage of using deferred example groups is that the full scope for an example can get obscured. For example, the description when reporting on a failed example does not include deferred examples. If you find yourself trying to track down exactly where an example is defined, or the example's full context, you can use the `Deferred.reflect(example)` method. This will return the full context for the example, including all deferred example groups (in parentheses, to distinguish them from regular example groups).

You can also pass the `source_locations: true` parameter to show where each example group or deferred example group is defined.

To configure this behavior automatically for failing tests, add the following to your RSpec configuration:

```ruby
config.after(:example) do |example|
  next unless ENV['REFLECT_ON_FAILURE']
  next unless example.metadata[:last_run_status] == 'failed'

  STDERR.puts "\nFailing spec at:"

  path =
    RSpec::SleepingKingStudios::Deferred
      .reflect(example, source_locations: true)
  path =
    SleepingKingStudios::Tools::Toolbelt
      .instance
      .string_tools
      .indent(path)

  STDERR.puts path
end
```

{% include breadcrumbs.md %}
