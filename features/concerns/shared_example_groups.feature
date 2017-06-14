# features/concerns/shared_example_groups.feature

Feature: `SharedExampleGroup` concern
  Use the `SharedExampleGroup` concern to create re-usable modules of shared
  examples and contexts, which can then be included into RSpec example groups
  to share the defined functionality:

  ```ruby
  module MyExamples
    extend RSpec::SleepingKingStudios::Concerns::SharedExampleGroup

    shared_examples 'instance is a String' do
      it { expect(instance).to be_a String }
    end # shared_examples
  end # module

  RSpec.describe "a String" do
    include MyExamples

    include_examples 'instance is a String'
  end # describe
  ```

  By default, the built-in `Module#shared_examples` method will define the
  example group in a global namespace (and, as RSpec is moving away from
  modifying core classes, is a likely target for deprecation). Extend the
  module with the `SharedExampleGroup` concern, and any shared example groups
  will be available only in examples that include the module. This can also
  help to prevent subtle errors caused by multiple example groups with the same
  name. Note that this does *not* currently work with including shared examples
  by metadata.

  In addition, you can create aliases for shared example groups using the
  `alias_shared_examples` or `alias_shared_context` methods:

  ```ruby
  module MyExamples
    extend RSpec::SleepingKingStudios::Concerns::SharedExampleGroup

    shared_examples 'instance is a String' do
      it { expect(instance).to be_a String }
    end # shared_examples

    alias_shared_examples 'should be a String', 'instance is a String'
  end # module
  ```

  Scenario: basic usage
    Given a file named "the_answer_examples.rb" with:
      """ruby
      require 'rspec/sleeping_king_studios/concerns/shared_example_group'

      module TheAnswerExamples
        extend RSpec::SleepingKingStudios::Concerns::SharedExampleGroup

        shared_examples 'is the Answer to Life, The Universe, and Everything' do
          it { expect(the_answer).to be 42 }
        end # shared_examples

        alias_shared_examples 'should be the Answer', 'is the Answer to Life, The Universe, and Everything'
      end # module
      """
    Given a file named "the_answer_spec.rb" with:
      """ruby
      require_relative './the_answer_examples'

      RSpec.describe 'the Answer' do
        include TheAnswerExamples

        describe 'with a lesser number' do
          let(:the_answer) { 13 }

          include_examples 'is the Answer to Life, The Universe, and Everything'

          include_examples 'should be the Answer'
        end # describe

        describe 'with the Answer' do
          let(:the_answer) { 42 }

          include_examples 'is the Answer to Life, The Universe, and Everything'

          include_examples 'should be the Answer'
        end # describe
      end # describe
      """
    When I run `rspec the_answer_spec.rb`
    Then the output should contain "4 examples, 2 failures"
