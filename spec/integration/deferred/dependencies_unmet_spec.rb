# frozen_string_literal: true

require 'rspec/sleeping_king_studios/deferred/examples'

RSpec.describe RSpec::SleepingKingStudios::Deferred::Dependencies do
  let(:fixture_file) do
    %w[spec/integration/deferred/dependencies_unmet_spec.fixture.rb]
  end
  let(:result) do
    RSpec::SleepingKingStudios::Sandbox.run(fixture_file)
  end
  let(:error_message) do
    <<~MESSAGE.strip
      Unable to run specs with deferred example groups because the following methods are not defined in the examples:

      Missing methods for "should launch the rocket":
        #launch_site
        #rocket: the pointy end points toward space

      Please define the missing methods or :let helpers.
    MESSAGE
  end

  it 'should apply the deferred examples', :aggregate_failures do
    expect(result.summary).to be == '1 example, 1 failure'

    expect(result.json.dig('examples', 0, 'exception', 'message'))
      .to be == error_message
  end
end
