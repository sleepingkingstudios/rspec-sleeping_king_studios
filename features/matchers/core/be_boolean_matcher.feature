# features/matchers/core/be_boolean_matcher.feature

Feature: `be_boolean` matcher
  Use the `be_boolean` matcher to specify that a value must be either true or
  false:

  ```ruby
  expect(true).to be_boolean # True.

  expect(false).to be_boolean # True.

  expect('a String').to be_boolean # False.

  expect(nil).to be_boolean # False.
  ```

  Scenario: basic usage
    Given a file named "be_boolean_matcher_spec.rb" with:
      """ruby
        require 'rspec/sleeping_king_studios/matchers/core/be_boolean'

        RSpec.describe "Boolean values" do
          # Passing expectations.
          it { expect(true).to be_boolean }
          it { expect(false).to be_boolean }
          it { expect('a String').not_to be_boolean }
          it { expect(nil).not_to be_boolean }

          # Failing expectations.
          it { expect(true).not_to be_boolean }
          it { expect(false).not_to be_boolean }
          it { expect('a String').to be_boolean }
          it { expect(nil).to be_boolean }
        end # describe
      """
    When I run `rspec be_boolean_matcher_spec.rb`
    Then the output should contain "8 examples, 4 failures"
    Then the output should contain:
      """
           Failure/Error: it { expect(true).not_to be_boolean }
             expected true not to be true or false
      """
    Then the output should contain:
      """
           Failure/Error: it { expect(false).not_to be_boolean }
             expected false not to be true or false
      """
    Then the output should contain:
      """
           Failure/Error: it { expect('a String').to be_boolean }
             expected "a String" to be true or false
      """
    Then the output should contain:
      """
           Failure/Error: it { expect(nil).to be_boolean }
             expected nil to be true or false
      """
