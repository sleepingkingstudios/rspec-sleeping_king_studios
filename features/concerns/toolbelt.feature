# features/concerns/toolbelt.feature

Feature: `Toolbelt` concern
  Use the `Toolbelt` concern to expose an instance of
  SleepingKingStudios::Tools::Toolbelt, which defines helper methods for common
  use cases around core objects.

  ```ruby
  RSpec.describe "a String" do
    include Rspec::SleepingKingStudios::Concerns::Toolbelt

    shared_examples 'should process' do |string|
      singular = tools.string.singularize(string)
      plural   = tools.string.pluralize(string)

      it "should singularize #{string} to #{singular}" do
        expect(tools.singularize string).to be_a String
      end # it

      it "should pluralize #{string} to #{plural}" do
        expect(tools.pluralize string).to be_a String
      end # it
    end # shared_examples

    include_examples 'should pluralize', 'light'
  end # describe
  ```

  Scenario: basic usage
    Given a file named "toolbelt.rb" with:
      """ruby
        require 'rspec/sleeping_king_studios/concerns/toolbelt'

        RSpec.describe 'counting lights' do
          include RSpec::SleepingKingStudios::Concerns::Toolbelt

          def count_lights count
            str = count.to_s
            str << ' light'
            str << 's' unless count == 1
            str
          end # method count_lights

          shared_examples 'should count' do |count, label|
            label =
              if count == 1
                tools.string.singularize(label)
              else
                tools.string.pluralize(label)
              end # if-else

            let(:expected) do
              "#{count} #{label}"
            end # let

            it "should count #{count} #{label}" do
              expect(count_lights count).to be == expected
            end # it
          end # shared_examples

          describe '#count_lights' do
            describe 'with 1 light' do
              include_examples 'should count', 1, 'light'
            end # describe

            describe 'with 4 lights' do
              include_examples 'should count', 4, 'lights'
            end # describe
          end # describe
        end # describe
      """
    When I run `rspec toolbelt.rb`
    Then the output should contain "2 examples, 0 failures"
