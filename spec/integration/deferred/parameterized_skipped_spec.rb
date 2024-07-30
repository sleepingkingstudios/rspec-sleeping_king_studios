# frozen_string_literal: true

require 'rspec/sleeping_king_studios/deferred/examples'

RSpec.describe RSpec::SleepingKingStudios::Deferred::Examples do
  let(:fixture_file) do
    %w[spec/integration/deferred/parameterized_skipped_spec.fixture.rb]
  end
  let(:result) do
    RSpec::SleepingKingStudios::Sandbox.run(fixture_file)
  end
  let(:expected_examples) do
    <<~EXAMPLES.lines.map(&:strip)
      Spec::Models::Rocket (skipped)
      Spec::Models::Rocket (skipped) should behave like a rocket #launch
    EXAMPLES
  end

  it 'should apply the deferred examples', :aggregate_failures do
    expect(result.summary).to be == '2 examples, 0 failures, 2 pending'

    expect(result.example_descriptions.map(&:strip)).to eq expected_examples
  end
end
