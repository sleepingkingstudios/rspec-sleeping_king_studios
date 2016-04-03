# features/matchers/core/alias_method_matcher.feature

Feature: `alias_method` matcher
  Use the `alias_method` matcher to specify that an object must alias a method
  with the specified name.

  ```ruby
  expect(instance).to alias_method(:old_method).as(:new_method) # True if instance#old_method and instance#new_method are the same method, otherwise false.
  ```

  Scenario: basic usage
    Given a file named "alias_method_matcher_spec.rb" with:
      """ruby
        require 'rspec/sleeping_king_studios/matchers/core/alias_method'

        RSpec.describe Array do
          let(:instance) { [] }

          # Passing expectations.
          it { expect(instance).to alias_method(:inject).as(:reduce) }
          it { expect(instance).not_to alias_method(:wibble).as(:wobble) }
          it { expect(instance).not_to alias_method(:inject).as(:wobble) }
          it { expect(instance).not_to alias_method(:inject).as(:reject) }

          # Failing expectations.
          it { expect(instance).not_to alias_method(:inject).as(:reduce) }
          it { expect(instance).to alias_method(:wibble).as(:wobble) }
          it { expect(instance).to alias_method(:inject).as(:wobble) }
          it { expect(instance).to alias_method(:inject).as(:reject) }
        end # describe
      """
    When I run `rspec alias_method_matcher_spec.rb`
    Then the output should contain "8 examples, 4 failures"
    Then the output should contain consecutive lines:
      | Failure/Error: it { expect(instance).not_to alias_method(:inject).as(:reduce) } |
      |   expected [] not to alias :inject as :reduce |
    Then the output should contain consecutive lines:
      | Failure/Error: it { expect(instance).to alias_method(:wibble).as(:wobble) } |
      |   expected [] to alias :wibble as :wobble, but did not respond to :wibble |
    Then the output should contain consecutive lines:
      | Failure/Error: it { expect(instance).to alias_method(:inject).as(:wobble) } |
      |   expected [] to alias :inject as :wobble, but did not respond to :wobble |
    Then the output should contain consecutive lines:
      | Failure/Error: it { expect(instance).to alias_method(:inject).as(:reject) } |
      |   expected [] to alias :inject as :reject, but :inject and :reject are different methods |
