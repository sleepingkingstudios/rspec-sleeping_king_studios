# features/matchers/core/have_property_matcher.feature

Feature: `have_property` matcher
  Use the `have_property` matcher to specify that an object must respond to
  both `#property` and `#property=`:

  ```ruby
  expect(instance).to have_property(:foo) # True if instance responds to both #foo and #foo=, otherwise false.
  ```

  You can also specify a current value for the property with the `with_value`
  method. This can take a literal value, or you can use RSpec composable
  matchers for a more advanced expectation:

  ```ruby
  expect(instance).to have_property(:foo).with_value('Foo') # Expects instance.foo to be == 'Foo'.

  expect(instance).to have_property(:foo).with_value(an_instance_of String) # Expects instance.foo to be a String.
  ```

  Note that the `have_property` matcher is very conservative as to what it
  accepts, particularly when negated. For example,
  `expect(instance).not_to have_property(:foo).with_value('Bar')` will fail
  if `instance` responds to `#foo` and `#foo=`, even if the value of `#foo` is
  not `'Bar'`.

  Scenario: basic usage
    Given a file named "have_property_matcher_spec.rb" with:
      """ruby
        require 'rspec/sleeping_king_studios/matchers/core/have_property'

        class MyClass
          attr_accessor :foo

          attr_reader :bar

          attr_writer :baz

          def inspect
            'MyClass'
          end # method inspect
        end # class

        RSpec.describe MyClass do
          let(:instance) { described_class.new.tap { |obj| obj.foo = 'Foo' } }

          # Passing expectations.
          it { expect(instance).to have_property(:foo) }
          it { expect(instance).to have_property(:foo).with_value('Foo') }
          it { expect(instance).to have_property(:foo).with_value(an_instance_of String) }

          # Failing expectations.
          it { expect(instance).not_to have_property(:foo) }
          it { expect(instance).not_to have_property(:foo).with_value('Foo') }
          it { expect(instance).not_to have_property(:foo).with_value('Bar') }
          it { expect(instance).not_to have_property(:foo).with_value(an_instance_of String) }
          it { expect(instance).not_to have_property(:foo).with_value(an_instance_of Hash) }
          it { expect(instance).to have_property(:foo).with_value('Bar') }
          it { expect(instance).to have_property(:foo).with_value(an_instance_of Hash) }
          it { expect(instance).to have_property(:bar) }
          it { expect(instance).not_to have_property(:bar) }
          it { expect(instance).to have_property(:baz) }
          it { expect(instance).not_to have_property(:baz) }
        end # describe
      """
    When I run `rspec have_property_matcher_spec.rb`
    Then the output should contain "14 examples, 11 failures"
    Then the output should contain consecutive lines:
      | Failure/Error: it { expect(instance).not_to have_property(:foo) } |
      |   expected MyClass not to respond to :foo or :foo=, but responded to :foo and :foo= |
    Then the output should contain consecutive lines:
      | Failure/Error: it { expect(instance).not_to have_property(:foo).with_value('Foo') } |
      |   expected MyClass not to respond to :foo or :foo= and return "Foo", but responded to :foo and :foo= and returned "Foo" |
    Then the output should contain consecutive lines:
      | Failure/Error: it { expect(instance).not_to have_property(:foo).with_value('Bar') } |
      |   expected MyClass not to respond to :foo or :foo= and return "Bar", but responded to :foo and :foo= |
    Then the output should contain consecutive lines:
      | Failure/Error: it { expect(instance).not_to have_property(:foo).with_value(an_instance_of String) } |
      |   expected MyClass not to respond to :foo or :foo= and return an instance of String, but responded to :foo and :foo= and returned "Foo" |
    Then the output should contain consecutive lines:
      | Failure/Error: it { expect(instance).not_to have_property(:foo).with_value(an_instance_of Hash) } |
      |   expected MyClass not to respond to :foo or :foo= and return an instance of Hash, but responded to :foo and :foo= |
    Then the output should contain consecutive lines:
      | Failure/Error: it { expect(instance).to have_property(:foo).with_value('Bar') } |
      |   expected MyClass to respond to :foo and :foo= and return "Bar", but returned "Foo" |
    Then the output should contain consecutive lines:
      | Failure/Error: it { expect(instance).to have_property(:foo).with_value(an_instance_of Hash) } |
      |   expected MyClass to respond to :foo and :foo= and return an instance of Hash, but returned "Foo" |
    Then the output should contain consecutive lines:
      | Failure/Error: it { expect(instance).to have_property(:bar) } |
      |   expected MyClass to respond to :bar and :bar=, but did not respond to :bar= |
    Then the output should contain consecutive lines:
      | Failure/Error: it { expect(instance).not_to have_property(:bar) } |
      |   expected MyClass not to respond to :bar or :bar=, but responded to :bar |
    Then the output should contain consecutive lines:
      | Failure/Error: it { expect(instance).to have_property(:baz) } |
      |   expected MyClass to respond to :baz and :baz=, but did not respond to :baz |
    Then the output should contain consecutive lines:
      | Failure/Error: it { expect(instance).not_to have_property(:baz) } |
      |   expected MyClass not to respond to :baz or :baz=, but responded to :baz= |
