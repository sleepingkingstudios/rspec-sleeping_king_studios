# features/matchers/core/have_writer_matcher.feature

Feature: `have_writer` matcher
  Use the `have_writer` matcher to specify that an object must respond to
  `#property=`:

  ```ruby
  expect(instance).to have_writer(:foo=) # True if instance responds to #foo=, otherwise false.

  expect(instance).to have_writer(:foo)  # The "=" is automatically appended if omitted.
  ```

  Note that the `have_writer` matcher does not validate that the method changes
  the state of the object. To specify a state change, use the built-in RSpec
  `change` matcher.

  Scenario: basic usage
    Given a file named "have_writer_matcher_spec.rb" with:
      """ruby
        require 'rspec/sleeping_king_studios/matchers/core/have_writer'

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
          it { expect(instance).to have_writer(:foo) }
          it { expect(instance).not_to have_writer(:bar) }
          it { expect(instance).to have_writer(:baz) }

          # Failing expectations.
          it { expect(instance).not_to have_writer(:foo) }
          it { expect(instance).to have_writer(:bar) }
          it { expect(instance).not_to have_writer(:baz) }
        end # describe
      """
    When I run `rspec have_writer_matcher_spec.rb`
    Then the output should contain "6 examples, 3 failures"
    Then the output should contain:
      """
           Failure/Error: it { expect(instance).not_to have_writer(:foo) }
             expected MyClass not to respond to :foo=
      """
    Then the output should contain:
      """
           Failure/Error: it { expect(instance).to have_writer(:bar) }
             expected MyClass to respond to :bar=
      """
    Then the output should contain:
      """
           Failure/Error: it { expect(instance).not_to have_writer(:baz) }
             expected MyClass not to respond to :baz=
      """
