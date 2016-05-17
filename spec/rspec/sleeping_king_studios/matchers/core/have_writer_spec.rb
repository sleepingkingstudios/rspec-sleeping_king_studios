# spec/rspec/sleeping_king_studios/matchers/core/have_writer_spec.rb

require 'spec_helper'

require 'rspec/sleeping_king_studios/matchers/core/have_writer'

RSpec.describe RSpec::SleepingKingStudios::Matchers do
  let(:matcher_class) do
    RSpec::SleepingKingStudios::Matchers::Core::HaveWriterMatcher
  end # let
  let(:method_name)   { :foo }
  let(:example_group) { self }

  describe '#have_writer' do
    let(:matcher) { example_group.have_writer method_name }

    it { expect(example_group).to respond_to(:have_writer).with(1).arguments }

    it { expect(matcher).to be_a matcher_class }
  end # describe
end # describe
