# features/concerns/wrap_examples.feature

Feature: `WrapExamples` concern
  Use the `WrapExamples` concern to cleanly encapsulate shared functionality
  without writing boilerplate or affecting the containing context.

  ```ruby
  RSpec.describe "a String" do
    include RSpec::SleepingKingStudios::Concerns::WrapExamples

    shared_context 'with an uppercase String' do
      let(:instance) { super().tap &:upcase }
    end # shared_context

    shared_examples 'can be parameterized' do
      let(:instance) { super().parameterize }

      it { expect(instance).to be == 'greetings-programs' }
    end # shared_examples

    let(:instance) { 'Greetings, programs!' }

    it { expect(instance).to be == 'Greetings, programs!' } # Outside the wrapped blocks, the value is unchanged.

    wrap_context 'with an uppercase String' do
      it { expect(instance).to be == 'GREETINGS, PROGRAMS!' } # Inside the wrap_context block, the value is changed.
    end # wrap_context

    wrap_examples 'can be parameterized' # Example groups with side effects do not change the value in the containing context.
  end # describe
  ```

  You can also force the wrapped context or examples to be focused by
  prepending an 'f' character and using `fwrap_examples` or `fwrap_context`,
  in the same fashion as using the `fit` or `fdescribe` methods in lieu of
  `it` and `describe`.

  Scenario: basic usage
    Given a file named "wrapping_examples.rb" with:
      """ruby
        require 'rspec/sleeping_king_studios/concerns/wrap_examples'

        Weapon = Struct.new(:name, :type, :culture)

        RSpec.describe Weapon do
          extend RSpec::SleepingKingStudios::Concerns::WrapExamples

          shared_context 'with a german weapon' do
            let(:weapon) { Weapon.new 'zweihänder', 'sword', 'german' }
          end # shared_context

          shared_examples 'should be japanese' do
            it { expect(weapon.culture).to be == 'japanese' }
          end # shared_examples

          shared_examples 'should be a sword' do
            let(:sword) { weapon }

            it { expect(sword.type).to be == 'sword' }
          end # shared_examples

          let(:weapon) { Weapon.new 'daito', 'sword', 'japanese' }

          describe 'with a shared context' do
            wrap_context 'with a german weapon' do
              it { expect(weapon.culture).to be == 'german' }
            end # context

            # The wrapped context does not affect the outer context, unlike `include_context do...end`.
            it { expect(weapon.culture).to be == 'japanese' }
          end # describe

          describe 'with a shared example group' do
            wrap_examples 'should be japanese'
          end # describe

          describe 'with a shared example group example with side effects' do
            wrap_examples 'should be a sword'

            # Will raise an error because sword is not defined.
            it { expect { expect(sword.culture).to be == 'japanese' }.to raise_error NameError, /undefined local variable or method `sword'/ }
          end # describe
        end # describe
      """
    When I run `rspec wrapping_examples.rb`
    Then the output should contain "5 examples, 0 failures"

  Scenario: wrapping a focused example group
    Given a file named "wrapping_examples.rb" with:
      """ruby
        require 'rspec/sleeping_king_studios/concerns/wrap_examples'

        RSpec.configure do |config|
          # Limit a spec run to individual examples or groups you care about by tagging
          # them with `:focus` metadata.
          config.filter_run :focus
          config.run_all_when_everything_filtered = true
        end # configure

        Weapon = Struct.new(:name, :type, :culture)

        RSpec.describe Weapon do
          extend RSpec::SleepingKingStudios::Concerns::WrapExamples

          shared_context 'with a german weapon' do
            let(:weapon) { Weapon.new 'zweihänder', 'sword', 'german' }
          end # shared_context

          shared_examples 'should be japanese' do
            it { expect(weapon.culture).to be == 'japanese' }
          end # shared_examples

          shared_examples 'should be a sword' do
            let(:sword) { weapon }

            it { expect(sword.type).to be == 'sword' }
          end # shared_examples

          let(:weapon) { Weapon.new 'daito', 'sword', 'japanese' }

          describe 'with a shared context' do
            fwrap_context 'with a german weapon' do
              it { expect(weapon.culture).to be == 'german' }
            end # context

            # The wrapped context does not affect the outer context, unlike `include_context do...end`.
            it { expect(weapon.culture).to be == 'japanese' }
          end # describe

          describe 'with a shared example group' do
            wrap_examples 'should be japanese'
          end # describe

          describe 'with a shared example group example with side effects' do
            fwrap_examples 'should be a sword'

            # Will raise an error because sword is not defined.
            it { expect { expect(sword.culture).to be == 'japanese' }.to raise_error NameError, /undefined local variable or method `sword'/ }
          end # describe
        end # describe
      """
    When I run `rspec wrapping_examples.rb`
    Then the output should contain "2 examples, 0 failures"

  Scenario: wrapping a skipped example group
    Given a file named "wrapping_examples.rb" with:
      """ruby
        require 'rspec/sleeping_king_studios/concerns/wrap_examples'

        RSpec.configure do |config|
          # Limit a spec run to individual examples or groups you care about by tagging
          # them with `:focus` metadata.
          config.filter_run :focus
          config.run_all_when_everything_filtered = true
        end # configure

        Weapon = Struct.new(:name, :type, :culture)

        RSpec.describe Weapon do
          extend RSpec::SleepingKingStudios::Concerns::WrapExamples

          shared_context 'with a german weapon' do
            let(:weapon) { Weapon.new 'zweihänder', 'sword', 'german' }
          end # shared_context

          shared_examples 'should be japanese' do
            it { expect(weapon.culture).to be == 'japanese' }
          end # shared_examples

          shared_examples 'should be a sword' do
            let(:sword) { weapon }

            it { expect(sword.type).to be == 'sword' }
          end # shared_examples

          let(:weapon) { Weapon.new 'daito', 'sword', 'japanese' }

          describe 'with a shared context' do
            xwrap_context 'with a german weapon' do
              it { expect(weapon.culture).to be == 'german' }
            end # context

            # The wrapped context does not affect the outer context, unlike `include_context do...end`.
            it { expect(weapon.culture).to be == 'japanese' }
          end # describe

          describe 'with a shared example group' do
            wrap_examples 'should be japanese'
          end # describe

          describe 'with a shared example group example with side effects' do
            xwrap_examples 'should be a sword'

            # Will raise an error because sword is not defined.
            it { expect { expect(sword.culture).to be == 'japanese' }.to raise_error NameError, /undefined local variable or method `sword'/ }
          end # describe
        end # describe
      """
    When I run `rspec wrapping_examples.rb`
    Then the output should contain "5 examples, 0 failures, 2 pending"
