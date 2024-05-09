# frozen_string_literal: true

require 'rspec/sleeping_king_studios/deferred/examples'

require 'support/sandbox'

RSpec.describe RSpec::SleepingKingStudios::Deferred::Examples do
  let(:fixture_file) do
    %w[spec/integration/deferred/inheritance_spec.fixture.rb]
  end
  let(:result) do
    Spec::Support::Sandbox.run(fixture_file)
  end
  let(:expected_examples) do
    <<~EXAMPLES.lines.map(&:strip)
      Spec::Models::Rocket#launch should launch the rocket
      Spec::Models::Rocket#launch should set the launch site
      Spec::Models::Rocket#launch_site is expected to equal nil
      Spec::Models::Rocket#launched? is expected to equal false
      Spec::Models::Rocket#name is expected to respond to #name with 0 arguments
      Spec::Models::Rocket#name is expected to be a kind of String
      Spec::Models::Rocket#type is expected to respond to #type with 0 arguments
      Spec::Models::Rocket#type is expected to be == rocket
    EXAMPLES
  end

  it 'should apply the deferred examples', :aggregate_failures do
    expect(result.summary).to be == '8 examples, 0 failures'

    expect(result.example_descriptions).to be == expected_examples
  end
end
