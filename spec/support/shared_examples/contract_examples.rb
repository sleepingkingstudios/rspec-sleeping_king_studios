# frozen_string_literal: true

require 'rspec/sleeping_king_studios/concerns/shared_example_group'

require 'support/shared_examples'

module Spec::Support::SharedExamples
  module ContractExamples
    extend RSpec::SleepingKingStudios::Concerns::SharedExampleGroup

    shared_examples 'should define an example' \
    do |description: :default_description|
      let(:desc) do
        next description unless description == :default_description

        'should do something'
      end
      let(:implementation) { -> {} }

      it 'should define an example' do
        expect { described_class.send method_name, desc, &implementation }
          .to change { described_class.examples.size }
          .by(1)
      end

      it 'should add the definition to .examples' do
        described_class.send method_name, desc, &implementation

        expect(described_class.examples.last).to be == {
          block:       implementation,
          description: desc,
          method_name: method_name
        }
      end
    end

    shared_examples 'should validate the description and block' \
    do |allow_nil: false|
      describe 'with description: nil' do
        let(:description) { nil }

        if allow_nil
          include_examples 'should define an example', description: nil
        else
          let(:error_message) { "description can't be blank" }

          it 'should raise an error' do
            expect { described_class.send method_name, description }
              .to raise_error ArgumentError, error_message
          end
        end
      end

      describe 'with description: a Object' do
        let(:error_message) { 'description must be a String or a Symbol' }

        it 'should raise an error' do
          expect { described_class.send method_name, Object.new.freeze }
            .to raise_error ArgumentError, error_message
        end
      end

      describe 'with description: an empty String' do
        let(:error_message) { "description can't be blank" }

        it 'should raise an error' do
          expect { described_class.send method_name, '' }
            .to raise_error ArgumentError, error_message
        end
      end

      describe 'with description: an empty Symbol' do
        let(:error_message) { "description can't be blank" }

        it 'should raise an error' do
          expect { described_class.send method_name, '' }
            .to raise_error ArgumentError, error_message
        end
      end

      describe 'without a block' do
        let(:error_message) { 'called without a block' }

        it 'should raise an error' do
          expect { described_class.send method_name, '#something' }
            .to raise_error ArgumentError, error_message
        end
      end
    end
  end
end
