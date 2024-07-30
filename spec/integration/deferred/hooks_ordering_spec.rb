# frozen_string_literal: true

require 'rspec/sleeping_king_studios/deferred/examples'

require 'support/integration/deferred/hooks_ordering_examples'

RSpec.describe RSpec::SleepingKingStudios::Deferred::Examples do
  let(:fixture_file) do
    %w[spec/integration/deferred/hooks_ordering_spec.fixture.rb]
  end
  let(:result) do
    RSpec::SleepingKingStudios::Sandbox.run(fixture_file)
  end
  let(:recorded) do
    Spec::Integration::Deferred::HooksOrderingExamples::Recorder
      .instance
      .records
  end
  let(:expected) do
    <<~TEXT.lines.map(&:strip)
      around.before.example.2
      around.before.example.1
      before.prepend.example.1
      before.prepend.example.2
      before.example.2
      before.example.1
      example.example
      after.example.1
      after.example.2
      after.append.example.2
      after.append.example.1
      around.after.example.1
      around.after.example.2
    TEXT
  end

  it 'should apply the deferred examples', :aggregate_failures do
    expect(result.summary).to be == '1 example, 0 failures'

    expect(recorded).to be == expected
  end
end
