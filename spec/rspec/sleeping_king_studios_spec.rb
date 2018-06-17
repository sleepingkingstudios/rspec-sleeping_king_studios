# spec/rspec/sleeping_king_studios_spec.rb

require 'spec_helper'

require 'rspec/sleeping_king_studios'

RSpec.describe RSpec::SleepingKingStudios do
  describe '::gem_path' do
    let(:expected) do
      pattern =
        /#{File::SEPARATOR}spec#{File::SEPARATOR}rspec#{File::SEPARATOR}?\z/

      __dir__.sub(pattern, '')
    end

    it 'should define the class reader' do
      expect(described_class).to respond_to(:gem_path).with(0).arguments
    end

    it 'should return the path to the gem root directory' do
      expect(described_class.gem_path).to be == expected
    end
  end

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
