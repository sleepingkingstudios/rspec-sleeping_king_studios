# frozen_string_literal: true

require 'rspec/sleeping_king_studios/deferred/examples'

require 'support/sandbox'

RSpec.describe RSpec::SleepingKingStudios::Deferred::Examples do
  let(:fixture_file) do
    %w[spec/integration/deferred/wrapped_contexts_spec.fixture.rb]
  end
  let(:result) do
    Spec::Support::Sandbox.run(fixture_file)
  end
  let(:expected_examples) do
    <<~EXAMPLES.lines.map(&:strip)
      Spec::Models::Rocket when the rocket has been launched is expected to equal true
      Spec::Models::Rocket when the rocket has been launched when the payload includes a booster is expected to be == {:booster=>true}
      Spec::Models::Rocket when the rocket has been launched when the payload includes a satellite is expected to be == {:satellite=>true}
      Spec::Models::Rocket when the rocket has been launched when the rocket has multiple payloads is expected to be == {:booster=>true, :satellite=>true}
    EXAMPLES
  end

  it 'should apply the deferred examples', :aggregate_failures do
    expect(result.summary).to be == '4 examples, 0 failures'

    expect(result.example_descriptions).to be == expected_examples
  end
end
