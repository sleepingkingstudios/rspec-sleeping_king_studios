# features/matchers/core/have_predicate_matcher.feature

Feature: `have_predicate` matcher
  Use the `have_predicate` matcher to specify that an object must respond to
  `#property?`:

  ```ruby
  expect(instance).to have_predicate(:foo?) # True if instance responds to #foo?, otherwise false.
  ```

  You can also specify a current value for the property with the `with_value`
  method. A predicate should only return true or false.

  ```ruby
  expect(instance).to have_predicate(:foo?).with_value(true) # Expects instance.foo? to be true.
  ```

  Scenario: basic usage
    Given a file named "have_predicate_matcher_spec.rb" with:
      """ruby
        require 'rspec/sleeping_king_studios/matchers/core/have_predicate'

        class MyClass
          attr_accessor :foo, :bar

          def foo?
            !!foo
          end # method foo?

          def not_foo?
            !foo
          end # method not_foo?

          def inspect
            'MyClass'
          end # method inspect
        end # class

        RSpec.describe MyClass do
          let(:instance) { described_class.new.tap { |obj| obj.foo = 'Foo' } }

          # Passing expectations.
          it { expect(instance).to have_predicate(:foo) }
          it { expect(instance).to have_predicate(:foo).with_value(true) }
          it { expect(instance).not_to have_predicate(:foo).with_value(false) }
          it { expect(instance).not_to have_predicate(:bar) }

          # Failing expectations.
          it { expect(instance).not_to have_predicate(:foo) }
          it { expect(instance).not_to have_predicate(:foo).with_value(true) }
          it { expect(instance).to have_predicate(:foo).with_value(false) }
          it { expect(instance).to have_predicate(:bar) }
        end # describe
      """
    When I run `rspec have_predicate_matcher_spec.rb`
    Then the output should contain "8 examples, 4 failures"
    Then the output should contain consecutive lines:
      | Failure/Error: it { expect(instance).not_to have_predicate(:foo) } |
      |   expected MyClass not to respond to :foo? |
    Then the output should contain consecutive lines:
      | Failure/Error: it { expect(instance).not_to have_predicate(:foo).with_value(true) } |
      |   expected MyClass not to respond to :foo? and return true |
    Then the output should contain consecutive lines:
      | Failure/Error: it { expect(instance).to have_predicate(:foo).with_value(false) } |
      |   expected MyClass to respond to :foo? and return false, but returned true |
    Then the output should contain consecutive lines:
      | Failure/Error: it { expect(instance).to have_predicate(:bar) } |
      |   expected MyClass to respond to :bar? |
