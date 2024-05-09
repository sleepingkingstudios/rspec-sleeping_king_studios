# frozen_string_literal: true

require 'rspec/sleeping_king_studios/deferred/examples'

require 'support/sandbox'

RSpec.describe RSpec::SleepingKingStudios::Deferred::Examples do
  let(:fixture_file) do
    %w[spec/integration/deferred/missing_spec.fixture.rb]
  end
  let(:result) do
    Spec::Support::Sandbox.run(fixture_file)
  end
  let(:expected_examples) do
    <<~EXAMPLES.lines.map(&:strip)
      Spec::Models::Rocket is expected to respond to #ordinal with 0 arguments
      Spec::Models::Rocket#ordinal is expected to be == IV
    EXAMPLES
  end

  it 'should apply the deferred examples', :aggregate_failures do
    expect(result.summary).to be == '2 examples, 0 failures'

    expect(result.example_descriptions).to be == expected_examples
  end
end
