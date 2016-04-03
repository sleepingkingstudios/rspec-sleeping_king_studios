# features/examples/rspec_matcher_examples.feature

Feature: `RSpecMatcherExamples` shared examples
  Use the RSpecMatcherExamples shared examples for specifying the behavior of
  a custom RSpec matcher. To use the examples, define both a matcher (using
  `subject` or `let(:instance) {}`) and an actual value to test the matcher
  against (using `let(:actual)`):

  ```ruby
  let(:instance) { be true }

  describe 'with true' do
    let(:actual) { true }

    include_examples 'should pass with a positive expectation' # True if expect(true).to be true passes, otherwise false.
  end # describe

  describe 'with false' do
    let(:actual) { false }

    include_examples 'should pass with a negative expectation' # True if expect(false).not_to be true passes, otherwise false.
  end # describe

  ```

  RSpec::SleepingKingStudios uses these examples internally to verify the
  functionality of its added and modified matchers.

  When testing that an expectation will fail, the examples expect an additional
  memoized helper specifying the failure message. To specify a failure message
  for a positive expectation, e.g. `expect().to`, define the helper using
  `let(:failure_message)`. To specify a failure message for a negative
  expectation, e.g. `expect().not_to`, define the helper using
  `let(:failure_message_when_negated)`:

  ```ruby
  let(:instance) { be true }

  describe 'with false' do
    let(:actual)          { false }
    let(:failure_message) { "expected #<TrueClass:20> => true" }

    include_examples 'should fail with a positive expectation'
  end # describe

  describe 'with true' do
    let(:actual)                       { true }
    let(:failure_message_when_negated) { "expected not #<TrueClass:20> => true" }

    include_examples 'should fail with a negative expectation'
  end # describe
  ```

  The failure message can be a string, a regular expression, or an RSpec
  matcher. If a failure message is not provided, the examples may be marked as
  pending or failed, depending on your configuration settings:

  ```ruby
  RSpec.configure do |config|
    config.sleeping_king_studios do |config|
      config.examples do |config|
        config.handle_missing_failure_message_with = :ignore
      end # config
    end # config
  end # config
  ```

  The valid options are `:ignore`, `:pending` (the default), and `:raise`.

  `:ignore` will not mark examples as pending or failed for missing messages.

  `:pending` is the default value. Any examples where the failure message is
  not defined will be marked as pending, with an appropriate message in the
  formatter to indicate there is missing information.

  `:exception` will raise an exception when the failure message is not defined,
  causing the example to fail.

  Scenario: basic usage
    Given a file named "be_the_answer_matcher_spec.rb" with:
      """ruby
      require 'rspec/sleeping_king_studios/examples/rspec_matcher_examples'

      RSpec::Matchers.define :be_the_answer do
        match do |actual|
          actual == 42
        end # match
      end # define

      RSpec.describe RSpec::Matchers::DSL::Matcher do
        include RSpec::SleepingKingStudios::Examples::RSpecMatcherExamples

        let(:instance) { be_the_answer }

        describe 'with 42' do
          let(:actual)                       { 42 }
          let(:failure_message_when_negated) { 'expected 42 not to be the answer' }

          include_examples 'should pass with a positive expectation'

          include_examples 'should fail with a negative expectation'
        end # describe

        describe 'with "African or European swallow?"' do
          let(:actual)          { 'African or European swallow?' }
          let(:failure_message) { 'expected "African or European swallow?" to be the answer' }

          include_examples 'should pass with a negative expectation'

          include_examples 'should fail with a positive expectation'
        end # describe
      end # describe
      """
    When I run `rspec be_the_answer_matcher_spec.rb`
    Then the output should contain "6 examples, 0 failures"

  Scenario: skipping missing failure messages
    Given a file named "ignore_missing_failure_messages_spec.rb" with:
      """ruby
      require 'rspec/sleeping_king_studios/examples/rspec_matcher_examples'

      RSpec.configure do |config|
        config.sleeping_king_studios do |config|
          config.examples do |config|
            config.handle_missing_failure_message_with = :ignore
          end # config
        end # config
      end # config

      RSpec.describe 'be true' do
        include RSpec::SleepingKingStudios::Examples::RSpecMatcherExamples

        let(:instance) { be true }

        describe 'with true' do
          let(:actual) { true }

          include_examples 'should fail with a negative expectation'
        end # describe
      end # describe
      """
    When I run `rspec ignore_missing_failure_messages_spec.rb`
    Then the output should contain "2 examples, 0 failures"

  Scenario: marking missing failure messages as pending
    Given a file named "pending_missing_failure_messages_spec.rb" with:
      """ruby
      require 'rspec/sleeping_king_studios/examples/rspec_matcher_examples'

      RSpec.configure do |config|
        config.sleeping_king_studios do |config|
          config.examples do |config|
            config.handle_missing_failure_message_with = :pending
          end # config
        end # config
      end # config

      RSpec.describe 'be true' do
        include RSpec::SleepingKingStudios::Examples::RSpecMatcherExamples

        let(:instance) { be true }

        describe 'with true' do
          let(:actual) { true }

          include_examples 'should fail with a negative expectation'
        end # describe
      end # describe
      """
    When I run `rspec pending_missing_failure_messages_spec.rb`
    Then the output should contain "2 examples, 0 failures, 1 pending"
    Then the output should contain:
      """
      expected to match RSpec::Matchers::BuiltIn::Equal#failure_message_when_negated, but the expected value was undefined. Define a failure message using let(:failure_message_when_negated)
      """

  Scenario: marking missing failure messages as failed
    Given a file named "fail_missing_failure_messages_spec.rb" with:
      """ruby
      require 'rspec/sleeping_king_studios/examples/rspec_matcher_examples'

      RSpec.configure do |config|
        config.sleeping_king_studios do |config|
          config.examples do |config|
            config.handle_missing_failure_message_with = :exception
          end # config
        end # config
      end # config

      RSpec.describe 'be true' do
        include RSpec::SleepingKingStudios::Examples::RSpecMatcherExamples

        let(:instance) { be true }

        describe 'with true' do
          let(:actual) { true }

          include_examples 'should fail with a negative expectation'
        end # describe
      end # describe
      """
    When I run `rspec fail_missing_failure_messages_spec.rb`
    Then the output should contain "2 examples, 1 failure"
    Then the output should contain:
      """
      expected to match RSpec::Matchers::BuiltIn::Equal#failure_message_when_negated, but the expected value was undefined. Define a failure message using let(:failure_message_when_negated)
      """
