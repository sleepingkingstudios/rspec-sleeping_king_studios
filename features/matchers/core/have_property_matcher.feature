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

  Private properties can be tested by setting the `allow_private` option. This
  allows you to test helper methods or internal interfaces.

  ```ruby
  expect(instance).to have_property(:foo, :allow_private => true) # True if instance responds to both #foo and #foo=, regardless of the method access control.
  expect(instance).to have_property(:foo, :allow_private => true).with_value('Foo') # Expects instance.send(:foo) to be == 'Foo'.
  ```

  Scenario: basic usage
    Given a file named "matchers/core/have_property_matcher/basics_spec.rb" with:
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

          # Failing expectations.
          it { expect(instance).not_to have_property(:foo) }
          it { expect(instance).to have_property(:bar) }
          it { expect(instance).not_to have_property(:bar) }
          it { expect(instance).to have_property(:baz) }
          it { expect(instance).not_to have_property(:baz) }
        end # describe
      """
    When I run `rspec matchers/core/have_property_matcher/basics_spec.rb`
    Then the output should contain "6 examples, 5 failures"
    Then the output should contain consecutive lines:
      | Failure/Error: it { expect(instance).not_to have_property(:foo) } |
      |   expected MyClass not to respond to :foo or :foo=, but responded to :foo and :foo= |
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

  Scenario: value expectations
    Given a file named "matchers/core/have_property_matcher/values_spec.rb" with:
      """ruby
        require 'rspec/sleeping_king_studios/matchers/core/have_property'

        class MyClass
          attr_accessor :foo

          def inspect
            'MyClass'
          end # method inspect
        end # class

        RSpec.describe MyClass do
          let(:instance) { described_class.new.tap { |obj| obj.foo = 'Foo' } }

          # Passing expectations.
          it { expect(instance).to have_property(:foo).with_value('Foo') }
          it { expect(instance).to have_property(:foo).with_value(an_instance_of String) }

          # Failing expectations.
          it { expect(instance).not_to have_property(:foo).with_value('Foo') }
          it { expect(instance).not_to have_property(:foo).with_value('Bar') }
          it { expect(instance).not_to have_property(:foo).with_value(an_instance_of String) }
          it { expect(instance).not_to have_property(:foo).with_value(an_instance_of Hash) }
          it { expect(instance).to have_property(:foo).with_value('Bar') }
          it { expect(instance).to have_property(:foo).with_value(an_instance_of Hash) }
        end # describe
      """
    When I run `rspec matchers/core/have_property_matcher/values_spec.rb`
    Then the output should contain "8 examples, 6 failures"
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

  @focus
  Scenario: private properties
    Given a file named "matchers/core/have_property_matcher/private_spec.rb" with:
      """ruby
        require 'rspec/sleeping_king_studios/matchers/core/have_property'

        class MyClass
          attr_accessor :foo, :bar, :baz, :qux

          private :bar, :baz=, :qux, :qux=

          def inspect
            'MyClass'
          end # method inspect
        end # class

        RSpec.describe MyClass do
          let(:instance) { described_class.new }

          # Passing expectations.
          it { expect(instance).to have_property(:foo, :allow_private => false) }
          it { expect(instance).to have_property(:foo, :allow_private => true) }
          it { expect(instance).to have_property(:bar, :allow_private => true) }
          it { expect(instance).to have_property(:baz, :allow_private => true) }
          it { expect(instance).to have_property(:qux, :allow_private => true) }
          it { expect(instance).not_to have_property(:qux, :allow_private => false) }

          # Failing expectations.
          it { expect(instance).not_to have_property(:foo, :allow_private => false) }
          it { expect(instance).not_to have_property(:foo, :allow_private => true) }
          it { expect(instance).to have_property(:bar, :allow_private => false) }
          it { expect(instance).not_to have_property(:bar, :allow_private => false) }
          it { expect(instance).not_to have_property(:bar, :allow_private => true) }
          it { expect(instance).to have_property(:baz, :allow_private => false) }
          it { expect(instance).not_to have_property(:baz, :allow_private => false) }
          it { expect(instance).not_to have_property(:baz, :allow_private => true) }
          it { expect(instance).to have_property(:qux, :allow_private => false) }
          it { expect(instance).not_to have_property(:qux, :allow_private => true) }
        end # describe
      """
    When I run `rspec matchers/core/have_property_matcher/private_spec.rb --order=defined`
    Then the output should contain "16 examples, 10 failures"
    Then the output should contain consecutive lines:
      | Failure/Error: it { expect(instance).not_to have_property(:foo, :allow_private => false) } |
      |   expected MyClass not to respond to :foo or :foo=, but responded to :foo and :foo= |
    Then the output should contain consecutive lines:
      | Failure/Error: it { expect(instance).not_to have_property(:foo, :allow_private => true) } |
      |   expected MyClass not to respond to :foo or :foo=, but responded to :foo and :foo= |
    Then the output should contain consecutive lines:
      | Failure/Error: it { expect(instance).to have_property(:bar, :allow_private => false) } |
      |   expected MyClass to respond to :bar and :bar=, but did not respond to :bar |
    Then the output should contain consecutive lines:
      | Failure/Error: it { expect(instance).not_to have_property(:bar, :allow_private => false) } |
      |   expected MyClass not to respond to :bar or :bar=, but responded to :bar= |
    Then the output should contain consecutive lines:
      | Failure/Error: it { expect(instance).not_to have_property(:bar, :allow_private => true) } |
      |   expected MyClass not to respond to :bar or :bar=, but responded to :bar and :bar= |
    Then the output should contain consecutive lines:
      | Failure/Error: it { expect(instance).to have_property(:baz, :allow_private => false) } |
      |   expected MyClass to respond to :baz and :baz=, but did not respond to :baz= |
    Then the output should contain consecutive lines:
      | Failure/Error: it { expect(instance).not_to have_property(:baz, :allow_private => false) } |
      |   expected MyClass not to respond to :baz or :baz=, but responded to :baz |
    Then the output should contain consecutive lines:
      | Failure/Error: it { expect(instance).not_to have_property(:baz, :allow_private => true) } |
      |   expected MyClass not to respond to :baz or :baz=, but responded to :baz and :baz= |
    Then the output should contain consecutive lines:
      | Failure/Error: it { expect(instance).to have_property(:qux, :allow_private => false) } |
      |   expected MyClass to respond to :qux and :qux=, but did not respond to :qux or :qux= |
    Then the output should contain consecutive lines:
      | Failure/Error: it { expect(instance).not_to have_property(:qux, :allow_private => true) } |
      |   expected MyClass not to respond to :qux or :qux=, but responded to :qux and :qux= |
