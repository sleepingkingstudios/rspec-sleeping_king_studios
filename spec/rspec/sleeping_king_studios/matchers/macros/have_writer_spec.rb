# spec/rspec/sleeping_king_studios/matchers/macros/have_writer_spec.rb

require 'spec_helper'

require 'rspec/sleeping_king_studios/matchers/built_in/respond_to'
require 'rspec/sleeping_king_studios/matchers/core/have_writer'

RSpec.describe RSpec::SleepingKingStudios::Matchers::Macros do
  let(:matcher_class) do
    RSpec::SleepingKingStudios::Matchers::Core::HaveWriterMatcher
  end # let
  let(:method_name)   { :foo }
  let(:example_group) { self }

  describe '#have_writer' do
    let(:matcher) { example_group.have_writer method_name }

    it 'should define the macro' do
      expect(example_group).
        to respond_to(:have_writer).
        with(1).arguments.
        and_keywords(:allow_private)
    end # it

    it { expect(matcher).to be_a matcher_class }

    it { expect(matcher.allow_private?).to be false }

    describe 'with :allow_private => true' do
      let(:matcher) do
        example_group.have_writer method_name, :allow_private => true
      end # let

      it { expect(matcher.allow_private?).to be true }
    end # describe
  end # describe
end # describe
