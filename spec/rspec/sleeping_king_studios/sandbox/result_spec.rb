# frozen_string_literal: true

require 'rspec/sleeping_king_studios/examples/property_examples'
require 'rspec/sleeping_king_studios/sandbox'

RSpec.describe RSpec::SleepingKingStudios::Sandbox::Result do
  include RSpec::SleepingKingStudios::Examples::PropertyExamples

  subject(:result) do
    described_class.new(
      errors:,
      json:,
      output:,
      status:
    )
  end

  let(:output) do
    <<~OUTPUT
      Spec::Models::Rocket
        #launch
          should launch the rocket
          should set the launch site
    OUTPUT
  end
  let(:errors) { '' }
  let(:status) { 0 }
  let(:json) do
    # rubocop:disable RSpec/LineLength
    {
      'examples' => [
        {
          'full_description' => 'Spec::Models::Rocket#launch should launch the rocket',
        },
        {
          'full_description' => 'Spec::Models::Rocket#launch should set the launch site',
        },
      ],
      'summary_line' => '2 examples, 0 failures'
    }
    # rubocop:enable RSpec/LineLength
  end

  describe '#errors' do
    include_examples 'should define reader', :errors, -> { errors }
  end

  describe '#example_descriptions' do
    let(:expected) do
      json['examples'].map { |hsh| hsh['full_description'] }
    end

    include_examples 'should define reader',
      :example_descriptions,
      -> { expected }
  end

  describe '#json' do
    include_examples 'should define reader', :json, -> { json }
  end

  describe '#output' do
    include_examples 'should define reader', :output, -> { output }
  end

  describe '#status' do
    include_examples 'should define reader', :status, -> { status }
  end

  describe '#summary' do
    let(:expected) { json['summary_line'] }

    include_examples 'should define reader', :summary, -> { expected }
  end
end
