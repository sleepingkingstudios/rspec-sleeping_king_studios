# spec/rspec/sleeping_king_studios/matchers/active_model/have_errors_spec.rb

require 'spec_helper'

require 'rspec/sleeping_king_studios/matchers/active_model/have_errors'

RSpec.describe RSpec::SleepingKingStudios::Matchers::Macros do
  let(:matcher_class) do
    RSpec::SleepingKingStudios::Matchers::ActiveModel::HaveErrorsMatcher
  end # let
  let(:example_group) { self }

  describe '#have_errors' do
    let(:matcher) { example_group.have_errors }

    it { expect(example_group).to respond_to(:have_errors).with(0).arguments }

    it { expect(matcher).to be_a matcher_class }
  end # describe
end # describe
