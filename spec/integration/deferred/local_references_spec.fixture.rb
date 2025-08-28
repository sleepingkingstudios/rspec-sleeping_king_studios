# frozen_string_literal: true

require 'rspec/sleeping_king_studios'

require 'support/models/rocket'

RSpec.describe Spec::Models::Rocket do
  include RSpec::SleepingKingStudios::Deferred::Consumer

  subject(:rocket) { described_class.new(name: 'Imp IV') }

  deferred_examples 'should be a vehicle' do |vehicle_class|
    it { expect(subject).to be_a vehicle_class }
  end

  deferred_examples 'should be a rocket' do
    include_deferred 'should be a vehicle', Spec::Models::Rocket # rubocop:disable RSpec/DescribedClass
  end

  include_deferred 'should be a rocket'
end
