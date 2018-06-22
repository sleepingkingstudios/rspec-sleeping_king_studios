Feature: `ExampleConstants` concern
  Use the `example_constant` class method to define a temporary constant scoped
  to your examples.

  ```ruby
  example_constant :ExampleString, 'an example string'
  ```

  You can define a constant within a namespace by giving `example_constant` a
  qualified name.

  ```ruby
  example_constant 'Spec::Constants::ExampleString', 'an example string'
  ```

  You can also define a constant using the block syntax. This allows you to
  reference other example-scoped values, such as values defined using `let`.

  ```ruby
  let(:example_value) { 'example value' }

  example_constant :ExampleStruct do
    Struct.new(:value).new(example_value)
  end
  ```

  Scenario: defining an example constant
    Given a file named "example_constants/example_constant.rb" with:
      """ruby
      require 'rspec/sleeping_king_studios/concerns/example_constants'

      RSpec.describe RSpec::SleepingKingStudios::Concerns::ExampleConstants do
        extend RSpec::SleepingKingStudios::Concerns::ExampleConstants

        it 'should raise an error' do
          expect { THE_ANSWER }.to raise_error NameError
        end

        context 'when an example constant has been set' do
          example_constant :THE_ANSWER, 42

          it { expect(THE_ANSWER).to be 42 }
        end
      end
      """
    When I run `rspec example_constants/example_constant.rb`
    Then the output should contain "2 examples, 0 failures"

  Scenario: defining an example constant within a namespace
    Given a file named "example_constants/example_constant_within_namespace.rb" with:
      """ruby
      require 'rspec/sleeping_king_studios/concerns/example_constants'

      module Spec
        module Constants; end
      end

      RSpec.describe RSpec::SleepingKingStudios::Concerns::ExampleConstants do
        extend RSpec::SleepingKingStudios::Concerns::ExampleConstants

        it 'should raise an error' do
          expect { Spec::Constants::THE_ANSWER }.to raise_error NameError
        end

        context 'when an example constant has been set' do
          example_constant 'Spec::Constants::THE_ANSWER', 42

          it { expect(Spec::Constants::THE_ANSWER).to be 42 }
        end
      end
      """
    When I run `rspec example_constants/example_constant_within_namespace.rb`
    Then the output should contain "2 examples, 0 failures"

  Scenario: defining an example constant with the block syntax
    Given a file named "example_constants/example_constant_with_block.rb" with:
      """ruby
      require 'rspec/sleeping_king_studios/concerns/example_constants'

      RSpec.describe RSpec::SleepingKingStudios::Concerns::ExampleConstants do
        extend RSpec::SleepingKingStudios::Concerns::ExampleConstants

        let(:example_value) { 42 }

        it 'should raise an error' do
          expect { THE_ANSWER }.to raise_error NameError
        end

        context 'when an example constant has been set' do
          example_constant :THE_ANSWER do
            Struct.new(:value).new(example_value)
          end

          it { expect(THE_ANSWER).to be_a Struct }

          it { expect(THE_ANSWER.value).to be == example_value }
        end
      end
      """
    When I run `rspec example_constants/example_constant_with_block.rb`
    Then the output should contain "3 examples, 0 failures"
