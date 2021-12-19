# spec/rspec/sleeping_king_studios/matchers/macros/alias_method_spec.rb

require 'spec_helper'

require 'rspec/sleeping_king_studios/matchers/core/alias_method'

RSpec.describe RSpec::SleepingKingStudios::Matchers::Macros do
  let(:matcher_class) do
    RSpec::SleepingKingStudios::Matchers::Core::HaveAliasedMethodMatcher
  end # let
  let(:example_group) { self }

  describe '#alias_method' do
    let(:method_name)   { :foo }
    let(:matcher)       { example_group.alias_method method_name }

    before(:example) do
      allow(SleepingKingStudios::Tools::CoreTools).to receive(:deprecate)
    end

    it { expect(example_group).to respond_to(:alias_method).with(1).argument }

    it { expect(matcher).to be_a matcher_class }

    it 'should print a deprecation warning' do
      example_group.alias_method(method_name)

      expect(SleepingKingStudios::Tools::CoreTools)
        .to have_received(:deprecate)
        .with(
          '#alias_method',
          message: 'Use #have_aliased_method instead.'
        )
    end
  end # describe
end # describe
