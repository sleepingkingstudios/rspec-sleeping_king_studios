# features/examples/property_examples.feature

Feature: `PropertyExamples` shared examples
  Use the `PropertyExamples` shared examples as a shorthand for specifying a
  reader, writer, or property expectation on an object:

  ```ruby
  include_examples 'should have reader', :foo # True if subject or instance responds to #foo, otherwise false.

  include_examples 'should have writer', :bar # True if subject or instance responds to #bar=, otherwise false.

  include_examples 'should have property', :baz # True if subject or instance responds to #baz and #baz=, otherwise false.
  ```

  In accordance with RSpec::SleepingKingStudios conventions, these examples
  preferentially use the value defined in `instance`, e.g.
  `let(:instance) { MyObject.new }`. To maximize compatibility, they will fall
  back to the RSpec built-in `subject` helper.

  You can also specify a value for the reader or property, either as a direct
  value or as a proc. Note that the direct value is evaluated when including
  the shared example group, and does not have access to any memoized helpers.
  The proc value is evaluated when running the example, and does have access to
  memoized helpers. It can optionally take the instance or subject as the first
  parameter. The proc can return true or false, can return a value to compare
  the actual value with, or can return an RSpec matcher to evaluate against the
  actual value of `instance.foo` or `subject.foo`.

  ```ruby
  include_examples 'should have reader', :foo, 42 # True if instance.foo == 42, otherwise false.

  include_examples 'should have property', :foo, ->() { 6 * 7 } # True if instance.foo == 42, otherwise false.

  include_examples 'should have reader', :foo, ->(obj) { obj.even? } # True if instance.foo.even?, otherwise false.

  include_examples 'should have property', :foo, ->() { an_instance_of Fixnum } # True if instance.foo.is_a?(Fixnum), otherwise false.
  ```

  Internally, these shared examples use the `have_reader`, `have_writer` and
  `have_property` matchers defined by RSpec::SleepingKingStudios.

  Scenario: basic usage
    Given a file named "poem_spec.rb" with:
      """ruby
      require 'rspec/sleeping_king_studios/examples/property_examples'

      class Poem
        def initialize author, title, text
          @author = author
          @title  = title
          @text   = text
        end # constructor

        attr_reader :author

        attr_writer :title

        attr_accessor :text
      end # class

      RSpec.describe 'Ulysses' do
        include RSpec::SleepingKingStudios::Examples::PropertyExamples

        let(:author) { 'Alfred, Lord Tennyson' }
        let(:stanza) do
          <<-POETRY
Tho' much is taken, much abides; and tho'
We are not now that strength which in old days
Moved earth and heaven, that which we are, we are;
One equal temper of heroic hearts,
Made weak by time and fate, but strong in will
To strive, to seek, to find, and not to yield.
          POETRY
        end # let
        let(:instance) do
          Poem.new author, 'Ulysses', stanza
        end # let

        include_examples 'should have reader', :author

        include_examples 'should have reader', :author, 'Alfred, Lord Tennyson'

        include_examples 'should have reader', :author, ->() { be_a String }

        include_examples 'should have writer', :title

        include_examples 'should have property', :text

        include_examples 'should have property', :text, ->(text) { text.length > 128 }

        include_examples 'should have property', :text, ->() { be == stanza }
      end # describe
      """
    When I run `rspec poem_spec.rb`
    Then the output should contain "10 examples, 0 failures"
