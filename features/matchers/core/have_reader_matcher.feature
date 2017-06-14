# features/matchers/core/have_reader_matcher.feature

Feature: `have_reader` matcher
  Use the `have_reader` matcher to specify that an object must respond to
  `#property`:

  ```ruby
  expect(instance).to have_reader(:foo) # True if instance responds to #foo, otherwise false.
  ```

  You can also specify a current value for the property with the `with_value`
  method. This can take a literal value, or you can use RSpec composable
  matchers for a more advanced expectation:

  ```ruby
  expect(instance).to have_reader(:foo).with_value('Foo') # Expects instance.foo to be == 'Foo'.

  expect(instance).to have_reader(:foo).with_value(an_instance_of String) # Expects instance.foo to be a String.
  ```

  Private readers can be tested by setting the `allow_private` option. This
  allows you to test helper methods or internal interfaces.

  ```ruby
  expect(instance).to have_reader(:foo, :allow_private => true) # True if instance defines #foo, regardless of the method access control.
  expect(instance).to have_reader(:foo, :allow_private => true).with_value('Foo') # Expects instance.send(:foo) to be == 'Foo'.
  ```

  Scenario: basic usage
    Given a file named "matchers/core/have_reader_matcher/basics_spec.rb" with:
      """ruby
        require 'rspec/sleeping_king_studios/matchers/core/have_reader'

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
          it { expect(instance).to have_reader(:foo) }
          it { expect(instance).to have_reader(:bar) }
          it { expect(instance).not_to have_reader(:baz) }

          # Failing expectations.
          it { expect(instance).not_to have_reader(:foo) }
          it { expect(instance).not_to have_reader(:bar) }
          it { expect(instance).to have_reader(:baz) }
        end # describe
      """
    When I run `rspec matchers/core/have_reader_matcher/basics_spec.rb`
    Then the output should contain "6 examples, 3 failures"
    Then the output should contain:
      """
           Failure/Error: it { expect(instance).not_to have_reader(:foo) }
             expected MyClass not to respond to :foo, but responded to :foo
      """
    Then the output should contain:
      """
           Failure/Error: it { expect(instance).not_to have_reader(:bar) }
             expected MyClass not to respond to :bar
      """
    Then the output should contain:
      """
           Failure/Error: it { expect(instance).to have_reader(:baz) }
             expected MyClass to respond to :baz, but did not respond to :baz
      """

  Scenario: value expectations
    Given a file named "matchers/core/have_reader_matcher/values_spec.rb" with:
      """ruby
        require 'rspec/sleeping_king_studios/matchers/core/have_reader'

        class MyClass
          attr_accessor :foo

          def inspect
            'MyClass'
          end # method inspect
        end # class

        RSpec.describe MyClass do
          let(:instance) { described_class.new.tap { |obj| obj.foo = 'Foo' } }

          # Passing expectations.
          it { expect(instance).to have_reader(:foo).with_value('Foo') }
          it { expect(instance).to have_reader(:foo).with_value(an_instance_of String) }

          # Failing expectations.
          it { expect(instance).not_to have_reader(:foo).with_value('Foo') }
          it { expect(instance).not_to have_reader(:foo).with_value('Bar') }
          it { expect(instance).not_to have_reader(:foo).with_value(an_instance_of String) }
          it { expect(instance).not_to have_reader(:foo).with_value(an_instance_of Hash) }
          it { expect(instance).to have_reader(:foo).with_value('Bar') }
          it { expect(instance).to have_reader(:foo).with_value(an_instance_of Hash) }
        end # describe
      """
    When I run `rspec matchers/core/have_reader_matcher/values_spec.rb`
    Then the output should contain "8 examples, 6 failures"
    Then the output should contain:
      """
           Failure/Error: it { expect(instance).not_to have_reader(:foo).with_value('Foo') }
             expected MyClass not to respond to :foo and return "Foo", but responded to :foo and returned "Foo"
      """
    Then the output should contain:
      """
           Failure/Error: it { expect(instance).not_to have_reader(:foo).with_value('Bar') }
             expected MyClass not to respond to :foo and return "Bar", but responded to :foo
      """
    Then the output should contain:
      """
           Failure/Error: it { expect(instance).not_to have_reader(:foo).with_value(an_instance_of String) }
             expected MyClass not to respond to :foo and return an instance of String, but responded to :foo and returned "Foo"
      """
    Then the output should contain:
      """
           Failure/Error: it { expect(instance).not_to have_reader(:foo).with_value(an_instance_of Hash) }
             expected MyClass not to respond to :foo and return an instance of Hash, but responded to :foo
      """
    Then the output should contain:
      """
           Failure/Error: it { expect(instance).to have_reader(:foo).with_value('Bar') }
             expected MyClass to respond to :foo and return "Bar", but returned "Foo"
      """
    Then the output should contain:
      """
           Failure/Error: it { expect(instance).to have_reader(:foo).with_value(an_instance_of Hash) }
             expected MyClass to respond to :foo and return an instance of Hash, but returned "Foo"
      """

  Scenario: private readers
    Given a file named "matchers/core/have_reader_matcher/private_spec.rb" with:
      """ruby
        require 'rspec/sleeping_king_studios/matchers/core/have_reader'

        class MyClass
          attr_reader :foo, :bar

          private :bar

          def inspect
            'MyClass'
          end # method inspect
        end # class

        RSpec.describe MyClass do
          let(:instance) { described_class.new }

          # Passing expectations.
          it { expect(instance).to have_reader(:foo, :allow_private => false) }
          it { expect(instance).to have_reader(:foo, :allow_private => true) }
          it { expect(instance).not_to have_reader(:bar, :allow_private => false) }
          it { expect(instance).to have_reader(:bar, :allow_private => true) }

          # Failing expectations.
          it { expect(instance).not_to have_reader(:foo, :allow_private => false) }
          it { expect(instance).not_to have_reader(:foo, :allow_private => true) }
          it { expect(instance).to have_reader(:bar, :allow_private => false) }
          it { expect(instance).not_to have_reader(:bar, :allow_private => true) }
        end # describe
      """
    When I run `rspec matchers/core/have_reader_matcher/private_spec.rb`
    Then the output should contain "8 examples, 4 failures"
    Then the output should contain:
      """
           Failure/Error: it { expect(instance).not_to have_reader(:foo, :allow_private => false) }
             expected MyClass not to respond to :foo, but responded to :foo
      """
    Then the output should contain:
      """
           Failure/Error: it { expect(instance).not_to have_reader(:foo, :allow_private => true) }
             expected MyClass not to respond to :foo, but responded to :foo
      """
    Then the output should contain:
      """
           Failure/Error: it { expect(instance).to have_reader(:bar, :allow_private => false) }
             expected MyClass to respond to :bar, but did not respond to :bar
      """
    Then the output should contain:
      """
           Failure/Error: it { expect(instance).not_to have_reader(:bar, :allow_private => true) }
             expected MyClass not to respond to :bar, but responded to :bar
      """
