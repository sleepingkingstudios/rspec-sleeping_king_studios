# features/examples/property_examples/should_have_private_writer.feature

Feature: `PropertyExamples` shared examples
  Use the `'should have private writer'` shared example as a shorthand for
  specifying a private writer expectation on an object:

  ```ruby
  include_examples 'should have private writer', :foo # True if subject or instance has a private or protected method #foo=, otherwise false.
  ```

  In accordance with RSpec::SleepingKingStudios conventions, these examples
  preferentially use the value defined in `instance`, e.g.
  `let(:instance) { MyObject.new }`. To maximize compatibility, they will fall
  back to the RSpec built-in `subject` helper.

  Internally, the shared examples use the `have_writer` matcher defined at
  RSpec::SleepingKingStudios::Matchers::Core::HaveWriter.

  Scenario: basic usage
    Given a file named "examples/property_examples/should_have_private_writer/basic_spec.rb" with:
      """ruby
      require 'rspec/sleeping_king_studios/examples/property_examples'

      Value = Struct.new(:value, :type) do
        private :type=
      end # class

      RSpec.describe Value do
        include RSpec::SleepingKingStudios::Examples::PropertyExamples

        let(:instance) { Value.new }

        # Passing examples.
        include_examples 'should have private writer', :type

        # Failing examples.
        include_examples 'should have private writer', :value
      end # describe
      """
    When I run `rspec examples/property_examples/should_have_private_writer/basic_spec.rb`
    Then the output should contain "2 examples, 1 failure"
    Then the output should contain "expected #<struct Value value=nil, type=nil> not to respond to :value="
