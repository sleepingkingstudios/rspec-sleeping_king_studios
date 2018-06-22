Feature: `ExampleConstants` concern
  Use the `example_class` class method to define a temporary class scoped to
  your examples.

  ```ruby
  example_class :ExampleClass
  ```

  You can define a class within a namespace by giving `example_constant` a
  qualified name.

  ```ruby
  example_class 'Spec::Constants::ExampleClass'
  ```

  You can set the base class for the temporary class with a class or the name of
  a class. By using a class name, you can also set the base class to another
  temporary class.

  ```ruby
  example_class :ExampleClass, base_class: SomeOtherClass

  example_class :ExampleSubclass, base_class: 'ExampleClass'
  ```

  Using the block syntax, you can define properties and methods for the
  temporary class. The temporary class is yielded to the block.

  ```ruby
  example_class 'SomeOtherClass' do |klass|
    klass.define_method :greet do |person = nil|
      "Greetings, #{person || 'programs'}!"
    end
  end
  ```

  Scenario: defining an example class within a namespace
    Given a file named "example_constants/example_class.rb" with:
      """ruby
      require 'rspec/sleeping_king_studios/concerns/example_constants'

      RSpec.describe RSpec::SleepingKingStudios::Concerns::ExampleConstants do
        extend RSpec::SleepingKingStudios::Concerns::ExampleConstants

        it 'should raise an error' do
          expect { ExampleClass }.to raise_error NameError
        end

        context 'when an example constant has been set' do
          example_class :ExampleClass

          it { expect(ExampleClass).to be_a Class }

          it { expect(ExampleClass.name).to be == 'ExampleClass' }

          it { expect(ExampleClass.superclass).to be Object }
        end
      end
      """
    When I run `rspec example_constants/example_class.rb`
    Then the output should contain "4 examples, 0 failures"

  Scenario: defining an example class
    Given a file named "example_constants/example_class_within_namespace.rb" with:
      """ruby
      require 'rspec/sleeping_king_studios/concerns/example_constants'

      module Spec
        module Constants; end
      end

      RSpec.describe RSpec::SleepingKingStudios::Concerns::ExampleConstants do
        extend RSpec::SleepingKingStudios::Concerns::ExampleConstants

        it 'should raise an error' do
          expect { Spec::Constants::ExampleClass }.to raise_error NameError
        end

        context 'when an example class has been set' do
          example_class 'Spec::Constants::ExampleClass'

          it { expect(Spec::Constants::ExampleClass).to be_a Class }

          it { expect(Spec::Constants::ExampleClass.name).to be == 'Spec::Constants::ExampleClass' }

          it { expect(Spec::Constants::ExampleClass.superclass).to be Object }
        end
      end
      """
    When I run `rspec example_constants/example_class_within_namespace.rb`
    Then the output should contain "4 examples, 0 failures"

  Scenario: defining an example class with a base class
    Given a file named "example_constants/example_class_with_base_class.rb" with:
      """ruby
      require 'rspec/sleeping_king_studios/concerns/example_constants'

      RSpec.describe RSpec::SleepingKingStudios::Concerns::ExampleConstants do
        extend RSpec::SleepingKingStudios::Concerns::ExampleConstants

        it 'should raise an error' do
          expect { ExampleHash }.to raise_error NameError
        end

        it 'should raise an error' do
          expect { CustomHash }.to raise_error NameError
        end

        context 'when an example class has been set' do
          example_class :ExampleHash, base_class: Hash

          example_class :CustomHash, base_class: 'ExampleHash'

          it { expect(ExampleHash).to be_a Class }

          it { expect(ExampleHash.name).to be == 'ExampleHash' }

          it { expect(ExampleHash.superclass).to be Hash }

          context 'when a subclass of an example class has been set' do
            it { expect(CustomHash).to be_a Class }

            it { expect(CustomHash.name).to be == 'CustomHash' }

            it { expect(CustomHash.superclass).to be ExampleHash }
          end
        end
      end
      """
    When I run `rspec example_constants/example_class_with_base_class.rb`
    Then the output should contain "8 examples, 0 failures"

  Scenario: defining an example class with block
    Given a file named "example_constants/example_class.rb" with:
      """ruby
      require 'rspec/sleeping_king_studios/concerns/example_constants'

      RSpec.describe RSpec::SleepingKingStudios::Concerns::ExampleConstants do
        extend RSpec::SleepingKingStudios::Concerns::ExampleConstants

        it 'should raise an error' do
          expect { ExampleGreeter }.to raise_error NameError
        end

        context 'when an example constant has been set' do
          let(:greeting_format) { 'Greetings, %<name>s!' }
          let(:greeter)         { ExampleGreeter.new }

          example_class :ExampleGreeter do |klass|
            format = greeting_format

            klass.send :define_method, :greet do |name|
              Kernel.format(format, name: name)
            end
          end

          it { expect(ExampleGreeter).to be_a Class }

          it { expect(ExampleGreeter.name).to be == 'ExampleGreeter' }

          it { expect(greeter).to be_a ExampleGreeter }

          it { expect(greeter.greet 'programs').to be == 'Greetings, programs!' }
        end
      end
      """
    When I run `rspec example_constants/example_class.rb`
    Then the output should contain "5 examples, 0 failures"
