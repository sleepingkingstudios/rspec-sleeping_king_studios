# frozen_string_literals: true

Feature: `Contract`
  Use a Contract to define a set of expectations that can be used in an RSpec
  example group.

  Scenario: basic usage
    Given a file named "greet_contract.rb" with:
      """ruby
      require 'rspec/sleeping_king_studios/contract'

      module GreetContract
        extend RSpec::SleepingKingStudios::Contract

        describe '#greet' do
          it { expect(subject).to respond_to(:greet).with(1).argument }

          it { expect(subject.greet 'programs').to be == 'Greetings, programs!' }
        end
      end
      """
    Given a file named "taunt_contract.rb" with:
      """ruby
      require 'rspec/sleeping_king_studios/contract'

      module TauntContract
        extend RSpec::SleepingKingStudios::Contract

        describe '#taunt' do
          it { expect(subject).to respond_to(:taunt) }
        end
      end
      """
    Given a file named "greeter.rb" with:
      """ruby
      class Greeter
        def greet(person)
          "Greetings, #{person}!"
        end
      end
      """
    Given a file named "greeter_spec.rb" with:
      """ruby
      require_relative './greet_contract.rb'
      require_relative './greeter.rb'
      require_relative './taunt_contract.rb'

      RSpec.describe Greeter do
        include GreetContract
        include TauntContract
      end
      """
    When I run `rspec greeter_spec.rb`
    Then the output should contain "3 examples, 1 failure"
    Then the output should contain consecutive lines:
      | 1) Greeter#taunt <%= Spec::RSPEC_VERSION >= '3.9' ? 'is expected to' : 'should' %> respond to #taunt |
