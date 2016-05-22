# features/examples/property_examples/should_have_constant.feature

Feature: `PropertyExamples` shared examples
  Use the `'should have constant'` shared examples as a shorthand for specifying
  a constant expectation on a class:

  ```ruby
  include_examples 'should have constant', :FOO # True if subject or described_class defines constant :FOO, otherwise false.
  ```

  You can also use the 'should have immutable constant' shared examples to set
  an additional mutability expectation. Values of `nil`, `false`, and `true`
  are always immutable, as are instances of `Numeric` and `Symbol`. Arrays are
  immutable if the array is frozen and all items are immutable. Hashes are
  immutable if the hash is frozen and all keys and values are immutable. All
  other objects are only immutable if the object is frozen.

  ```ruby
  include_examples 'should have immutable constant', :FOO # True if subject or described_class defines constant :FOO and the value of :FOO is immutable, otherwise false.
  ```

  In accordance with RSpec::SleepingKingStudios conventions, these examples
  preferentially use the value defined in `described_class`, e.g.
  `describe MyClass do ... end`. To maximize compatibility, they will fall
  back to the RSpec built-in `subject` helper if `described_class` is not
  defined or if described_class is not a `Module`.

  You can also specify a value for the constant, either as a direct value or as
  a proc. Note that the direct value is evaluated when including the shared
  example group, and does not have access to any memoized helpers. The proc
  value is evaluated when running the example, and does have access to memoized
  helpers. It can optionally take the instance or subject as the first
  parameter. The proc can return true or false, can return a value to compare
  the actual value with, or can return an RSpec matcher to evaluate against the
  actual value of `instance.foo` or `subject.foo`.

  ```ruby
  include_examples 'should have constant', :FOO, 42 # True if described_class::FOO == 42, otherwise false.

  include_examples 'should have constant', :foo, ->() { 6 * 7 } # True if described_class::FOO == 42, otherwise false.

  include_examples 'should have constant', :foo, ->(obj) { obj.even? } # True if described_class::FOO.even?, otherwise

  include_examples 'should have constant', :foo, ->() { an_instance_of Fixnum } # True if described_class::FOO.is_a?(Fixnum), otherwise false.
  ```

  Internally, the shared example uses the `have_constant` matcher defined at
  RSpec::SleepingKingStudios::Matchers::Core::HaveConstant.

  Scenario: basic usage
    Given a file named "examples/property_examples/should_have_constant/basic_spec.rb" with:
      """ruby
      require 'rspec/sleeping_king_studios/examples/property_examples'

      class ValueTypes
        STRING_TYPE = 'string'
      end # class

      RSpec.describe ValueTypes do
        include RSpec::SleepingKingStudios::Examples::PropertyExamples

        # Passing examples.
        include_examples 'should have constant', :STRING_TYPE

        # Failing examples.
        include_examples 'should have constant', :INTEGER_TYPE
      end # describe
      """
    When I run `rspec examples/property_examples/should_have_constant/basic_spec.rb`
    Then the output should contain "2 examples, 1 failure"
    Then the output should contain "expected ValueTypes to have constant :INTEGER_TYPE, but ValueTypes does not define constant :INTEGER_TYPE"

  Scenario: immutable expectations
    Given a file named "examples/property_examples/should_have_constant/immutable_spec.rb" with:
      """ruby
      require 'rspec/sleeping_king_studios/examples/property_examples'

      class Secrets
        ANSWER   = 42
        API_KEY  = '12345'
        PASSWORD = 'swordfish'.freeze

        ADMIN_USERS = [
          'alan.bradley@example.com',
          'kevin.flynn@example.com'
        ] # end array
        MANAGER_USERS = [
          'ed.dilliger@example.com'
        ].freeze # end array
        PROGRAMS = [
          'tron'.freeze,
          'clu'.freeze
        ].freeze # end array
      end # class

      RSpec.describe Secrets do
        include RSpec::SleepingKingStudios::Examples::PropertyExamples

        # Passing examples.
        include_examples 'should have immutable constant', :ANSWER

        include_examples 'should have immutable constant', :PASSWORD

        include_examples 'should have immutable constant', :PROGRAMS

        # Failing examples.
        include_examples 'should have immutable constant', :API_KEY

        include_examples 'should have immutable constant', :ADMIN_USERS

        include_examples 'should have immutable constant', :MANAGER_USERS
      end # describe
      """
    When I run `rspec examples/property_examples/should_have_constant/immutable_spec.rb`
    Then the output should contain "6 examples, 3 failures"
    Then the output should contain "expected Secrets to have immutable constant :API_KEY, but the value of :API_KEY was mutable"
    Then the output should contain "expected Secrets to have immutable constant :ADMIN_USERS, but the value of :ADMIN_USERS was mutable"
    Then the output should contain "expected Secrets to have immutable constant :MANAGER_USERS, but the value of :MANAGER_USERS was mutable"

  Scenario: value expectations
    Given a file named "examples/property_examples/should_have_constant/values_spec.rb" with:
      """ruby
      require 'rspec/sleeping_king_studios/examples/property_examples'

      class ExampleValues
        EXAMPLE_NUMBER = 42
        EXAMPLE_STRING = "I'm a String!"
      end # class

      RSpec.describe ExampleValues do
        include RSpec::SleepingKingStudios::Examples::PropertyExamples

        let(:the_answer) { 42 }

        # Passing examples.
        include_examples 'should have constant', :EXAMPLE_STRING, "I'm a String!"

        include_examples 'should have constant', :EXAMPLE_STRING, ->() { be_a(String) }

        include_examples 'should have constant', :EXAMPLE_NUMBER, ->(number) { number == the_answer }

        # Failing examples.
        include_examples 'should have constant', :EXAMPLE_SYMBOL, :totally_symbolic

        include_examples 'should have constant', :EXAMPLE_STRING, 'Secretly not a String...'

        include_examples 'should have constant', :EXAMPLE_STRING, ->() { start_with('X') }

        include_examples 'should have constant', :EXAMPLE_NUMBER, ->(number) { number.odd? }
      end # describe
      """
    When I run `rspec examples/property_examples/should_have_constant/values_spec.rb`
    Then the output should contain "7 examples, 4 failures"
    Then the output should contain "expected ExampleValues to have constant :EXAMPLE_SYMBOL with value :totally_symbolic, but ExampleValues does not define constant :EXAMPLE_SYMBOL"
    Then the output should contain consecutive lines:
      | expected ExampleValues to have constant :EXAMPLE_STRING with value "Secretly not a String...", but constant :EXAMPLE_STRING has value "I'm a String!" |
    Then the output should contain consecutive lines:
      | expected ExampleValues to have constant :EXAMPLE_STRING with value start with "X", but constant :EXAMPLE_STRING has value "I'm a String!" |
    Then the output should contain "expected ExampleValues to have constant :EXAMPLE_NUMBER with value satisfy block, but constant :EXAMPLE_NUMBER has value 42"
