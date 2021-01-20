# features/concerns/toolbelt.feature

Feature: `Toolbelt` concern
  Use the `Toolbelt` concern to expose an instance of
  SleepingKingStudios::Tools::Toolbelt, which defines helper methods for common
  use cases around core objects.

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
                tools.str.singularize(label)
              else
                tools.str.pluralize(label)
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
