# features/matchers/built_in/be_kind_of_matcher.feature

Feature: `be_kind_of` matcher
  Use the `be_kind_of` matcher to specify the type of an object.
  RSpec::SleepingKingStudios extends the built-in RSpec `be_kind_of` matcher
  with support for providing an array of potential matching types and with
  support for providing `nil` as a special case to match `nil` objects.

  ```ruby
  expect(instance).to be_a Array # Passes if instance is an array, otherwise fails.

  expect(instance).to be_a [String, Symbol, nil] # Passes if instance is a string, a symbol, or nil.
  ```

  Scenario: basic usage
    Given a file named "be_kind_of_matcher_spec.rb" with:
      """ruby
        require 'rspec/sleeping_king_studios/matchers/built_in/be_kind_of'

        RSpec.describe String do
          let(:instance) { "a String" }

          # Passing expectations.
          it { expect(instance).to be_a String }
          it { expect(instance).not_to be_a Array }

          # Failing expectations.
          it { expect(instance).not_to be_a String }
          it { expect(instance).to be_a Array }
        end # describe
      """
    When I run `rspec be_kind_of_matcher_spec.rb`
    Then the output should contain "4 examples, 2 failures"
    Then the output should contain:
      """
           Failure/Error: it { expect(instance).not_to be_a String }
             expected "a String" not to be a String
      """
    Then the output should contain:
      """
           Failure/Error: it { expect(instance).to be_a Array }
             expected "a String" to be a Array
      """

  Scenario: with an array of types
    Given a file named "be_kind_of_matcher_spec.rb" with:
      """ruby
        require 'rspec/sleeping_king_studios/matchers/built_in/be_kind_of'

        RSpec.describe String do
          let(:instance) { "a String" }

          # Passing expectations.
          it { expect(instance).to be_a [String, Symbol, nil] }
          it { expect(Hash.new).not_to be_a [String, Symbol, nil] }
          it { expect(nil).to be_a [String, Symbol, nil] }

          # Failing expectations.
          it { expect(instance).not_to be_a [String, Symbol, nil] }
          it { expect(Hash.new).to be_a [String, Symbol, nil] }
          it { expect(nil).not_to be_a [String, Symbol, nil] }
        end # describe
      """
    When I run `rspec be_kind_of_matcher_spec.rb`
    Then the output should contain "6 examples, 3 failures"
    Then the output should contain:
      """
           Failure/Error: it { expect(instance).not_to be_a [String, Symbol, nil] }
             expected "a String" not to be a String, Symbol, or nil
      """
    Then the output should contain:
      """
           Failure/Error: it { expect(Hash.new).to be_a [String, Symbol, nil] }
             expected {} to be a String, Symbol, or nil
      """
    Then the output should contain:
      """
           Failure/Error: it { expect(nil).not_to be_a [String, Symbol, nil] }
             expected nil not to be a String, Symbol, or nil
      """
