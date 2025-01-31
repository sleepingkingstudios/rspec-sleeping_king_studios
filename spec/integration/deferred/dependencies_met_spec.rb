# frozen_string_literal: true

require 'rspec/sleeping_king_studios/deferred/examples'

RSpec.describe RSpec::SleepingKingStudios::Deferred::Dependencies do
  let(:fixture_file) do
    %w[spec/integration/deferred/dependencies_met_spec.fixture.rb]
  end
  let(:result) do
    RSpec::SleepingKingStudios::Sandbox.run(fixture_file)
  end
  let(:expected_examples) do
    <<~EXAMPLES.lines.map(&:strip)
      Rocket #launch is expected not to raise Exception
    EXAMPLES
  end

  it 'should apply the deferred examples', :aggregate_failures do
    expect(result.summary).to be == '1 example, 0 failures'

    expect(result.example_descriptions).to be == expected_examples
  end
end
