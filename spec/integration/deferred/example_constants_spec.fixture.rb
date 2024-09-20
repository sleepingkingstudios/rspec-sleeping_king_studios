# frozen_string_literal: true

require 'rspec/sleeping_king_studios'

require 'support/integration/deferred/meteor_examples'
require 'support/models/rocket'

RSpec.describe 'Meteor' do
  extend  RSpec::SleepingKingStudios::Concerns::ExampleConstants
  include Spec::Integration::Deferred::MeteorExamples

  subject(:meteor) { described_class.new(altitude) }

  let(:described_class) { Meteor }

  describe '#space?' do
    context 'when the altitude is below 100 km' do
      let(:altitude) { 50 }

      it { expect(meteor.space?).to be false }
    end

    context 'when the altitude is above 100 km' do
      let(:altitude) { 150 }

      it { expect(meteor.space?).to be true }
    end
  end
end
