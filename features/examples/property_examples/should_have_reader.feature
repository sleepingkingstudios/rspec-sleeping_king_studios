# features/examples/property_examples/should_have_reader.feature

Feature: `PropertyExamples` shared examples
  Use the `'should have reader'` shared example as a shorthand for specifying
  a reader expectation on an object:

  ```ruby
  include_examples 'should have reader', :foo # True if subject or instance responds to #foo, otherwise false.
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
  include_examples 'should have reader', :foo, 42 # True if instance.foo == 42, otherwise false.

  include_examples 'should have reader', :foo, ->() { 6 * 7 } # True if instance.foo == 42, otherwise false.

  include_examples 'should have reader', :foo, ->(obj) { obj.even? } # True if instance.foo.even?, otherwise

  include_examples 'should have reader', :foo, ->() { an_instance_of Integer } # True if instance.foo.is_a?(Integer), otherwise false.
  ```

  You can also use negated form, `'should not have reader'`, which does not
  permit a value expectation:

  ```ruby
  include_examples 'should not have reader', :foo # True if subject or instance does not respond to #foo, otherwise false.
  ```

  If the :allow_private option is set, the examples will also match a private
  reader method.

  ```ruby
  include_examples 'should have reader', :foo, :allow_private => true # True if instance defines a #foo method, regardless of whether #foo is public, protected, or private.

  include_examples 'should have reader', :foo, 42, :allow_private => true # True if instance.send(:foo) == 42.

  include_examples 'should not have reader', :foo, :allow_private => true # True if instance does not define a #foo method, regardless of whether #foo is public, protected, or private.
  ```

  Internally, the shared examples use the `have_reader` matcher defined at
  RSpec::SleepingKingStudios::Matchers::Core::HaveReader.

  Scenario: basic usage
    Given a file named "examples/property_examples/should_have_reader/basic_spec.rb" with:
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
        include_examples 'should have reader', :value

        include_examples 'should have reader', :type

        include_examples 'should not have reader', :old_value

        include_examples 'should not have reader', :raw_value

        # Failing examples.
        include_examples 'should have reader', :old_value

        include_examples 'should have reader', :raw_value

        include_examples 'should not have reader', :value

        include_examples 'should not have reader', :type
        end # describe
      """
    When I run `rspec examples/property_examples/should_have_reader/basic_spec.rb`
    Then the output should contain "8 examples, 4 failures"
    Then the output should contain "expected #<struct Value value=nil> to respond to :old_value, but did not respond to :old_value"
    Then the output should contain "expected #<struct Value value=nil> to respond to :raw_value, but did not respond to :raw_value"
    Then the output should contain "expected #<struct Value value=nil> not to respond to :value, but responded to :value"
    Then the output should contain "expected #<struct Value value=nil> not to respond to :type, but responded to :type"

  Scenario: value expectations
    Given a file named "examples/property_examples/should_have_reader/values_spec.rb" with:
      """ruby
      require 'rspec/sleeping_king_studios/examples/property_examples'

      Movie = Struct.new(:title, :release_date)

      RSpec.describe Movie do
        include RSpec::SleepingKingStudios::Examples::PropertyExamples

        let(:the_eighties) { 1980...1990 }
        let(:instance)     { Movie.new 'Tron', 1982 }

        # Passing examples.
        include_examples 'should have reader', :title, 'Tron'

        include_examples 'should have reader', :title, ->() { be_a(String) }

        include_examples 'should have reader', :release_date, ->(year) { the_eighties.cover?(year) }

        # Failing examples.
        include_examples 'should have reader', :name, 'Tron'

        include_examples 'should have reader', :title, 'Space Paranoids'

        include_examples 'should have reader', :title, ->() { start_with('X') }

        include_examples 'should have reader', :release_date, ->(year) { year > 1989 }
        end # describe
      """
    When I run `rspec examples/property_examples/should_have_reader/values_spec.rb`
    Then the output should contain "7 examples, 4 failures"
    Then the output should contain consecutive lines:
      | expected #<struct Movie title="Tron", release_date=1982> to respond to :name and return "Tron", but did not respond to :name |
    Then the output should contain consecutive lines:
      | expected #<struct Movie title="Tron", release_date=1982> to respond to :title and return "Space Paranoids", but returned "Tron" |
    Then the output should contain consecutive lines:
      | expected #<struct Movie title="Tron", release_date=1982> to respond to :title and return start with "X", but returned "Tron" |
    Then the output should contain consecutive lines:
      | expected #<struct Movie title="Tron", release_date=1982> to respond to :release_date and return satisfy <%= Spec::RSPEC_VERSION < '3.6.0' ? 'block' : 'expression `object_tools.apply self, expected_value, actual_value`' %>, but returned 1982 |

  Scenario: private readers
    Given a file named "examples/property_examples/should_have_reader/private_spec.rb" with:
      """ruby
      require 'rspec/sleeping_king_studios/examples/property_examples'

      Value = Struct.new(:value) do
        private :value

        def inspect
          '#<Struct>'
        end # method inspect
      end # class

      RSpec.describe Value do
        include RSpec::SleepingKingStudios::Examples::PropertyExamples

        let(:value)    { 'To strive, to seek, to find, and not to yield.' }
        let(:instance) { Value.new value }

        # Passing examples.
        include_examples 'should not have reader', :value, :allow_private => false
        include_examples 'should have reader', :value, :allow_private => true
        include_examples 'should have reader', :value, ->() { be == value }, :allow_private => true

        # Failing examples.
        include_examples 'should have reader', :value, :allow_private => false
        include_examples 'should not have reader', :value, :allow_private => true
        include_examples 'should have reader', :value, ->() { be == value }, :allow_private => false
      end # describe
      """
    When I run `rspec examples/property_examples/should_have_reader/private_spec.rb`
    Then the output should contain "6 examples, 3 failures"
    Then the output should contain "expected #<Struct> to respond to :value, but did not respond to :value"
    Then the output should contain "expected #<Struct> not to respond to :value, but responded to :value"
    Then the output should contain "expected #<Struct> to respond to :value and return be == To strive, to seek, to find, and not to yield., but did not respond to :value"
