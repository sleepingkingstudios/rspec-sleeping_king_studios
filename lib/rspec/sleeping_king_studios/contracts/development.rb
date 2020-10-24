# frozen_string_literal: true

require 'rspec/sleeping_king_studios/contracts'

module RSpec::SleepingKingStudios::Contracts
  # Adds support for focused and pending expectations in a contract.
  #
  # This module is intended for use when developing a contract, and should not
  # be included in the final version. Having skipped or focused example groups
  # in a shared contract can have unexpected effects when the contract is
  # included by the end user.
  #
  # @example Developing a Contract.
  #   module GreetsContract
  #     extend RSpec::SleepingKingStudios::Contract
  #     extend RSpec::SleepingKingStudios::Contracts::Development
  #
  #     describe '#greets' do
  #       fit { expect(subject).to respond_to(:greet).with(1).argument }
  #
  #       it { expect(subject.greet 'programs').to be == 'Greetings, programs!' }
  #
  #       xcontext 'when the greeted person is out of this world' do
  #         let(:person) { 'starfighter' }
  #
  #         it { expect(subject.greet person).to be == "Greetings, #{person}! }
  #       end
  #     end
  #
  #     pending
  #   end
  module Development
    # Defines a focused example group.
    #
    # @param description [String] The description for the example group.
    #
    # @yield The block is used to define the example group.
    #
    # @see RSpec::Core::ExampleGroup.fcontext
    def fcontext(description, &block)
      add_example :fcontext, description, &block
    end

    # Defines a focused example group.
    #
    # @param description [String] The description for the example group.
    #
    # @yield The block is used to define the example group.
    #
    # @see RSpec::Core::ExampleGroup.fdescribe
    def fdescribe(description, &block)
      add_example :fdescribe, description, &block
    end

    # Defines a focused example.
    #
    # @param description [String, nil] The description for the example.
    #
    # @yield The block is used to define the example.
    #
    # @see RSpec::Core::ExampleGroup.fit
    def fit(description = nil, &block)
      add_example :fit, description, allow_nil: true, &block
    end

    # Marks the contract as pending.
    #
    # @see RSpec::Core::ExampleGroup.pending
    def pending
      @pending = true
    end

    # @return [true, false] True if the contract has been marked as pending.
    def pending?
      !!@pending
    end

    # Defines a skipped example group.
    #
    # @param description [String] The description for the example group.
    #
    # @yield The block is used to define the example group.
    #
    # @see RSpec::Core::ExampleGroup.xcontext
    def xcontext(description, &block)
      add_example :xcontext, description, &block
    end

    # Defines a skipped example group.
    #
    # @param description [String] The description for the example group.
    #
    # @yield The block is used to define the example group.
    #
    # @see RSpec::Core::ExampleGroup.xdescribe
    def xdescribe(description, &block)
      add_example :xdescribe, description, &block
    end

    # Defines a skipped example.
    #
    # @param description [String, nil] The description for the example.
    #
    # @yield The block is used to define the example.
    #
    # @see RSpec::Core::ExampleGroup.xit
    def xit(description = nil, &block)
      add_example :xit, description, allow_nil: true, &block
    end

    private

    def included(other)
      super

      return unless other < RSpec::Core::ExampleGroup

      return unless pending?

      other.pending
    end
  end
end
