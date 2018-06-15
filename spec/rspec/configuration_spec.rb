require 'spec_helper'

require 'rspec/sleeping_king_studios/configuration'

require 'rspec/sleeping_king_studios/matchers/built_in/respond_to'
require 'rspec/sleeping_king_studios/matchers/core/construct'

RSpec.describe RSpec.configuration do
  subject(:instance) { RSpec.configuration }

  describe '#sleeping_king_studios' do
    it 'should define the method' do
      expect(instance)
        .to respond_to(:sleeping_king_studios)
        .with(0).arguments
        .and_a_block
    end

    it 'should return the RSpec::SleepingKingStudios configuration' do
      expect(instance.sleeping_king_studios)
        .to be_a(RSpec::SleepingKingStudios::Configuration)
    end

    it 'should yield the RSpec::SleepingKingStudios configuration' do
      expect { |block| instance.sleeping_king_studios(&block) }
        .to yield_with_args(instance.sleeping_king_studios)
    end
  end
end
