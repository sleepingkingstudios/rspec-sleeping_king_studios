# frozen_string_literal: true

require 'rspec/sleeping_king_studios/deferred'
require 'rspec/sleeping_king_studios/deferred/consumer'

RSpec.describe RSpec::SleepingKingStudios::Deferred do
  include RSpec::SleepingKingStudios::Deferred::Consumer

  deferred_examples 'deferred examples' do
    let(:expected) do
      <<~RAW.strip
        RSpec::SleepingKingStudios::Deferred.reflect with a deferred example group (deferred examples)
      RAW
    end

    it 'should return the description' do
      expect(described_class.reflect(current_example)).to be == expected
    end

    describe 'with source_locations: true' do
      let(:expected) do
        <<~RAW.strip
          RSpec::SleepingKingStudios::Deferred at #{source_location_for(ancestor_groups[3])}
          .reflect at #{source_location_for(ancestor_groups[2])}
          with a deferred example group at #{source_location_for(ancestor_groups[1])}
          (deferred examples) at #{__FILE__}:9
          with source_locations: true at #{source_location_for(ancestor_groups[0])}
        RAW
      end

      it 'should return the example groups with source locations' do
        expect(
          described_class.reflect(
            current_example,
            source_locations: true
          )
        )
          .to be == expected
      end
    end
  end

  deferred_examples 'outer deferred examples' do
    deferred_examples 'inner deferred examples' do
      let(:expected) do
        <<~RAW.strip
          RSpec::SleepingKingStudios::Deferred.reflect with a nested deferred group (outer deferred examples) (inner deferred examples)
        RAW
      end

      it 'should return the description' do
        expect(described_class.reflect(current_example)).to be == expected
      end

      describe 'with source_locations: true' do
        let(:expected) do
          <<~RAW.strip
            RSpec::SleepingKingStudios::Deferred at #{source_location_for(ancestor_groups[3])}
            .reflect at #{source_location_for(ancestor_groups[2])}
            with a nested deferred group at #{source_location_for(ancestor_groups[1])}
            (outer deferred examples) at #{__FILE__}:43
            (inner deferred examples) at #{__FILE__}:44
            with source_locations: true at #{source_location_for(ancestor_groups[0])}
          RAW
        end

        it 'should return the example groups with source locations' do
          expect(
            described_class.reflect(
              current_example,
              source_locations: true
            )
          )
            .to be == expected
        end
      end
    end

    include_deferred 'inner deferred examples'
  end

  describe '.reflect' do
    let(:current_example) { @current_example }
    let(:ancestor_groups) do
      current_example.example_group.ancestors.select do |ancestor|
        ancestor.is_a?(Class) && ancestor < RSpec::Core::ExampleGroup
      end
    end
    let(:expected) do
      'RSpec::SleepingKingStudios::Deferred.reflect'
    end

    before(:example) { |example| @current_example = example }

    define_method(:source_location_for) do |example_group|
      source_location =
        if example_group < RSpec::Core::ExampleGroup
          example_group.metadata[:block].source_location
        end

      source_location.join(':')
    end

    it 'should define the class method' do
      expect(described_class)
        .to respond_to(:reflect)
        .with(1).argument
        .and_keywords(:source_locations)
    end

    it { expect(described_class.reflect(current_example)).to be == expected }

    describe 'with source_locations: true' do
      let(:expected) do
        <<~RAW.strip
          RSpec::SleepingKingStudios::Deferred at #{source_location_for(ancestor_groups[2])}
          .reflect at #{source_location_for(ancestor_groups[1])}
          with source_locations: true at #{source_location_for(ancestor_groups[0])}
        RAW
      end

      it 'should return the example groups with source locations' do
        expect(
          described_class.reflect(
            current_example,
            source_locations: true
          )
        )
          .to be == expected
      end
    end

    describe 'with a nested example group' do
      let(:expected) do
        <<~RAW.strip
          RSpec::SleepingKingStudios::Deferred.reflect with a nested example group
        RAW
      end

      it 'should return the description' do
        expect(described_class.reflect(current_example)).to be == expected
      end

      describe 'with source_locations: true' do
        let(:expected) do
          <<~RAW.strip
            RSpec::SleepingKingStudios::Deferred at #{source_location_for(ancestor_groups[3])}
            .reflect at #{source_location_for(ancestor_groups[2])}
            with a nested example group at #{source_location_for(ancestor_groups[1])}
            with source_locations: true at #{source_location_for(ancestor_groups[0])}
          RAW
        end

        it 'should return the example groups with source locations' do
          expect(
            described_class.reflect(
              current_example,
              source_locations: true)
          )
            .to be == expected
        end
      end
    end

    describe 'with a deferred example group' do
      include_deferred 'deferred examples'
    end
  end
end
