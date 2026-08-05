# frozen_string_literal: true

require 'rspec/sleeping_king_studios/concerns/toolbelt'

RSpec.describe RSpec::SleepingKingStudios::Concerns::Toolbelt do
  subject(:instance) { described_class.new }

  let(:described_class) do
    Class
      .new
      .include RSpec::SleepingKingStudios::Concerns::Toolbelt
  end

  describe '::tools' do
    let(:expected) { SleepingKingStudios::Tools::Toolbelt.instance }

    it { expect(described_class).to respond_to(:tools).with(0).arguments }

    it { expect(described_class.tools).to be expected }
  end

  describe '#tools' do
    let(:expected) { SleepingKingStudios::Tools::Toolbelt.instance }

    it { expect(instance).to respond_to(:tools).with(0).arguments }

    it { expect(instance.tools).to be expected }
  end
end
