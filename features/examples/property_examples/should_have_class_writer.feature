# features/examples/property_examples/should_have_class_writer.feature

Feature: `PropertyExamples` shared examples
  Use the `'should have class writer'` shared example as a shorthand for
  specifying a writer expectation on an object:

  ```ruby
  include_examples 'should have class writer', :foo # True if described_class responds to #foo=, otherwise false.

  include_examples 'should have class writer', :foo= # True if described_class responds to #foo=, otherwise false.
  ```

  You can also use negated form, `'should not have class writer'`:

  ```ruby
  include_examples 'should not have class writer', :foo # True if described_class does not respond to #foo=, otherwise false.

  include_examples 'should not have class writer', :foo= # True if described_class does not respond to #foo=, otherwise false.
  ```

  Internally, the shared examples use the `have_writer` matcher defined at
  RSpec::SleepingKingStudios::Matchers::Core::HaveWriter.

  Scenario: basic usage
    Given a file named "examples/property_examples/should_have_class_writer/basic_spec.rb" with:
      """ruby
      require 'rspec/sleeping_king_studios/examples/property_examples'

      class ValueClass
        class << self
          attr_reader :type

          attr_writer :raw_value

          attr_accessor :value
        end # eigenclass
      end # class

      RSpec.describe ValueClass do
        include RSpec::SleepingKingStudios::Examples::PropertyExamples

        # Passing examples.
        include_examples 'should have class writer', :value
        include_examples 'should have class writer', :value=
        include_examples 'should have class writer', :raw_value
        include_examples 'should have class writer', :raw_value=

        include_examples 'should not have class writer', :old_value
        include_examples 'should not have class writer', :old_value=
        include_examples 'should not have class writer', :type
        include_examples 'should not have class writer', :type=

        # Failing examples.
        include_examples 'should have class writer', :old_value
        include_examples 'should have class writer', :old_value=
        include_examples 'should have class writer', :type
        include_examples 'should have class writer', :type=

        include_examples 'should not have class writer', :value
        include_examples 'should not have class writer', :value=
        include_examples 'should not have class writer', :raw_value
        include_examples 'should not have class writer', :raw_value=
      end # describe
      """
    When I run `rspec examples/property_examples/should_have_class_writer/basic_spec.rb`
    Then the output should contain "16 examples, 8 failures"
    Then the output should contain "expected ValueClass to respond to :old_value=, but did not respond to :old_value="
    Then the output should contain "expected ValueClass to respond to :type=, but did not respond to :type="
    Then the output should contain "expected ValueClass not to respond to :value=, but responded to :value="
    Then the output should contain "expected ValueClass not to respond to :raw_value=, but responded to :raw_value="
