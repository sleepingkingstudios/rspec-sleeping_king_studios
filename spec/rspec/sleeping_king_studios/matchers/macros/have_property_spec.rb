# spec/rspec/sleeping_king_studios/matchers/macros/have_property_spec.rb

require 'spec_helper'

require 'rspec/sleeping_king_studios/matchers/built_in/respond_to'
require 'rspec/sleeping_king_studios/matchers/core/have_property'

RSpec.describe RSpec::SleepingKingStudios::Matchers::Macros do
  let(:matcher_class) do
    RSpec::SleepingKingStudios::Matchers::Core::HavePropertyMatcher
  end # let
  let(:method_name)   { :foo }
  let(:example_group) { self }

  describe '#have_property' do
    let(:matcher) { example_group.have_property method_name }

    it 'should define the macro' do
      expect(example_group).
        to respond_to(:have_property).
        with(1).arguments.
        and_keywords(:allow_private)
    end # it

    it { expect(matcher).to be_a matcher_class }

    it { expect(matcher.allow_private?).to be false }

    describe 'with :allow_private => true' do
      let(:matcher) do
        example_group.have_property method_name, :allow_private => true
      end # let

      it { expect(matcher.allow_private?).to be true }
    end # describe
  end # describe
end # describe
