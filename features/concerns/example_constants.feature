# features/concerns/example_constants.feature

Feature: `ExampleConstants` concern
  Use the `ExampleConstants` concern to define temporary classes and constants
  scoped to your examples.

  Scenario: defining constants
    Given a file named "example_constants.rb" with:
      """ruby
        require 'rspec/sleeping_king_studios/concerns/example_constants'

        module Spec
          module Constants; end
        end # module

        RSpec.describe 'constants' do
          extend RSpec::SleepingKingStudios::Concerns::ExampleConstants

          it 'should raise an error' do
            expect { THE_ANSWER }.to raise_error NameError
          end # it

          context 'when an example constant has been set' do
            example_constant :THE_ANSWER, 42

            it { expect(THE_ANSWER).to be 42 }
          end # context

          context 'when an example constant with a namespace has been set' do
            example_constant 'Spec::Constants::THE_ANSWER', 42

            it { expect(Spec::Constants::THE_ANSWER).to be 42 }
          end # context
        end # describe
      """
    When I run `rspec example_constants.rb`
    Then the output should contain "3 examples, 0 failures"

  Scenario: defining classes
    Given a file named "example_classes.rb" with:
      """ruby
        require 'rspec/sleeping_king_studios/concerns/example_constants'

        module Spec
          module Constants; end
        end # module

        RSpec.describe 'classes' do
          extend RSpec::SleepingKingStudios::Concerns::ExampleConstants

          it 'should raise an error' do
            expect { Spec::Constants::ExampleClass }.to raise_error NameError
          end # it

          context 'when an example class has been defined' do
            example_class 'Spec::Constants::ExampleClass' do |klass|
              klass.send(:define_method, :to_s) do
                "I'm an instance of the example class!"
              end # define method
            end # example class

            it 'should be the defined class' do
              klass = Spec::Constants::ExampleClass

              expect(klass.name).to be == 'Spec::Constants::ExampleClass'
            end # it

            it 'should define the method from the block' do
              instance = Spec::Constants::ExampleClass.new

              expect(instance.to_s).
                to be == "I'm an instance of the example class!"
            end # it

            context 'when an example class has been defined with a base class' do
              example_class 'Spec::Constants::ExampleSubclass',
                :base_class => 'Spec::Constants::ExampleClass'

              it 'should be the defined subclass' do
                klass = Spec::Constants::ExampleClass

                expect(klass.name).to be == 'Spec::Constants::ExampleClass'
              end # it
            end # context
          end # context
        end # describe
      """
    When I run `rspec example_classes.rb`
    Then the output should contain "4 examples, 0 failures"
