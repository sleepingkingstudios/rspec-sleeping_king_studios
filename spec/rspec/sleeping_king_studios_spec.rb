# spec/rspec/sleeping_king_studios_spec.rb

require 'rspec/sleeping_king_studios'

RSpec.describe RSpec::SleepingKingStudios do
  describe '::version' do
    let(:expected) do
      RSpec::SleepingKingStudios::Version.to_gem_version
    end # let

    it 'should define the class reader' do
      expect(described_class).to respond_to(:version).with(0).arguments
    end # it

    it 'should return the version string' do
      expect(described_class.version).to be == expected
    end # it
  end # describe
end # describe
