# spec/rspec/sleeping_king_studios/examples/property_examples/constants_spec.rb

require 'spec_helper'

require 'rspec/sleeping_king_studios/examples/property_examples'

require 'support/file_examples'

RSpec.describe RSpec::SleepingKingStudios::Examples::PropertyExamples do
  include Spec::Support::FileExamples

  def self.spec_namespace
    %w(examples property_examples constants)
  end # class method spec_namespace

  shared_examples 'with a spec file with examples' do |custom_contents|
    custom_contents =
      tools.
        string.
        map_lines(custom_contents) do |line, index|
          index.zero? ? line : "#{' ' * 10}#{line}"
        end # map_lines
    contents =
      <<-RUBY
        require_relative 'module_with_constants'

        require 'rspec/sleeping_king_studios/examples/property_examples'

        RSpec.describe ModuleWithConstants do
          include RSpec::SleepingKingStudios::Examples::PropertyExamples

          subject(:instance) { described_class.new }

          #{ custom_contents }
        end # describe
      RUBY

    include_examples 'with a spec file containing', contents
  end # shared_examples

  include_context 'with a temporary file named',
    'examples/property_examples/constants/module_with_constants.rb',
    <<-RUBY
      module ModuleWithConstants
        DEFINED_CONSTANT            = Object.new
        DEFINED_CONSTANT_WITH_VALUE = 'The Answer'

        IMMUTABLE_CONSTANT            = Object.new.freeze
        IMMUTABLE_CONSTANT_WITH_VALUE = 'The Answer'.freeze
      end # module
    RUBY

  describe '"has constant"' do
    describe 'with the name of an undefined constant' do
      include_context 'with a spec file with examples',
        "include_examples 'has constant', :UNDEFINED_CONSTANT"

      it 'should fail with 1 example, 1 failure' do
        results = run_spec_file

        expect(results).to include '1 example, 1 failure'
        expect(results).
          to include 'expected ModuleWithConstants to have constant :UNDEFINED_CONSTANT, but ModuleWithConstants does not define constant :UNDEFINED_CONSTANT'
      end # it
    end # describe

    describe 'with the name of a defined constant' do
      include_context 'with a spec file with examples',
        "include_examples 'has constant', :DEFINED_CONSTANT"

      it 'should pass with 1 example, 0 failures' do
        results = run_spec_file

        expect(results).to include '1 example, 0 failures'
      end # it
    end # describe

    describe 'with a non-matching value expectation' do
      describe 'with the name of an undefined constant' do
        include_context 'with a spec file with examples',
          "include_examples 'has constant', :UNDEFINED_CONSTANT, 42"

        it 'should fail with 1 example, 1 failure' do
          results = run_spec_file

          expect(results).to include '1 example, 1 failure'
          expect(results).
            to include 'expected ModuleWithConstants to have constant :UNDEFINED_CONSTANT with value 42, but ModuleWithConstants does not define constant :UNDEFINED_CONSTANT'
        end # it
      end # describe

      describe 'with the name of a defined constant' do
        include_context 'with a spec file with examples',
          "include_examples 'has constant', :DEFINED_CONSTANT_WITH_VALUE, 42"

        it 'should fail with 1 example, 1 failure' do
          results = run_spec_file

          expect(results).to include '1 example, 1 failure'
          expect(results).
            to include 'expected ModuleWithConstants to have constant :DEFINED_CONSTANT_WITH_VALUE with value 42, but constant :DEFINED_CONSTANT_WITH_VALUE has value "The Answer"'
        end # it
      end # describe
    end # describe

    describe 'with a matching value expectation' do
      describe 'with the name of a defined constant' do
        include_context 'with a spec file with examples',
          "include_examples 'has constant', :DEFINED_CONSTANT_WITH_VALUE, 'The Answer'"

        it 'should pass with 1 example, 0 failures' do
          results = run_spec_file

          expect(results).to include '1 example, 0 failures'
        end # it
      end # describe
    end # describe
  end # describe

  describe '"should have constant"' do
    describe 'with the name of an undefined constant' do
      include_context 'with a spec file with examples',
        "include_examples 'should have constant', :UNDEFINED_CONSTANT"

      it 'should fail with 1 example, 1 failure' do
        results = run_spec_file

        expect(results).to include '1 example, 1 failure'
        expect(results).
          to include 'expected ModuleWithConstants to have constant :UNDEFINED_CONSTANT, but ModuleWithConstants does not define constant :UNDEFINED_CONSTANT'
      end # it
    end # describe

    describe 'with the name of a defined constant' do
      include_context 'with a spec file with examples',
        "include_examples 'should have constant', :DEFINED_CONSTANT"

      it 'should pass with 1 example, 0 failures' do
        results = run_spec_file

        expect(results).to include '1 example, 0 failures'
      end # it
    end # describe

    describe 'with a non-matching value expectation' do
      describe 'with the name of an undefined constant' do
        include_context 'with a spec file with examples',
          "include_examples 'should have constant', :UNDEFINED_CONSTANT, 42"

        it 'should fail with 1 example, 1 failure' do
          results = run_spec_file

          expect(results).to include '1 example, 1 failure'
          expect(results).
            to include 'expected ModuleWithConstants to have constant :UNDEFINED_CONSTANT with value 42, but ModuleWithConstants does not define constant :UNDEFINED_CONSTANT'
        end # it
      end # describe

      describe 'with the name of a defined constant' do
        include_context 'with a spec file with examples',
          "include_examples 'should have constant', :DEFINED_CONSTANT_WITH_VALUE, 42"

        it 'should fail with 1 example, 1 failure' do
          results = run_spec_file

          expect(results).to include '1 example, 1 failure'
          expect(results).
            to include 'expected ModuleWithConstants to have constant :DEFINED_CONSTANT_WITH_VALUE with value 42, but constant :DEFINED_CONSTANT_WITH_VALUE has value "The Answer"'
        end # it
      end # describe
    end # describe

    describe 'with a matching value expectation' do
      describe 'with the name of a defined constant' do
        include_context 'with a spec file with examples',
          "include_examples 'should have constant', :DEFINED_CONSTANT_WITH_VALUE, 'The Answer'"

        it 'should pass with 1 example, 0 failures' do
          results = run_spec_file

          expect(results).to include '1 example, 0 failures'
        end # it
      end # describe
    end # describe
  end # describe

  describe '"has immutable constant"' do
    describe 'with the name of an undefined constant' do
      include_context 'with a spec file with examples',
        "include_examples 'has immutable constant', :UNDEFINED_CONSTANT"

      it 'should fail with 1 example, 1 failure' do
        results = run_spec_file

        expect(results).to include '1 example, 1 failure'
        expect(results).
          to include 'expected ModuleWithConstants to have immutable constant :UNDEFINED_CONSTANT, but ModuleWithConstants does not define constant :UNDEFINED_CONSTANT'
      end # it
    end # describe

    describe 'with the name of a mutable constant' do
      include_context 'with a spec file with examples',
        "include_examples 'has immutable constant', :DEFINED_CONSTANT"

      it 'should fail with 1 example, 1 failure' do
        results = run_spec_file

        expect(results).to include '1 example, 1 failure'
        expect(results).
          to include 'expected ModuleWithConstants to have immutable constant :DEFINED_CONSTANT, but the value of :DEFINED_CONSTANT was mutable'
      end # it
    end # describe

    describe 'with the name of an immutable constant' do
      include_context 'with a spec file with examples',
        "include_examples 'has constant', :IMMUTABLE_CONSTANT"

      it 'should pass with 1 example, 0 failures' do
        results = run_spec_file

        expect(results).to include '1 example, 0 failures'
      end # it
    end # describe

    describe 'with a non-matching value expectation' do
      describe 'with the name of an undefined constant' do
        include_context 'with a spec file with examples',
          "include_examples 'has immutable constant', :UNDEFINED_CONSTANT, 42"

        it 'should fail with 1 example, 1 failure' do
          results = run_spec_file

          expect(results).to include '1 example, 1 failure'
          expect(results).
            to include 'expected ModuleWithConstants to have immutable constant :UNDEFINED_CONSTANT with value 42, but ModuleWithConstants does not define constant :UNDEFINED_CONSTANT'
        end # it
      end # describe

      describe 'with the name of a mutable constant' do
        include_context 'with a spec file with examples',
          "include_examples 'has immutable constant', :DEFINED_CONSTANT_WITH_VALUE, 42"

        it 'should fail with 1 example, 1 failure' do
          results = run_spec_file

          expect(results).to include '1 example, 1 failure'
          expect(results).
            to include 'expected ModuleWithConstants to have immutable constant :DEFINED_CONSTANT_WITH_VALUE with value 42, but constant :DEFINED_CONSTANT_WITH_VALUE has value "The Answer" and the value of :DEFINED_CONSTANT_WITH_VALUE was mutable'
        end # it
      end # describe

      describe 'with the name of an immutable constant' do
        include_context 'with a spec file with examples',
          "include_examples 'has constant', :IMMUTABLE_CONSTANT_WITH_VALUE, 42"

        it 'should fail with 1 example, 1 failure' do
          results = run_spec_file

          expect(results).to include '1 example, 1 failure'
          expect(results).
            to include 'expected ModuleWithConstants to have constant :IMMUTABLE_CONSTANT_WITH_VALUE with value 42, but constant :IMMUTABLE_CONSTANT_WITH_VALUE has value "The Answer"'
        end # it
      end # describe
    end # describe

    describe 'with a matching value expectation' do
      describe 'with the name of an immutable constant' do
        include_context 'with a spec file with examples',
          "include_examples 'has constant', :IMMUTABLE_CONSTANT_WITH_VALUE, 'The Answer'"

        it 'should pass with 1 example, 0 failures' do
          results = run_spec_file

          expect(results).to include '1 example, 0 failures'
        end # it
      end # describe
    end # describe
  end # describe

  describe '"should have immutable constant"' do
    describe 'with the name of an undefined constant' do
      include_context 'with a spec file with examples',
        "include_examples 'should have immutable constant', :UNDEFINED_CONSTANT"

      it 'should fail with 1 example, 1 failure' do
        results = run_spec_file

        expect(results).to include '1 example, 1 failure'
        expect(results).
          to include 'expected ModuleWithConstants to have immutable constant :UNDEFINED_CONSTANT, but ModuleWithConstants does not define constant :UNDEFINED_CONSTANT'
      end # it
    end # describe

    describe 'with the name of a mutable constant' do
      include_context 'with a spec file with examples',
        "include_examples 'should have immutable constant', :DEFINED_CONSTANT"

      it 'should fail with 1 example, 1 failure' do
        results = run_spec_file

        expect(results).to include '1 example, 1 failure'
        expect(results).
          to include 'expected ModuleWithConstants to have immutable constant :DEFINED_CONSTANT, but the value of :DEFINED_CONSTANT was mutable'
      end # it
    end # describe

    describe 'with the name of an immutable constant' do
      include_context 'with a spec file with examples',
        "include_examples 'has constant', :IMMUTABLE_CONSTANT"

      it 'should pass with 1 example, 0 failures' do
        results = run_spec_file

        expect(results).to include '1 example, 0 failures'
      end # it
    end # describe

    describe 'with a non-matching value expectation' do
      describe 'with the name of an undefined constant' do
        include_context 'with a spec file with examples',
          "include_examples 'should have immutable constant', :UNDEFINED_CONSTANT, 42"

        it 'should fail with 1 example, 1 failure' do
          results = run_spec_file

          expect(results).to include '1 example, 1 failure'
          expect(results).
            to include 'expected ModuleWithConstants to have immutable constant :UNDEFINED_CONSTANT with value 42, but ModuleWithConstants does not define constant :UNDEFINED_CONSTANT'
        end # it
      end # describe

      describe 'with the name of a mutable constant' do
        include_context 'with a spec file with examples',
          "include_examples 'should have immutable constant', :DEFINED_CONSTANT_WITH_VALUE, 42"

        it 'should fail with 1 example, 1 failure' do
          results = run_spec_file

          expect(results).to include '1 example, 1 failure'
          expect(results).
            to include 'expected ModuleWithConstants to have immutable constant :DEFINED_CONSTANT_WITH_VALUE with value 42, but constant :DEFINED_CONSTANT_WITH_VALUE has value "The Answer" and the value of :DEFINED_CONSTANT_WITH_VALUE was mutable'
        end # it
      end # describe

      describe 'with the name of an immutable constant' do
        include_context 'with a spec file with examples',
          "include_examples 'has constant', :IMMUTABLE_CONSTANT_WITH_VALUE, 42"

        it 'should fail with 1 example, 1 failure' do
          results = run_spec_file

          expect(results).to include '1 example, 1 failure'
          expect(results).
            to include 'expected ModuleWithConstants to have constant :IMMUTABLE_CONSTANT_WITH_VALUE with value 42, but constant :IMMUTABLE_CONSTANT_WITH_VALUE has value "The Answer"'
        end # it
      end # describe
    end # describe

    describe 'with a matching value expectation' do
      describe 'with the name of an immutable constant' do
        include_context 'with a spec file with examples',
          "include_examples 'has constant', :IMMUTABLE_CONSTANT_WITH_VALUE, 'The Answer'"

        it 'should pass with 1 example, 0 failures' do
          results = run_spec_file

          expect(results).to include '1 example, 0 failures'
        end # it
      end # describe
    end # describe
  end # describe
end # describe
