# frozen_string_literal: true

require 'rspec/sleeping_king_studios/deferred/examples'

RSpec.describe RSpec::SleepingKingStudios::Deferred::Examples do
  let(:fixture_file) do
    %w[spec/integration/deferred/parameterized_focused_spec.fixture.rb]
  end
  let(:result) do
    RSpec::SleepingKingStudios::Sandbox.run(fixture_file)
  end
  let(:expected_examples) do
    <<~EXAMPLES.lines.map(&:strip)
      Spec::Models::Rocket (focused) is expected to be a kind of Spec::Models::SpaceVehicle
      Spec::Models::Rocket (focused) should behave like a rocket #launch is expected to respond to #launch
    EXAMPLES
  end

  it 'should apply the deferred examples', :aggregate_failures do
    expect(result.summary).to be == '2 examples, 0 failures'

    expect(result.example_descriptions).to eq expected_examples
  end
end
