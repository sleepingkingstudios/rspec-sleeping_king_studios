# spec/rspec/sleeping_king_studios/examples/property_examples/predicates_spec.rb

require 'rspec/sleeping_king_studios/examples/property_examples'
require 'rspec/sleeping_king_studios/matchers/core/be_boolean'

require 'support/shared_examples/file_examples'
require 'support/shared_examples/shared_example_group_examples'

RSpec.describe RSpec::SleepingKingStudios::Examples::PropertyExamples do
  include Spec::Support::SharedExamples::FileExamples
  include Spec::Support::SharedExamples::SharedExampleGroupExamples

  def self.spec_namespace
    %w(examples property_examples predicates)
  end # class method spec_namespace

  shared_context 'with a spec file with examples' do |custom_contents|
    custom_contents =
      tools.
        str.
        map_lines(custom_contents) do |line, index|
          index.zero? ? line : "#{' ' * 10}#{line}"
        end # map_lines
    contents =
      <<-RUBY
        require_relative 'class_with_predicates'

        require 'rspec/sleeping_king_studios/examples/property_examples'

        RSpec.describe ClassWithPredicates do
          include RSpec::SleepingKingStudios::Examples::PropertyExamples

          subject(:instance) { described_class.new }

          #{ custom_contents }
        end # describe
      RUBY

    include_examples 'with a spec file containing', contents
  end # shared_context

  include_context 'with a temporary file named',
    'examples/property_examples/predicates/class_with_predicates.rb',
    <<-RUBY
      class ClassWithPredicates
        def public_predicate?; end

        def public_predicate_with_value?
          true
        end # method public_predicate_with_value?

        def inspect
          '#<ClassWithPredicates>'
        end # method inspect

        private

        def private_predicate?; end
      end # class
    RUBY

  describe '"should have predicate"' do
    let(:failure_message) do
      "expected #<ClassWithPredicates> to respond to #{predicate_name}"
    end # let

    include_examples 'should alias shared example group',
      'should have predicate',
      'defines predicate'

    include_examples 'should alias shared example group',
      'should have predicate',
      'has predicate'

    include_examples 'should alias shared example group',
      'should have predicate',
      'should define predicate'

    describe 'with the name of a predicate' do
      let(:example_name) { %r{should have predicate :named_predicate\?$} }

      include_context 'with a spec file with examples',
        "include_examples 'should have predicate', :named_predicate"

      it 'should display the name of the example' do
        results = run_spec_file(format: :documentation)

        expect(results).to match example_name
      end
    end

    describe 'with the name of a predicate with a question mark' do
      let(:example_name) { %r{should have predicate :named_predicate\?$} }

      include_context 'with a spec file with examples',
        "include_examples 'should have predicate', :named_predicate?"

      it 'should display the name of the example' do
        results = run_spec_file(format: :documentation)

        expect(results).to match example_name
      end
    end

    describe 'with the name of an undefined predicate' do
      let(:predicate_name) { ':undefined_predicate?' }
      let(:failure_message) do
        super() + ", but did not respond to #{predicate_name}"
      end # let

      include_context 'with a spec file with examples',
        "include_examples 'should have predicate', :undefined_predicate"

      include_examples 'should fail with 1 example and 1 failure'
    end # describe

    describe 'with the name of an undefined predicate with a question mark' do
      let(:predicate_name) { ':undefined_predicate?' }
      let(:failure_message) do
        super() + ", but did not respond to #{predicate_name}"
      end # let

      include_context 'with a spec file with examples',
        "include_examples 'should have predicate', :undefined_predicate?"

      include_examples 'should fail with 1 example and 1 failure'
    end # describe

    describe 'with the name of a private predicate' do
      let(:predicate_name) { ':private_predicate?' }
      let(:failure_message) do
        super() + ", but did not respond to #{predicate_name}"
      end # let

      include_context 'with a spec file with examples',
        "include_examples 'should have predicate', :private_predicate"

      include_examples 'should fail with 1 example and 1 failure'
    end # describe

    describe 'with the name of a private predicate with a question mark' do
      let(:predicate_name) { ':private_predicate?' }
      let(:failure_message) do
        super() + ", but did not respond to #{predicate_name}"
      end # let

      include_context 'with a spec file with examples',
        "include_examples 'should have predicate', :private_predicate?"

      include_examples 'should fail with 1 example and 1 failure'
    end # describe

    describe 'with the name of a public predicate' do
      include_context 'with a spec file with examples',
        "include_examples 'should have predicate', :public_predicate"

      include_examples 'should pass with 1 example and 0 failures'
    end # describe

    describe 'with the name of a public predicate with a question mark' do
      include_context 'with a spec file with examples',
        "include_examples 'should have predicate', :public_predicate?"

      include_examples 'should pass with 1 example and 0 failures'
    end # describe

    describe 'with a non-matching value expectation' do
      let(:failure_message) { super() + ' and return true' }

      describe 'with the name of an undefined predicate' do
        let(:predicate_name) { ':undefined_predicate?' }
        let(:failure_message) do
          super() + ", but did not respond to #{predicate_name}"
        end # let

        include_context 'with a spec file with examples',
          "include_examples 'should have predicate', :undefined_predicate?, true"

        include_examples 'should fail with 1 example and 1 failure'
      end # describe

      describe 'with the name of a private predicate' do
        let(:predicate_name) { ':private_predicate?' }
        let(:failure_message) do
          super() + ", but did not respond to #{predicate_name}"
        end # let

        include_context 'with a spec file with examples',
          "include_examples 'should have predicate', :private_predicate?, true"

        include_examples 'should fail with 1 example and 1 failure'
      end # describe

      describe 'with the name of a public predicate' do
        let(:predicate_name) { ':public_predicate?' }
        let(:failure_message) do
          super() + ', but returned nil'
        end # let

        include_context 'with a spec file with examples',
          "include_examples 'should have predicate', :public_predicate?, true"

        include_examples 'should fail with 1 example and 1 failure'
      end # describe
    end # describe

    describe 'with a matching value expectation' do
      describe 'with the name of a public predicate' do
        include_context 'with a spec file with examples',
          "include_examples 'should have predicate', :public_predicate_with_value?, true"

        include_examples 'should pass with 1 example and 0 failures'
      end # describe
    end # describe
  end # describe
end # describe
