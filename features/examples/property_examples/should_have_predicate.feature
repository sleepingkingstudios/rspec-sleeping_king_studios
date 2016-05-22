# features/examples/property_examples/should_have_predicate.feature

Feature: `PropertyExamples` shared examples
  Use the `'should have predicate'` shared examples as a shorthand for specifying
  a predicate expectation on an object:

  ```ruby
  include_examples 'should have predicate', :foo # True if subject or instance responds to #foo?, otherwise false.

  include_examples 'should have predicate', :foo? # True if subject or instance responds to #foo?, otherwise false.
  ```

  In accordance with RSpec::SleepingKingStudios conventions, these examples
  preferentially use the value defined in `instance`, e.g.
  `let(:instance) { MyObject.new }`. To maximize compatibility, they will fall
  back to the RSpec built-in `subject` helper.

  You can also specify a value for the predicate, either as a direct value or as
  a proc. Note that the direct value is evaluated when including the shared
  example group, and does not have access to any memoized helpers. The proc
  value is evaluated when running the example, and does have access to memoized
  helpers. It can optionally take the instance or subject as the first
  parameter. The proc can return true or false, can return a value to compare
  the actual value with, or can return an RSpec matcher to evaluate against the
  actual value of `instance.foo` or `subject.foo`.

  ```ruby
  include_examples 'should have predicate', :foo, true # True if instance.foo == true, otherwise false.

  include_examples 'should have reader', :foo, ->(obj) { obj == true } # True if instance.foo == true, otherwise false.

  include_examples 'should have reader', :foo, ->() { a_boolean } # True if instance.foo is true or false, otherwise false.
  ```

  Internally, the shared example uses the `have_predicate` matcher defined at
  RSpec::SleepingKingStudios::Matchers::Core::HavePredicate.

  Scenario: basic usage
    Given a file named "examples/property_examples/should_have_predicate/basic_spec.rb" with:
      """ruby
      require 'rspec/sleeping_king_studios/examples/property_examples'

      Value = Struct.new(:value) do
        def value?
          !!@value
        end # method value?
      end # class

      RSpec.describe Value do
        include RSpec::SleepingKingStudios::Examples::PropertyExamples

        let(:instance) { Value.new }

        # Passing examples.
        include_examples 'should have predicate', :value

        include_examples 'should have predicate', :value?

        # Failing examples.
        include_examples 'should have predicate', :old_value

        include_examples 'should have predicate', :old_value?
      end # describe
      """
    When I run `rspec examples/property_examples/should_have_predicate/basic_spec.rb`
    Then the output should contain "4 examples, 2 failures"
    Then the output should contain "expected #<struct Value value=nil> to respond to :old_value?, but did not respond to :old_value?"

  Scenario: value expectations
    Given a file named "examples/property_examples/should_have_predicate/values_spec.rb" with:
      """ruby
      require 'rspec/sleeping_king_studios/examples/property_examples'
      require 'rspec/sleeping_king_studios/matchers/core/be_boolean'

      Value = Struct.new(:value) do
        DEFAULT_VALUE = Object.new.freeze

        def initialize obj=DEFAULT_VALUE
          self.value      = obj
          @previous_value = obj
        end # method initialize

        def set_value obj
          @previous_value = value
          self.value      = obj
        end # method value=

        def value_changed?
          @previous_value != value
        end # method value_changed?

        def value_set?
          value != DEFAULT_VALUE
        end # method value_set?
      end # class

      require 'byebug'

      RSpec.describe Value do
        include RSpec::SleepingKingStudios::Examples::PropertyExamples

        let(:changed)  { false }
        let(:instance) { Value.new 42 }

        # Passing examples.
        include_examples 'should have predicate', :value_changed?, false

        include_examples 'should have predicate', :value_set?, true

        include_examples 'should have predicate', :value_set, ->() { be_boolean }

        include_examples 'should have predicate', :value_changed?, ->(result) { result == changed }

        # Failing examples.
        include_examples 'should have predicate', :value_cleared?, true

        include_examples 'should have predicate', :value_changed?, true

        include_examples 'should have predicate', :value_set?, ->() { be_a(String) }

        include_examples 'should have predicate', :value_set?, ->(result) { result == changed }
      end # describe
      """
    When I run `rspec examples/property_examples/should_have_predicate/values_spec.rb`
    Then the output should contain "8 examples, 4 failures"
    Then the output should contain consecutive lines:
      | expected #<struct Value value=42> to respond to :value_cleared? and return true, but did not respond to :value_cleared? |
    Then the output should contain consecutive lines:
      | expected #<struct Value value=42> to respond to :value_changed? and return true, but returned false |
    Then the output should contain consecutive lines:
      | expected #<struct Value value=42> to respond to :value_set? and return be a kind of String, but returned true |
    Then the output should contain consecutive lines:
      | expected #<struct Value value=42> to respond to :value_set? and return satisfy block, but returned true |
