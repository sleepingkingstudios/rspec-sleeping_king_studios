# frozen_string_literal: true

require 'rspec/sleeping_king_studios/contract'

require 'support/contracts'
require 'support/entities/rocket_engine'

module Spec::Support::Contracts
  class RocketContract < RSpec::SleepingKingStudios::Contract
    contract do |fuel_type:|
      let(:engine) { Spec::Support::Entities::RocketEngine.new(fuel_type) }

      before(:example) { rocket.engine = engine }

      it 'should have an engine' do
        expect(rocket.engine)
          .to be_a(Spec::Support::Entities::RocketEngine)
          .and(have_attributes(fuel_type: fuel_type))
      end

      describe '#launch' do
        it 'should activate the engine' do
          expect { rocket.launch }
            .to change(engine, :active?)
            .to be true
        end
      end
    end
  end
end
