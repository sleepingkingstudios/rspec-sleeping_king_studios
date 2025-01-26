# frozen_string_literals: true

require 'rspec/sleeping_king_studios/examples/rspec_matcher_examples'

require 'rspec/sleeping_king_studios/matchers/core/be_a_uuid_matcher'

RSpec.describe RSpec::SleepingKingStudios::Matchers::Core::BeAUuidMatcher do
  include RSpec::SleepingKingStudios::Examples::RSpecMatcherExamples

  let(:instance) { described_class.new }

  describe '#description' do
    it { expect(instance).to respond_to(:description).with(0).arguments }

    it { expect(instance.description).to be == 'be a UUID' }
  end

  describe '#matches?' do
    let(:failure_message) do
      "expected #{actual.inspect} to be a UUID"
    end
    let(:failure_message_when_negated) do
      "expected #{actual.inspect} not to be a UUID"
    end

    describe 'with nil' do
      let(:failure_message) { super() << ', but was not a String' }
      let(:actual)          { nil }

      include_examples 'should fail with a positive expectation'

      include_examples 'should pass with a negative expectation'
    end

    describe 'with a non Boolean object' do
      let(:failure_message) { super() << ', but was not a String' }
      let(:actual)          { Object.new }

      include_examples 'should fail with a positive expectation'

      include_examples 'should pass with a negative expectation'
    end

    describe 'with an empty string' do
      let(:failure_message) { super() << ', but was too short' }
      let(:actual)          { '' }

      include_examples 'should fail with a positive expectation'

      include_examples 'should pass with a negative expectation'
    end

    describe 'with a string that is too short' do
      let(:failure_message) { super() << ', but was too short' }
      let(:actual)          { '00000000' }

      include_examples 'should fail with a positive expectation'

      include_examples 'should pass with a negative expectation'
    end

    describe 'with a string that is too long' do
      let(:failure_message) { super() << ', but was too long' }
      let(:actual)          { '00000000-0000-0000-0000-000000000000-00000000' }

      include_examples 'should fail with a positive expectation'

      include_examples 'should pass with a negative expectation'
    end

    describe 'with a string with invalid characters' do
      let(:failure_message) { super() << ', but has invalid characters' }
      let(:actual)          { '01234567-89ab-cdef-ghij-klmnopqrstuv' }

      include_examples 'should fail with a positive expectation'

      include_examples 'should pass with a negative expectation'
    end

    describe 'with a string with invalid format' do
      let(:failure_message) { super() << ', but the format is invalid' }
      let(:actual)          { '0123456789abcdef0123456789abcdef----' }

      include_examples 'should fail with a positive expectation'

      include_examples 'should pass with a negative expectation'
    end

    describe 'with a numeric UUID' do
      let(:actual) { '00000000-0000-0000-0000-000000000000' }

      include_examples 'should pass with a positive expectation'

      include_examples 'should fail with a negative expectation'
    end

    describe 'with an uppercase UUID' do
      let(:actual) { '01234567-89AB-CDEF-0123-456789ABCDEF' }

      include_examples 'should pass with a positive expectation'

      include_examples 'should fail with a negative expectation'
    end

    describe 'with a lowercase UUID' do
      let(:actual) { '01234567-89ab-cdef-0123-456789abcdef' }

      include_examples 'should pass with a positive expectation'

      include_examples 'should fail with a negative expectation'
    end
  end
end
