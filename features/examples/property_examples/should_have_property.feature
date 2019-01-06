# features/examples/property_examples/should_have_property.feature

Feature: `PropertyExamples` shared examples
  Use the `'should have property'` shared examples as a shorthand for specifying
  a property expectation on an object:

  ```ruby
  include_examples 'should have property', :foo # True if subject or instance responds to #foo and #foo=, otherwise false.
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
  include_examples 'should have property', :foo, 42 # True if instance.foo == 42, otherwise false.

  include_examples 'should have property', :foo, ->() { 6 * 7 } # True if instance.foo == 42, otherwise false.

  include_examples 'should have property', :foo, ->(obj) { obj.even? } # True if instance.foo.even?, otherwise

  include_examples 'should have property', :foo, ->() { an_instance_of Integer } # True if instance.foo.is_a?(Integer), otherwise false.
  ```

  If the :allow_private option is set, the examples will also match a private
  reader or writer method.

  ```ruby
  include_examples 'should have property', :foo, :allow_private => true # True if instance defines #foo and #foo= methods, regardless of whether #foo and #foo= are public, protected, or private.

  include_examples 'should have property', :foo, 42, :allow_private => true # True if instance.send(:foo) == 42.
  ```

  Internally, the shared example uses the `have_property` matcher defined at
  RSpec::SleepingKingStudios::Matchers::Core::HaveProperty.

  Scenario: basic usage
    Given a file named "examples/property_examples/should_have_property/basic_spec.rb" with:
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
        include_examples 'should have property', :value

        # Failing examples.
        include_examples 'should have property', :old_value

        include_examples 'should have property', :raw_value

        include_examples 'should have property', :type
      end # describe
      """
    When I run `rspec examples/property_examples/should_have_property/basic_spec.rb`
    Then the output should contain "4 examples, 3 failures"
    Then the output should contain "expected #<struct Value value=nil> to respond to :old_value and :old_value=, but did not respond to :old_value or :old_value="
    Then the output should contain "expected #<struct Value value=nil> to respond to :raw_value and :raw_value=, but did not respond to :raw_value"
    Then the output should contain "expected #<struct Value value=nil> to respond to :type and :type=, but did not respond to :type="

  Scenario: value expectations
    Given a file named "examples/property_examples/should_have_property/values_spec.rb" with:
      """ruby
      require 'rspec/sleeping_king_studios/examples/property_examples'

      Movie = Struct.new(:title, :release_date)

      RSpec.describe Movie do
        include RSpec::SleepingKingStudios::Examples::PropertyExamples

        let(:the_eighties) { 1980...1990 }
        let(:instance)     { Movie.new 'Tron', 1982 }

        # Passing examples.
        include_examples 'should have property', :title, 'Tron'

        include_examples 'should have property', :title, ->() { be_a(String) }

        include_examples 'should have property', :release_date, ->(year) { the_eighties.cover?(year) }

        # Failing examples.
        include_examples 'should have property', :name, 'Tron'

        include_examples 'should have property', :title, 'Space Paranoids'

        include_examples 'should have property', :title, ->() { start_with('X') }

        include_examples 'should have property', :release_date, ->(year) { year > 1989 }
      end # describe
      """
    When I run `rspec examples/property_examples/should_have_property/values_spec.rb`
    Then the output should contain "7 examples, 4 failures"
    Then the output should contain consecutive lines:
      | expected #<struct Movie title="Tron", release_date=1982> to respond to :name and :name= and return "Tron", but did not respond to :name |
    Then the output should contain consecutive lines:
      | expected #<struct Movie title="Tron", release_date=1982> to respond to :title and :title= and return "Space Paranoids", but returned "Tron" |
    Then the output should contain consecutive lines:
      | expected #<struct Movie title="Tron", release_date=1982> to respond to :title and :title= and return start with "X", but returned "Tron" |
    Then the output should contain consecutive lines:
      | expected #<struct Movie title="Tron", release_date=1982> to respond to :release_date and :release_date= and return satisfy expression `object_tools.apply self, expected_value, actual_value`, but returned 1982 |

  Scenario: private properties
    Given a file named "examples/property_examples/should_have_property/private_spec.rb" with:
      """ruby
      require 'rspec/sleeping_king_studios/examples/property_examples'

      Value = Struct.new(:value, :type, :default) do
        private :value, :value=, :type, :default=

        def inspect
          '#<Struct>'
        end # method inspect
      end # class

      RSpec.describe Value do
        include RSpec::SleepingKingStudios::Examples::PropertyExamples

        let(:instance) { Value.new }

        # Passing examples.
        include_examples 'should have property', :value, :allow_private => true
        include_examples 'should have property', :type, :allow_private => true
        include_examples 'should have property', :default, :allow_private => true

        # Failing examples.
        include_examples 'should have property', :value, :allow_private => false
        include_examples 'should have property', :type, :allow_private => false
        include_examples 'should have property', :default, :allow_private => false
      end # describe
      """
    When I run `rspec examples/property_examples/should_have_property/private_spec.rb`
    Then the output should contain "6 examples, 3 failures"
    Then the output should contain "expected #<Struct> to respond to :value and :value=, but did not respond to :value or :value="
    Then the output should contain "expected #<Struct> to respond to :type and :type=, but did not respond to :type"
    Then the output should contain "expected #<Struct> to respond to :default and :default=, but did not respond to :default="
