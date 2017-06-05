# features/concerns/wrap_env.feature
@focus
Feature: `WrapEnv` concern
  Use the `WrapEnv` concern to safely stub environment variables, either at the
  example level or as a block within an example.

  Scenario: basic usage
    Given a file named "wrap_env.rb" with:
      """ruby
        require 'rspec/sleeping_king_studios/concerns/wrap_env'

        RSpec.describe 'environment' do
          include RSpec::SleepingKingStudios::Concerns::WrapEnv

          it { expect(ENV['VAR_NAME']).to be nil }

          context 'when the variable is set in the example group' do
            wrap_env 'VAR_NAME', 'custom_value'

            it { expect(ENV['VAR_NAME']).to be == 'custom_value' }
          end # context

          context 'when the variable is set in the example group with a block' do
            let(:calculated_value) { 'calculated_value' }

            wrap_env('VAR_NAME') { calculated_value }

            it { expect(ENV['VAR_NAME']).to be == calculated_value }
          end # context

          context 'when the variable is set inside an example' do
            it 'should set the variable' do
              expect(ENV['VAR_NAME']).to be nil

              begin
                wrap_env('VAR_NAME', 'new_value') do
                  expect(ENV['VAR_NAME']).to be == 'new_value'

                  raise RuntimeError, 'must handle errors and reset the var'
                end # wrap_env
              rescue RuntimeError
              end # begin-rescue

              expect(ENV['VAR_NAME']).to be nil
            end # it
          end # context
        end # describe
      """
    When I run `rspec wrap_env.rb`
    Then the output should contain "4 examples, 0 failures"
