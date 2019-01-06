# features/examples/property_examples/should_have_private_reader.feature

Feature: `PropertyExamples` shared examples
  Use the `'should have private reader'` shared example as a shorthand for
  specifying a private reader expectation on an object:

  ```ruby
  include_examples 'should have private reader', :foo # True if subject or instance has a private or protected method #foo, otherwise false.
  ```

  In accordance with RSpec::SleepingKingStudios conventions, these examples
  preferentially use the value defined in `instance`, e.g.
  `let(:instance) { MyObject.new }`. To maximize compatibility, they will fall
  back to the RSpec built-in `subject` helper.

  You can also specify a value for the reader, either as a direct value or as
  a proc. Note that the direct value is evaluated when including the shared
  example group, and does not have access to any memoized helpers. The proc
  value is evaluated when running the example, and does have access to memoized
  helpers. It can optionally take the instance or subject as the first
  parameter. The proc can return true or false, can return a value to compare
  the actual value with, or can return an RSpec matcher to evaluate against the
  actual value of `instance.foo` or `subject.foo`.

  ```ruby
  include_examples 'should have private reader', :foo, 42 # True if instance.send(:foo) == 42, otherwise false.

  include_examples 'should have private reader', :foo, ->() { 6 * 7 } # True if instance.send(:foo) == 42, otherwise false.

  include_examples 'should have private reader', :foo, ->(obj) { obj.even? } # True if instance.send(:foo).even?, otherwise

  include_examples 'should have private reader', :foo, ->() { an_instance_of Integer } # True if instance.send(:foo).is_a?(Integer), otherwise false.
  ```

  Internally, the shared examples use the `have_reader` matcher defined at
  RSpec::SleepingKingStudios::Matchers::Core::HaveReader.

  Scenario: basic usage
    Given a file named "examples/property_examples/should_have_private_reader/basic_spec.rb" with:
      """ruby
      require 'rspec/sleeping_king_studios/examples/property_examples'

      Value = Struct.new(:value, :type) do
        private :type
      end # class

      RSpec.describe Value do
        include RSpec::SleepingKingStudios::Examples::PropertyExamples

        let(:instance) { Value.new }

        # Passing examples.
        include_examples 'should have private reader', :type

        # Failing examples.
        include_examples 'should have private reader', :value
      end # describe
      """
    When I run `rspec examples/property_examples/should_have_private_reader/basic_spec.rb`
    Then the output should contain "2 examples, 1 failure"
    Then the output should contain "expected #<struct Value value=nil, type=nil> not to respond to :value"

  Scenario: value expectations
    Given a file named "examples/property_examples/should_have_private_reader/values_spec.rb" with:
      """ruby
      require 'rspec/sleeping_king_studios/examples/property_examples'

      Movie =
        Struct.new(:title, :release_date) do
          private :title, :release_date
        end # struct

      RSpec.describe Movie do
        include RSpec::SleepingKingStudios::Examples::PropertyExamples

        let(:the_eighties) { 1980...1990 }
        let(:instance)     { Movie.new 'Tron', 1982 }

        # Passing examples.
        include_examples 'should have private reader', :title, 'Tron'

        include_examples 'should have private reader', :title, ->() { be_a(String) }

        include_examples 'should have private reader', :release_date, ->(year) { the_eighties.cover?(year) }

        # Failing examples.
        include_examples 'should have private reader', :name, 'Tron'

        include_examples 'should have private reader', :title, 'Space Paranoids'

        include_examples 'should have private reader', :title, ->() { start_with('X') }

        include_examples 'should have private reader', :release_date, ->(year) { year > 1989 }
        end # describe
      """
    When I run `rspec examples/property_examples/should_have_private_reader/values_spec.rb`
    Then the output should contain "7 examples, 4 failures"
    Then the output should contain consecutive lines:
      | expected #<struct Movie title="Tron", release_date=1982> to respond to :name and return "Tron", but did not respond to :name |
    Then the output should contain consecutive lines:
      | expected #<struct Movie title="Tron", release_date=1982> to respond to :title and return "Space Paranoids", but returned "Tron" |
    Then the output should contain consecutive lines:
      | expected #<struct Movie title="Tron", release_date=1982> to respond to :title and return start with "X", but returned "Tron" |
    Then the output should contain consecutive lines:
      | expected #<struct Movie title="Tron", release_date=1982> to respond to :release_date and return satisfy expression `object_tools.apply self, expected_value, actual_value`, but returned 1982 |
