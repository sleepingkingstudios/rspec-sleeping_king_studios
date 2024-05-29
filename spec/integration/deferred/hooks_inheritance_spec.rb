# frozen_string_literal: true

require 'rspec/sleeping_king_studios/deferred/examples'

require 'support/integration/deferred/hooks_inheritance_examples'
require 'support/sandbox'

RSpec.describe RSpec::SleepingKingStudios::Deferred::Examples do
  let(:fixture_file) do
    %w[spec/integration/deferred/hooks_inheritance_spec.fixture.rb]
  end
  let(:result) do
    Spec::Support::Sandbox.run(fixture_file)
  end
  let(:recorded) do
    Spec::Integration::Deferred::HooksInheritanceExamples::Recorder
      .instance
      .records
  end
  let(:expected) do
    <<~TEXT.lines.map(&:strip)
      around.before.early
      around.before.inner
      around.before.inherited.2
      around.before.inherited.1
      around.before.other
      around.before.example
      before.prepend.example
      before.prepend.other
      before.prepend.inherited.1
      before.prepend.inherited.2
      before.prepend.inner
      before.prepend.early
      before.early
      before.inner
      before.inherited.2
      before.inherited.1
      before.other
      before.example
      example.example
      after.example
      after.other
      after.inherited.1
      after.inherited.2
      after.inner
      after.early
      after.append.early
      after.append.inner
      after.append.inherited.2
      after.append.inherited.1
      after.append.other
      after.append.example
      around.after.example
      around.after.other
      around.after.inherited.1
      around.after.inherited.2
      around.after.inner
      around.after.early
    TEXT
  end

  it 'should apply the deferred examples', :aggregate_failures do
    expect(result.summary).to be == '1 example, 0 failures'

    expect(recorded).to be == expected
  end
end
