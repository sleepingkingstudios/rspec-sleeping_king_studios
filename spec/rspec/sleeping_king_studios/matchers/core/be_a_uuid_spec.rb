# frozen_string_literals: true

require 'spec_helper'

require 'rspec/sleeping_king_studios/matchers/core/be_a_uuid'

RSpec.describe RSpec::SleepingKingStudios::Matchers::Macros do
  let(:matcher_class) do
    RSpec::SleepingKingStudios::Matchers::Core::BeAUuidMatcher
  end
  let(:example_group) { self }

  describe '#a_uuid' do
    let(:matcher) { example_group.a_uuid }

    it { expect(example_group).to respond_to(:a_uuid).with(0).arguments }

    it { expect(matcher.base_matcher).to be_a matcher_class }

    it { expect(matcher.class).to be RSpec::Matchers::AliasedMatcher }

    it 'should have a custom description' do
      expect(matcher.description).to be == 'a UUID'
    end
  end

  describe '#be_a_uuid' do
    let(:matcher) { example_group.be_a_uuid }

    it { expect(example_group).to respond_to(:be_a_uuid).with(0).arguments }

    it { expect(matcher).to be_a matcher_class }
  end
end
