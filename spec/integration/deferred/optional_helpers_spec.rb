# frozen_string_literal: true

require 'rspec/sleeping_king_studios/deferred/examples'

RSpec.describe RSpec::SleepingKingStudios::Deferred::Examples do
  let(:fixture_file) do
    %w[spec/integration/deferred/optional_helpers_spec.fixture.rb]
  end
  let(:result) do
    RSpec::SleepingKingStudios::Sandbox.run(fixture_file)
  end
  let(:expected_examples) do
    <<~EXAMPLES.lines.map(&:strip)
      Spec::Models::Rocket#launch when the rocket is launched should set the orbit
      Spec::Models::Rocket#launch with orbit: value when the rocket is launched should set the orbit
      Spec::Models::Rocket#orbit is expected to equal nil
    EXAMPLES
  end

  it 'should apply the deferred examples', :aggregate_failures do
    expect(result.summary).to be == '3 examples, 0 failures'

    expect(result.example_descriptions).to be == expected_examples
  end
end
