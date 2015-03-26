# features/matchers/built_in/include_matcher.feature

Feature: `include` matcher
  Use the `include` matcher to specify that a collection includes one or more
  objects. RSpec::SleepingKingStudios extends the built-in RSpec `include`
  matcher with support for specifying an additional object expectation in the
  form of a block provided to the matcher. If a block is provided, the matcher
  will determine whether the collection includes an item for which the provided
  block evaluates to true.

  ```ruby
  expect(%w(RSpec Cucumber Jasmine)).to include 'Cucumber'

  expect(%w(RSpec Cucumber Jasmine)).to include { |str| str.length == 5 }
  ```

  Scenario: basic usage
    Given a file named "include_matcher_spec.rb" with:
      """ruby
        require 'rspec/sleeping_king_studios/matchers/built_in/include'

        RSpec.describe Array do
          let(:instance) { [2, 3, 5, 7, 11] }

          # Passing expectations.
          it { expect(instance).to include(5) }
          it { expect(instance).to include(3, 11) }
          it { expect(instance).to include { |i| i.even? } }

          # Failing expectations.
          it { expect(instance).not_to include(7) }
          it { expect(instance).not_to include(3, 11) }
          it { expect(instance).not_to include { |i| i.even? } }
        end # describe
      """
    When I run `rspec include_matcher_spec.rb`
    Then the output should contain "6 examples, 3 failures"
    Then the output should contain:
      """
           Failure/Error: it { expect(instance).not_to include(7) }
             expected [2, 3, 5, 7, 11] not to include 7
      """
    Then the output should contain:
      """
           Failure/Error: it { expect(instance).not_to include(3, 11) }
             expected [2, 3, 5, 7, 11] not to include 3 and 11
      """
    Then the output should contain:
      """
           Failure/Error: it { expect(instance).not_to include { |i| i.even? } }
             expected [2, 3, 5, 7, 11] not to include an item matching the block
      """
