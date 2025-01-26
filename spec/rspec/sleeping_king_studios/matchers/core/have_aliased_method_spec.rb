# frozen_string_literal: true

require 'rspec/sleeping_king_studios/matchers/core/have_aliased_method'

RSpec.describe RSpec::SleepingKingStudios::Matchers::Macros do
  let(:matcher_class) do
    RSpec::SleepingKingStudios::Matchers::Core::HaveAliasedMethodMatcher
  end
  let(:example_group) { self }

  describe '#have_aliased_method' do
    let(:method_name) { :do_something }
    let(:matcher)     { example_group.have_aliased_method method_name }

    it 'should define the macro' do
      expect(example_group).to respond_to(:have_aliased_method).with(1).argument
    end

    it { expect(matcher).to be_a matcher_class }
  end
end
