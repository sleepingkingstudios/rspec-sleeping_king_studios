# features/examples/property_examples/should_have_writer.feature

Feature: `PropertyExamples` shared examples
  Use the `'should have writer'` shared example as a shorthand for specifying
  a writer expectation on an object:

  ```ruby
  include_examples 'should have writer', :foo # True if subject or instance responds to #foo=, otherwise false.

  include_examples 'should have writer', :foo= # True if subject or instance responds to #foo=, otherwise false.
  ```

  In accordance with RSpec::SleepingKingStudios conventions, these examples
  preferentially use the value defined in `instance`, e.g.
  `let(:instance) { MyObject.new }`. To maximize compatibility, they will fall
  back to the RSpec built-in `subject` helper.

  You can also use negated form, `'should not have writer'`:

  ```ruby
  include_examples 'should not have writer', :foo # True if subject or instance does not respond to #foo=, otherwise false.

  include_examples 'should not have writer', :foo= # True if subject or instance does not respond to #foo=, otherwise false.
  ```

  Internally, the shared examples use the `have_writer` matcher defined at
  RSpec::SleepingKingStudios::Matchers::Core::HaveWriter.

  Scenario: basic usage
    Given a file named "examples/property_examples/should_have_writer/basic_spec.rb" with:
      """ruby
      require 'rspec/sleeping_king_studios/examples/property_examples'

      Value = Struct.new(:value) do
        attr_reader :type

        attr_writer :raw_value
      end # class

      RSpec.describe Value do
        include RSpec::SleepingKingStudios::Examples::PropertyExamples

        let(:instance) { Value.new }

        # Passing examples.
        include_examples 'should have writer', :value
        include_examples 'should have writer', :value=
        include_examples 'should have writer', :raw_value
        include_examples 'should have writer', :raw_value=

        include_examples 'should not have writer', :old_value
        include_examples 'should not have writer', :old_value=
        include_examples 'should not have writer', :type
        include_examples 'should not have writer', :type=

        # Failing examples.
        include_examples 'should have writer', :old_value
        include_examples 'should have writer', :old_value=
        include_examples 'should have writer', :type
        include_examples 'should have writer', :type=

        include_examples 'should not have writer', :value
        include_examples 'should not have writer', :value=
        include_examples 'should not have writer', :raw_value
        include_examples 'should not have writer', :raw_value=
      end # describe
      """
    When I run `rspec examples/property_examples/should_have_writer/basic_spec.rb`
    Then the output should contain "16 examples, 8 failures"
    Then the output should contain "expected #<struct Value value=nil> to respond to :old_value=, but did not respond to :old_value="
    Then the output should contain "expected #<struct Value value=nil> to respond to :type=, but did not respond to :type="
    Then the output should contain "expected #<struct Value value=nil> not to respond to :value=, but responded to :value="
    Then the output should contain "expected #<struct Value value=nil> not to respond to :raw_value=, but responded to :raw_value="
