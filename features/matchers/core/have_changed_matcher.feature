Feature: `have_changed` matcher
  Use the `have_changed` matcher to specify that a watched value has changed.
  First, create a value spy with the `watch_value` method.

  ```ruby
  value = watch_value(instance, :foo)

  do_something # May change the value of calling instance#foo.

  expect(value).to have_changed # True if instance#foo has changed, otherwise false.
  ```

  You can also watch the value of a block.

  ```ruby
  value = watch_value { instance.foo }

  do_something # May change the value of calling instance#foo.

  expect(value).to have_changed # True if instance#foo has changed, otherwise false.
  ```

  You can add constraints for the initial or changed values with the `from`,
  `to`, and `by` methods.

  ```ruby
  value = watch_value(instance, :foo)

  do_something # May change the value of calling instance#foo.

  expect(value).to have_changed.from(first_value) # True if instance#foo was initially first_value but has changed to another value.

  expect(value).to have_changed.to(last_value) # True if instance#foo has changed to last_value.

  expect(value).to have_changed.by(2) # True if instance#foo has changed, and the difference between the current and initial values is 2.
  ```

  These method can be combined as well, e.g. `expect(value).to have_changed.from
  (initial_value).to(final_value)`. Note that the `from` and `by` methods are
  not supported for negated expectations, e.g.
  `expect().not_to have_changed.from` will raise an error. Likewise, the `by`
  method will raise an error unless the current value responds to `-`, i.e.
  subtraction.

  Finally, make sure to initialize your spy before running whatever code is
  expected to change the value. In particular, if you define the spy in a let()
  block, it is recommended to use the imperative let!() to ensure the spy is
  created before the example starts.

  Scenario: basic usage
    Given a file named "matchers/core/have_changed_matcher/basics_spec.rb" with:
      """ruby
      require 'rspec/sleeping_king_studios/matchers/core/have_changed'

      RSpec.describe 'have_changed' do
        let(:object) { Struct.new(:value).new('initial value') }

        # Passing expectations.
        it 'should update the value' do
          value = watch_value(object, :value)

          object.value = 'new value'

          expect(value).to have_changed
        end

        it 'should update the value' do
          value = watch_value { object.value }

          object.value = 'new value'

          expect(value).to have_changed
        end

        it 'should not update the value' do
          value = watch_value(object, :value)

          expect(value).not_to have_changed
        end

        it 'should not update the value' do
          value = watch_value { object.value }

          expect(value).not_to have_changed
        end

        # Failing expectations.
        it 'should update the value' do
          value = watch_value(object, :value)

          expect(value).to have_changed
        end

        it 'should update the value' do
          value = watch_value { object.value }

          expect(value).to have_changed
        end

        it 'should not update the value' do
          value = watch_value(object, :value)

          object.value = 'new value'

          expect(value).not_to have_changed
        end

        it 'should not update the value' do
          value = watch_value { object.value }

          object.value = 'new value'

          expect(value).not_to have_changed
        end
      end
      """
    When I run `rspec matchers/core/have_changed_matcher/basics_spec.rb`
    Then the output should contain "8 examples, 4 failures"
    Then the output should contain:
      """
           Failure/Error: expect(value).to have_changed
             expected #value to have changed, but is still "initial value"
      """
    Then the output should contain:
      """
           Failure/Error: expect(value).not_to have_changed
             expected #value not to have changed, but did change from "initial value" to "new value"
      """
    Then the output should contain:
      """
           Failure/Error: expect(value).to have_changed
             expected result to have changed, but is still "initial value"
      """
    Then the output should contain:
      """
           Failure/Error: expect(value).not_to have_changed
             expected result not to have changed, but did change from "initial value" to "new value"
      """

  Scenario: from value
    Given a file named "matchers/core/have_changed_matcher/from_spec.rb" with:
      """ruby
      require 'rspec/sleeping_king_studios/matchers/core/have_changed'

      RSpec.describe 'have_changed' do
        let(:object) { Struct.new(:value).new('initial value') }

        # Passing expectations.
        it 'should update the value' do
          value = watch_value(object, :value)

          object.value = 'new value'

          expect(value).to have_changed.from('initial value')
        end

        it 'should not update the value' do
          value = watch_value(object, :value)

          expect(value).not_to have_changed.from('initial value')
        end

        # Failing expectations.
        it 'should update the value' do
          value = watch_value(object, :value)

          expect(value).to have_changed.from('initial value')
        end

        it 'should update the value' do
          value = watch_value(object, :value)

          object.value = 'new value'

          expect(value).to have_changed.from('other value')
        end

        it 'should not update the value' do
          value = watch_value(object, :value)

          object.value = 'new value'

          expect(value).not_to have_changed.from('initial value')
        end

        it 'should not update the value' do
          value = watch_value(object, :value)

          expect(value).not_to have_changed.from('other value')
        end
      end
      """
    When I run `rspec matchers/core/have_changed_matcher/from_spec.rb`
    Then the output should contain "6 examples, 4 failures"
    Then the output should contain:
      """
           Failure/Error: expect(value).to have_changed.from('initial value')
             expected #value to have changed, but is still "initial value"
      """
    Then the output should contain:
      """
           Failure/Error: expect(value).to have_changed.from('other value')
             expected #value to have initially been "other value", but was "initial value"
      """
    Then the output should contain:
      """
           Failure/Error: expect(value).not_to have_changed.from('initial value')
             expected #value not to have changed, but did change from "initial value" to "new value"
      """
    Then the output should contain:
      """
           Failure/Error: expect(value).not_to have_changed.from('other value')
             expected #value to have initially been "other value", but was "initial value"
      """

  Scenario: to value
    Given a file named "matchers/core/have_changed_matcher/to_spec.rb" with:
      """ruby
      require 'rspec/sleeping_king_studios/matchers/core/have_changed'

      RSpec.describe 'have_changed' do
        let(:object) { Struct.new(:value).new('initial value') }

        # Passing expectations.
        it 'should update the value' do
          value = watch_value(object, :value)

          object.value = 'new value'

          expect(value).to have_changed.to('new value')
        end

        # Failing expectations.
        it 'should update the value' do
          value = watch_value(object, :value)

          expect(value).to have_changed.to('new value')
        end

        it 'should update the value' do
          value = watch_value(object, :value)

          object.value = 'new value'

          expect(value).to have_changed.to('other value')
        end

        it 'should not update the value' do
          value = watch_value(object, :value)

          expect(value).not_to have_changed.to('new value')
        end
      end
      """
    When I run `rspec matchers/core/have_changed_matcher/to_spec.rb`
    Then the output should contain "4 examples, 3 failures"
    Then the output should contain:
      """
           Failure/Error: expect(value).to have_changed.to('new value')
             expected #value to have changed to "new value", but is still "initial value"
      """
    Then the output should contain:
      """
           Failure/Error: expect(value).to have_changed.to('other value')
             expected #value to have changed to "other value", but is now "new value"
      """
    Then the output should contain:
      """
           Failure/Error: expect(value).not_to have_changed.to('new value')

           NotImplementedError:
             `expect().not_to have_changed().to()` is not supported
      """

  Scenario: by difference
    Given a file named "matchers/core/have_changed_matcher/by_spec.rb" with:
      """ruby
      require 'rspec/sleeping_king_studios/matchers/core/have_changed'

      RSpec.describe 'have_changed' do
        let(:object) { Struct.new(:value).new(10) }

        # Passing expectations.
        it 'should update the value' do
          value = watch_value(object, :value)

          object.value = 15

          expect(value).to have_changed.by(5)
        end

        # Failing expectations.
        it 'should update the value' do
          value = watch_value(object, :value)

          expect(value).to have_changed.by(5)
        end

        it 'should update the value' do
          value = watch_value(object, :value)

          object.value = 20

          expect(value).to have_changed.by(5)
        end

        it 'should not update the value' do
          value = watch_value(object, :value)

          expect(value).not_to have_changed.by(5)
        end
      end
      """
    When I run `rspec matchers/core/have_changed_matcher/by_spec.rb`
    Then the output should contain "4 examples, 3 failures"
    Then the output should contain:
      """
           Failure/Error: expect(value).to have_changed.by(5)
             expected #value to have changed by 5, but is still 10
      """
    Then the output should contain:
      """
           Failure/Error: expect(value).to have_changed.by(5)
             expected #value to have changed by 5, but was changed by 10
      """
    Then the output should contain:
      """
           Failure/Error: expect(value).not_to have_changed.by(5)

           NotImplementedError:
             `expect().not_to have_changed().by()` is not supported
      """
