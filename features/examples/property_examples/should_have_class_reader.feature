# features/examples/property_examples/should_have_class_reader.feature

Feature: `PropertyExamples` shared examples
  Use the `'should have class reader'` shared example as a shorthand for
  specifying a reader expectation on the described class:

  ```ruby
  include_examples 'should have class reader', :foo # True if described_class responds to #foo, otherwise false.
  ```

  You can also specify a value for the reader, either as a direct value or as
  a proc. Note that the direct value is evaluated when including the shared
  example group, and does not have access to any memoized helpers. The proc
  value is evaluated when running the example, and does have access to memoized
  helpers. It can optionally take the instance or subject as the first
  parameter. The proc can return true or false, can return a value to compare
  the actual value with, or can return an RSpec matcher to evaluate against the
  actual value of `instance.foo` or `subject.foo`.

  ```ruby
  include_examples 'should have class reader', :foo, 42 # True if described_class.foo == 42, otherwise false.

  include_examples 'should have class reader', :foo, ->() { 6 * 7 } # True if described_class.foo == 42, otherwise false.

  include_examples 'should have class reader', :foo, ->(obj) { obj.even? } # True if described_class.foo.even?, otherwise

  include_examples 'should have class reader', :foo, ->() { an_instance_of Integer } # True if described_class.foo.is_a?(Integer), otherwise false.
  ```

  You can also use negated form, `'should not have class reader'`, which does not
  permit a value expectation:

  ```ruby
  include_examples 'should not have class reader', :foo # True if described_class does not respond to #foo, otherwise false.
  ```

  Internally, the shared examples use the `have_reader` matcher defined at
  RSpec::SleepingKingStudios::Matchers::Core::HaveReader.

  Scenario: basic usage
    Given a file named "examples/property_examples/should_have_class_reader/basic_spec.rb" with:
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
        include_examples 'should have class reader', :value

        include_examples 'should have class reader', :type

        include_examples 'should not have class reader', :old_value

        include_examples 'should not have class reader', :raw_value

        # Failing examples.
        include_examples 'should have class reader', :old_value

        include_examples 'should have class reader', :raw_value

        include_examples 'should not have class reader', :value

        include_examples 'should not have class reader', :type
      end # describe
      """
    When I run `rspec examples/property_examples/should_have_class_reader/basic_spec.rb`
    Then the output should contain "8 examples, 4 failures"
    Then the output should contain "expected ValueClass to respond to :old_value, but did not respond to :old_value"
    Then the output should contain "expected ValueClass to respond to :raw_value, but did not respond to :raw_value"
    Then the output should contain "expected ValueClass not to respond to :value, but responded to :value"
    Then the output should contain "expected ValueClass not to respond to :type, but responded to :type"

  Scenario: value expectations
    Given a file named "examples/property_examples/should_have_class_reader/values_spec.rb" with:
      """ruby
      require 'rspec/sleeping_king_studios/examples/property_examples'

      class MovieClass
        class << self
          attr_accessor :title, :release_date
        end # eigenclass
      end # class

      RSpec.describe MovieClass do
        include RSpec::SleepingKingStudios::Examples::PropertyExamples

        before(:example) do
          MovieClass.title = 'Tron'
          MovieClass.release_date = 1982
        end # before example

        let(:the_eighties) { 1980...1990 }

        # Passing examples.
        include_examples 'should have class reader', :title, 'Tron'

        include_examples 'should have class reader', :title, ->() { be_a(String) }

        include_examples 'should have class reader', :release_date, ->(year) { the_eighties.cover?(year) }

        # Failing examples.
        include_examples 'should have class reader', :movie_name, 'Tron'

        include_examples 'should have class reader', :title, 'Space Paranoids'

        include_examples 'should have class reader', :title, ->() { start_with('X') }

        include_examples 'should have class reader', :release_date, ->(year) { year > 1989 }
      end # describe
      """
    When I run `rspec examples/property_examples/should_have_class_reader/values_spec.rb`
    Then the output should contain "7 examples, 4 failures"
    Then the output should contain consecutive lines:
      | expected MovieClass to respond to :movie_name and return "Tron", but did not respond to :movie_name |
    Then the output should contain consecutive lines:
      | expected MovieClass to respond to :title and return "Space Paranoids", but returned "Tron" |
    Then the output should contain consecutive lines:
      | expected MovieClass to respond to :title and return start with "X", but returned "Tron" |
    Then the output should contain consecutive lines:
      | expected MovieClass to respond to :release_date and return satisfy <%= Spec::RSPEC_VERSION < '3.6.0' ? 'block' : 'expression `object_tools.apply self, expected_value, actual_value`' %>, but returned 1982 |
