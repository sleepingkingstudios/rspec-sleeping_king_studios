# frozen_string_literal: true

require 'rspec/sleeping_king_studios'

RSpec.describe RSpec::SleepingKingStudios::Concerns::MemoizedHelpers do
  extend RSpec::SleepingKingStudios::Concerns::MemoizedHelpers # rubocop:disable RSpec/DescribedClass

  shared_examples 'should define the helper method' do
    let?(:launch_site) { 'KSC' }

    it { expect(launch_site).to be == expected }
  end

  let(:expected) { 'KSC' }

  context 'when there is not an existing method' do
    include_examples 'should define the helper method'
  end

  context 'when there is an existing method' do
    let(:expected) { 'Baikerbanur' }

    def launch_site
      'Baikerbanur'
    end

    include_examples 'should define the helper method'

    context 'with a child context' do
      include_examples 'should define the helper method'
    end
  end

  context 'when there is an existing helper' do
    let(:expected)    { 'Baikerbanur' }
    let(:launch_site) { 'Baikerbanur' }

    include_examples 'should define the helper method'

    context 'with a child context' do
      include_examples 'should define the helper method'
    end
  end

  context 'when there is an existing optional helper' do
    let(:expected)     { 'Baikerbanur' }
    let?(:launch_site) { 'Baikerbanur' }

    include_examples 'should define the helper method'

    context 'with a child context' do
      include_examples 'should define the helper method'
    end
  end
end
