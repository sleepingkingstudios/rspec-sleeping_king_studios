# spec/support/shared_examples/shared_example_group_examples.rb

require 'support/shared_examples'

require 'rspec/sleeping_king_studios/concerns/shared_example_group'

module Spec::Support::SharedExamples
  module SharedExampleGroupExamples
    extend RSpec::SleepingKingStudios::Concerns::SharedExampleGroup

    shared_examples 'should pass with 1 example and 0 failures' do
      it 'should fail with 1 example, 0 failures' do
        results = run_spec_file

        expect(results).to include '1 example, 0 failures'
      end # it
    end # shared_examples

    shared_examples 'should fail with 1 example and 1 failure' do
      it 'should fail with 1 example, 1 failure' do
        results = run_spec_file

        expect(results).to include '1 example, 1 failure'
        expect(results).to include failure_message
      end # it
    end # shared_examples

    shared_examples 'should alias shared example group' do |aliased_description, original_description|
      describe %(should alias "#{original_description}" as "#{aliased_description}") do
        let(:shared_example_groups) do
          described_class.send(:shared_example_groups)[described_class]
        end # let

        def definition description
          example_group = shared_example_groups[description]

          example_group.is_a?(Proc) ? example_group : example_group.definition
        end # method definition

        it do
          expect(shared_example_groups).to have_key(original_description)
          expect(shared_example_groups).to have_key(aliased_description)

          original_definition = definition(original_description)
          aliased_definition  = definition(aliased_description)

          expect(original_definition).to be aliased_definition
        end # it
      end # describe
    end # shared_examples
  end # module
end # module
