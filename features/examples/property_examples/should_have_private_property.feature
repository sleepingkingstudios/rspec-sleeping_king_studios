# features/examples/property_examples/should_have_private_property.feature

Feature: `PropertyExamples` shared examples
  Use the `'should have private property'` shared examples as a shorthand for
  specifying a private property expectation on an object:

  ```ruby
  include_examples 'should have private property', :foo # True if subject or instance has a private or protected methods #foo and #foo=, otherwise false.false.
  ```

  In accordance with RSpec::SleepingKingStudios conventions, these examples
  preferentially use the value defined in `instance`, e.g.
  `let(:instance) { MyObject.new }`. To maximize compatibility, they will fall
  back to the RSpec built-in `subject` helper.

  You can also specify a value for the property, either as a direct value or as
  a proc. Note that the direct value is evaluated when including the shared
  example group, and does not have access to any memoized helpers. The proc
  value is evaluated when running the example, and does have access to memoized
  helpers. It can optionally take the instance or subject as the first
  parameter. The proc can return true or false, can return a value to compare
  the actual value with, or can return an RSpec matcher to evaluate against the
  actual value of `instance.foo` or `subject.foo`.

  ```ruby
  include_examples 'should have private property', :foo, 42 # True if instance.send(:foo) == 42, otherwise false.

  include_examples 'should have private property', :foo, ->() { 6 * 7 } # True if instance.send(:foo) == 42, otherwise false.

  include_examples 'should have private property', :foo, ->(obj) { obj.even? } # True if instance.send(:foo).even?, otherwise

  include_examples 'should have private property', :foo, ->() { an_instance_of Integer } # True if instance.send(:foo).is_a?(Integer), otherwise false.
  ```

  Internally, the shared examples use the `have_property` matcher defined at
  RSpec::SleepingKingStudios::Matchers::Core::HaveReader.

  Scenario: basic usage
    Given a file named "examples/property_examples/should_have_private_property/basic_spec.rb" with:
      """ruby
      require 'rspec/sleeping_king_studios/examples/property_examples'

      Value = Struct.new(:value, :type, :default) do
        private :type, :type=, :default
      end # class

      RSpec.describe Value do
        include RSpec::SleepingKingStudios::Examples::PropertyExamples

        let(:instance) { Value.new }

        # Passing examples.
        include_examples 'should have private property', :type

        # Failing examples.
        include_examples 'should have private property', :value
        include_examples 'should have private property', :default
      end # describe
      """
    When I run `rspec examples/property_examples/should_have_private_property/basic_spec.rb`
    Then the output should contain "3 examples, 2 failures"
    Then the output should contain "expected #<struct Value value=nil, type=nil, default=nil> not to respond to :value"
    Then the output should contain "expected #<struct Value value=nil, type=nil, default=nil> not to respond to :default="

  Scenario: value expectations
    Given a file named "examples/property_examples/should_have_private_property/values_spec.rb" with:
      """ruby
      require 'rspec/sleeping_king_studios/examples/property_examples'

      Movie =
        Struct.new(:title, :release_date) do
          private :title, :title=, :release_date, :release_date=
        end # struct

      RSpec.describe Movie do
        include RSpec::SleepingKingStudios::Examples::PropertyExamples

        let(:the_eighties) { 1980...1990 }
        let(:instance)     { Movie.new 'Tron', 1982 }

        # Passing examples.
        include_examples 'should have private property', :title, 'Tron'

        include_examples 'should have private property', :title, ->() { be_a(String) }

        include_examples 'should have private property', :release_date, ->(year) { the_eighties.cover?(year) }

        # Failing examples.
        include_examples 'should have private property', :name, 'Tron'

        include_examples 'should have private property', :title, 'Space Paranoids'

        include_examples 'should have private property', :title, ->() { start_with('X') }

        include_examples 'should have private property', :release_date, ->(year) { year > 1989 }
        end # describe
      """
    When I run `rspec examples/property_examples/should_have_private_property/values_spec.rb`
    Then the output should contain "7 examples, 4 failures"
    Then the output should contain consecutive lines:
      | expected #<struct Movie title="Tron", release_date=1982> to respond to :name and :name= and return "Tron", but did not respond to :name |
    Then the output should contain consecutive lines:
      | expected #<struct Movie title="Tron", release_date=1982> to respond to :title and :title= and return "Space Paranoids", but returned "Tron" |
    Then the output should contain consecutive lines:
      | expected #<struct Movie title="Tron", release_date=1982> to respond to :title and :title= and return start with "X", but returned "Tron" |
    Then the output should contain consecutive lines:
      | expected #<struct Movie title="Tron", release_date=1982> to respond to :release_date and :release_date= and return satisfy <%= Spec::RSPEC_VERSION < '3.6.0' ? 'block' : 'expression `object_tools.apply self, expected_value, actual_value`' %>, but returned 1982 |

