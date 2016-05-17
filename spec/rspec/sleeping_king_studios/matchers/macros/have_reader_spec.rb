# spec/rspec/sleeping_king_studios/matchers/core/have_reader_spec.rb

require 'spec_helper'

require 'rspec/sleeping_king_studios/matchers/core/have_reader'

RSpec.describe RSpec::SleepingKingStudios::Matchers::Macros do
  let(:matcher_class) do
    RSpec::SleepingKingStudios::Matchers::Core::HaveReaderMatcher
  end # let
  let(:method_name)   { :foo }
  let(:example_group) { self }

  describe '#have_reader' do
    let(:matcher) { example_group.have_reader method_name }

    it { expect(example_group).to respond_to(:have_reader).with(1).arguments }

    it { expect(matcher).to be_a matcher_class }
  end # describe
end # describe
