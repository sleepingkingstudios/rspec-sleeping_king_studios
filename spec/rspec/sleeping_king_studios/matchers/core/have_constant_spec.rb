# spec/rspec/sleeping_king_studios/matchers/macros/have_constant_spec.rb

require 'rspec/sleeping_king_studios/matchers/core/have_constant'

RSpec.describe RSpec::SleepingKingStudios::Matchers::Macros do
  let(:matcher_class) do
    RSpec::SleepingKingStudios::Matchers::Core::HaveConstantMatcher
  end # let
  let(:constant_name) { :FOO }
  let(:example_group) { self }

  describe '#define_constant' do
    let(:matcher) { example_group.define_constant constant_name }

    it { expect(example_group).to respond_to(:define_constant).with(1).arguments }

    it { expect(matcher).to be_a matcher_class }

    it { expect(matcher.immutable?).to be false }
  end # describe

  describe '#define_immutable_constant' do
    let(:matcher) { example_group.define_immutable_constant constant_name }

    it { expect(example_group).to respond_to(:define_immutable_constant).with(1).arguments }

    it { expect(matcher).to be_a matcher_class }

    it { expect(matcher.immutable?).to be true }
  end # describe

  describe '#have_constant' do
    let(:matcher) { example_group.have_constant constant_name }

    it { expect(example_group).to respond_to(:have_constant).with(1).arguments }

    it { expect(matcher).to be_a matcher_class }

    it { expect(matcher.immutable?).to be false }
  end # describe

  describe '#have_immutable_constant' do
    let(:matcher) { example_group.have_immutable_constant constant_name }

    it { expect(example_group).to respond_to(:have_immutable_constant).with(1).arguments }

    it { expect(matcher).to be_a matcher_class }

    it { expect(matcher.immutable?).to be true }
  end # describe
end # describe
