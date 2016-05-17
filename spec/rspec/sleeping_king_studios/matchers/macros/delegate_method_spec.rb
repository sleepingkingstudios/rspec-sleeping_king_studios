# spec/rspec/sleeping_king_studios/matchers/core/delegate_method_spec.rb

require 'spec_helper'

require 'rspec/sleeping_king_studios/matchers/core/delegate_method'

RSpec.describe RSpec::SleepingKingStudios::Matchers::Macros do
  let(:example_group) { self }
  let(:method_name)   { :delegated_method }
  let(:matcher)       { example_group.delegate_method method_name }

  it { expect(example_group).to respond_to(:delegate_method).with(1).argument }

  it { expect(matcher).to be_a RSpec::SleepingKingStudios::Matchers::Core::DelegateMethodMatcher }

  it { expect(matcher.expected).to be == method_name }
end # describe
