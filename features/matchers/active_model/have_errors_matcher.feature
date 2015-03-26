# features/matchers/active_model/have_errors_matcher.feature

Feature: `have_errors` matcher
  Use the `have_errors` matcher to specify error message behavior for objects
  that implement `ActiveModel`-compatible validations. In its most basic form:

  ```ruby
  expect(instance).to have_errors # => Passes if instance.errors is not empty, otherwise fails.
  ```

  You can specify a property (or more generally, a key in `instance.errors`)
  with the `on` method. If a property or key is specified, the matcher will
  only check for errors matching that key.

  In addition, you can specify one or more error messages for the specified
  property or error key with the `with_message` or `with_messages` methods.

  ```ruby
  expect(instance).to have_errors.on(:property_name) # Passes if instance.errors[:property_name] is not empty, otherwise fails.

  expect(instance).to have_errors.on(:property_name).with_message("can't be blank")

  expect(instance).to have_errors.on(:property_name).with_messages("can't be blank", 'is not a number')
  ```

  Scenario: basic usage
    Given a file with a model class definition
    Given a file named "have_errors_matcher_spec.rb" with:
      """ruby
      require_relative './model'

      require 'rspec/sleeping_king_studios/matchers/active_model/have_errors'

      RSpec.describe Model do
        let(:attributes) { {} }
        let(:instance)   { described_class.new attributes }

        # Passing expectations.
        it { expect(instance).to have_errors }

        context 'with a value' do
          let(:attributes) { super().merge :value => 'value' }

          it { expect(instance).not_to have_errors }
        end # context

        # Failing expectations.
        it { expect(instance).not_to have_errors }

        context 'with a value' do
          let(:attributes) { super().merge :value => 'value' }

          it { expect(instance).to have_errors }
        end # context
      end # describe
      """
    When I run `rspec have_errors_matcher_spec.rb`
    Then the output should contain "4 examples, 2 failures"
    Then the output should contain:
      """
           Failure/Error: it { expect(instance).not_to have_errors }
             expected an invalid model not to have errors
               received errors:
                 value: "can't be blank"
      """
    Then the output should contain:
      """
           Failure/Error: it { expect(instance).to have_errors }
             expected a valid model to have errors
      """

  Scenario: with a property using `#on`
    Given a file with a model class definition
    Given a file named "have_errors_matcher_spec.rb" with:
      """ruby
      require_relative './model'

      require 'rspec/sleeping_king_studios/matchers/active_model/have_errors'

      RSpec.describe Model do
        let(:attributes) { {} }
        let(:instance)   { described_class.new attributes }

        # Passing expectations.
        it { expect(instance).to have_errors.on(:value) }
        it { expect(instance).not_to have_errors.on(:other_property) }

        context 'with a value' do
          let(:attributes) { super().merge :value => 'value' }

          it { expect(instance).not_to have_errors.on(:value) }
          it { expect(instance).not_to have_errors.on(:other_property) }
        end # context

        # Failing expectations.
        it { expect(instance).not_to have_errors.on(:value) }
        it { expect(instance).to have_errors.on(:other_property) }

        context 'with a value' do
          let(:attributes) { super().merge :value => 'value' }

          it { expect(instance).to have_errors.on(:value) }
          it { expect(instance).to have_errors.on(:other_property) }
        end # context
      end # describe
      """
    When I run `rspec have_errors_matcher_spec.rb`
    Then the output should contain "8 examples, 4 failures"
    Then the output should contain:
      """
           Failure/Error: it { expect(instance).not_to have_errors.on(:value) }
             expected an invalid model not to have errors
               expected errors:
                 value: (none)
               received errors:
                 value: "can't be blank"
      """
    Then the output should contain:
      """
           Failure/Error: it { expect(instance).to have_errors.on(:other_property) }
             expected an invalid model to have errors
               expected errors:
                 other_property: (any)
               received errors:
                 value: "can't be blank"
      """
    Then the output should contain:
      """
           Failure/Error: it { expect(instance).to have_errors.on(:value) }
             expected a valid model to have errors
               expected errors:
                 value: (any)
               received errors:
                 (none)
      """
    Then the output should contain:
      """
           Failure/Error: it { expect(instance).to have_errors.on(:other_property) }
             expected a valid model to have errors
               expected errors:
                 other_property: (any)
               received errors:
                 (none)
      """

  Scenario: with a property and error messages using `on.with_message`
    Given a file with a model class definition
    Given a file named "have_errors_matcher_spec.rb" with:
      """ruby
      require_relative './model'

      require 'rspec/sleeping_king_studios/matchers/active_model/have_errors'

      RSpec.describe Model do
        let(:attributes) { {} }
        let(:instance)   { described_class.new attributes }

        # Passing expectations.
        it { expect(instance).to have_errors.on(:value).with_message("can't be blank") }
        it { expect(instance).not_to have_errors.on(:value).with_message("must be an integer") }

        context 'with a value' do
          let(:attributes) { super().merge :value => 'value' }

          it { expect(instance).not_to have_errors.on(:value).with_message("can't be blank") }
          it { expect(instance).not_to have_errors.on(:value).with_message("must be an integer") }
        end # context

        # Failing expectations.
        it { expect(instance).not_to have_errors.on(:value).with_message("can't be blank") }
        it { expect(instance).to have_errors.on(:value).with_message("must be an integer") }

        context 'with a value' do
          let(:attributes) { super().merge :value => 'value' }

          it { expect(instance).to have_errors.on(:value).with_message("can't be blank") }
          it { expect(instance).to have_errors.on(:value).with_message("must be an integer") }
        end # context
      end # describe
      """
    When I run `rspec have_errors_matcher_spec.rb`
    Then the output should contain "8 examples, 4 failures"
    Then the output should contain:
      """
           Failure/Error: it { expect(instance).not_to have_errors.on(:value).with_message("can't be blank") }
             expected an invalid model not to have errors
               expected errors:
                 value: "can't be blank"
               received errors:
                 value: "can't be blank"
      """
    Then the output should contain:
      """
           Failure/Error: it { expect(instance).to have_errors.on(:value).with_message("must be an integer") }
             expected an invalid model to have errors
               expected errors:
                 value: "must be an integer"
               received errors:
                 value: "can't be blank"
      """
    Then the output should contain:
      """
           Failure/Error: it { expect(instance).to have_errors.on(:value).with_message("can't be blank") }
             expected a valid model to have errors
               expected errors:
                 value: "can't be blank"
               received errors:
                 (none)
      """
