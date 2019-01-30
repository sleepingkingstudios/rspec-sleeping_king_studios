# frozen_string_literals: true

Feature: `be_a_uuid` matcher
  Use the `be_a_uuid` matcher to specify that a value must be a UUID string:

  ```ruby
  expect('00000000-0000-0000-0000-000000000000').to be_a_uuid # True.

  expect('01234567-89ab-cdef-0123-456789abcdef').to be_a_uuid # True.

  expect(nil).to be_a_uuid # False.

  expect('Universally Unique Identifier').to be_a_uuid # False.
  ```

  The matcher is case-insensitive, so the string can include upper and lowercase
  hex digits.

  Scenario: basic usage
    Given a file named "be_a_uuid_matcher_spec.rb" with:
      """ruby
        require 'rspec/sleeping_king_studios/matchers/core/be_a_uuid'

        RSpec.describe "UUIDs" do
          # Passing expectations.
          it { expect('00000000-0000-0000-0000-000000000000').to be_a_uuid }
          it { expect('01234567-89AB-CDEF-0123-456789ABCDEF').to be_a_uuid }
          it { expect('01234567-89ab-cdef-0123-456789abcdef').to be_a_uuid }
          it { expect(nil).not_to be_a_uuid }

          # Failing expectations.
          it { expect('00000000-0000-0000-0000-000000000000').not_to be_a_uuid }
          it { expect(nil).to be_a_uuid }
          it { expect('00000000').to be_a_uuid }
          it { expect('00000000-0000-0000-0000-000000000000-0000').to be_a_uuid }
          it { expect('01234567-89ab-cdef-ghij-klmnopqrstuv').to be_a_uuid }
          it { expect('0123456789abcdef0123456789abcdef----').to be_a_uuid }
        end # describe
      """
    When I run `rspec be_a_uuid_matcher_spec.rb`
    Then the output should contain "10 examples, 6 failures"
    Then the output should contain:
      """
           Failure/Error: it { expect('00000000-0000-0000-0000-000000000000').not_to be_a_uuid }
             expected "00000000-0000-0000-0000-000000000000" not to be a UUID
      """
    Then the output should contain:
      """
           Failure/Error: it { expect(nil).to be_a_uuid }
             expected nil to be a UUID, but was not a String
      """
    Then the output should contain:
      """
           Failure/Error: it { expect('00000000').to be_a_uuid }
             expected "00000000" to be a UUID, but was too short
      """
    Then the output should contain:
      """
           Failure/Error: it { expect('01234567-89ab-cdef-ghij-klmnopqrstuv').to be_a_uuid }
             expected "01234567-89ab-cdef-ghij-klmnopqrstuv" to be a UUID, but has invalid characters
      """
    Then the output should contain:
      """
           Failure/Error: it { expect('0123456789abcdef0123456789abcdef----').to be_a_uuid }
             expected "0123456789abcdef0123456789abcdef----" to be a UUID, but the format is invalid
      """
