Feature: `ExampleConstants` concern
  Use the `include_contract` class method to include a reusable spec contract
  from another source.

  ```ruby
  RSpec.describe ExampleClass do
    include_contract Spec::Contracts::ExampleContract
  end
  ```

  You can also include contracts by name.

  ```ruby
  module Spec::Contracts
    SHOULD_BE_CALLABLE_CONTRACT = lambda do
      it { expect(subject).to respond_to(:call) }
    end
  end

  RSpec.describe ExampleClass do
    include Spec::Contracts

    include_contract 'should be callable'
  end
  ```

  The 'should be callable' contract searches for a matching class or constant in
  the example group's scope. It can match a `ShouldBeCallable` or
  `ShouldBeCallableContract` class, or a SHOULD_BE_CALLABLE or
  SHOULD_BE_CALLABLE_CONTRACT constant.

  Finally, you can pass parameters to contracts, including arguments, keywords,
  and a block.

  ```ruby
  module Spec::Contracts
    SHOULD_BE_SERIALIZABLE = lambda do |*attributes|
      describe '#serialize' do
        let(:serialized) { subject.serialize }

        it { expect(subject).to respond_to(:serialize).with(0).arguments }

        attributes.each do |attribute|
          it "should serialize #{attribute}" do
            expect(serialized[attribute]).to be == subject[attribute]
          end
        end
      end
    end
  end

  RSpec.describe ExampleClass do
    include Spec::Contracts

    include_contract 'should be serializable', :title, :author, :series
  end
  ```

  Scenario: basic usage
  Given a file named "contracts.rb" with:
    """ruby
    module SerializerContracts
      SHOULD_SERIALIZE_ATTRIBUTES_CONTRACT =
        lambda do |*attributes, **values, &block|
          describe '#serialize' do
            let(:serialized) { subject.serialize }

            it { expect(subject).to respond_to(:serialize).with(0).arguments }

            attributes.each do |attribute|
              it "should serialize #{attribute}" do
                expect(serialized[attribute]).to be == subject[attribute]
              end
            end

            values.each do |attribute, value|
              it "should serialize #{attribute}" do
                expect(serialized[attribute]).to be == value
              end
            end

            instance_exec(&block) if block
          end
        end
      end
    """
  Given a file named "captain_picard.rb" with:
    """ruby
    class CaptainPicard < Struct.new(:rank, :name)
      def initialize
        super('Captain', 'Jean-Luc Picard')
      end

      def serialize
        {
          name:   name,
          rank:   rank,
          lights: 5
        }
      end
    end
    """
  Given a file named "captain_picard_spec.rb" with:
    """ruby
    require 'rspec/sleeping_king_studios/concerns/include_contract'

    require_relative './captain_picard'
    require_relative './contracts'

    RSpec.describe CaptainPicard do
      extend  RSpec::SleepingKingStudios::Concerns::IncludeContract
      include SerializerContracts

      include_contract 'should serialize attributes',
        :name,
        :rank,
        lights: 4 do
          it 'should serialize the catchphrase' do
            expect(serialized[:catchphrase]).to be == 'Make it so.'
          end
      end
    end
    """
  When I run `rspec captain_picard_spec.rb`
  Then the output should contain "1) CaptainPicard#serialize should serialize lights"
  Then the output should contain "2) CaptainPicard#serialize should serialize the catchphrase"
