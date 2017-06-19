# spec/rspec/sleeping_king_studios/examples/property_examples/class_properties_spec.rb

require 'spec_helper'

require 'rspec/sleeping_king_studios/examples/property_examples'

require 'support/file_examples'

RSpec.describe RSpec::SleepingKingStudios::Examples::PropertyExamples do
  include Spec::Support::FileExamples

  def self.spec_namespace
    %w(examples property_examples class_properties)
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
        require_relative 'class_with_class_properties'

        require 'rspec/sleeping_king_studios/examples/property_examples'

        RSpec.describe ClassWithClassProperties do
          include RSpec::SleepingKingStudios::Examples::PropertyExamples

          subject(:instance) { described_class.new }

          #{ custom_contents }
        end # describe
      RUBY

    include_examples 'with a spec file containing', contents
  end # shared_examples

  include_context 'with a temporary file named',
    'examples/property_examples/class_properties/class_with_class_properties.rb',
    <<-RUBY
      class ClassWithClassProperties
        class << self
          attr_accessor :class_property

          attr_reader :class_reader

          attr_writer :class_writer

          private

          attr_accessor :private_class_property

          attr_reader :private_class_reader

          attr_writer :private_class_writer
        end # class << self
      end # class
    RUBY

  describe '"has class reader"' do
    describe 'with the name of an undefined class method' do
      include_context 'with a spec file with examples',
        "include_examples 'has class reader', :undefined_class_reader"

      it 'should fail with 1 example, 1 failure' do
        results = run_spec_file

        expect(results).to include '1 example, 1 failure'
        expect(results).
          to include 'expected ClassWithClassProperties to respond to :undefined_class_reader, but did not respond to :undefined_class_reader'
      end # it
    end # describe

    describe 'with the name of a private class reader' do
      include_context 'with a spec file with examples',
        "include_examples 'has class reader', :private_class_reader"

      it 'should fail with 1 example, 1 failure' do
        results = run_spec_file

        expect(results).to include '1 example, 1 failure'
        expect(results).
          to include 'expected ClassWithClassProperties to respond to :private_class_reader, but did not respond to :private_class_reader'
      end # it
    end # describe

    describe 'with the name of a public class reader' do
      include_context 'with a spec file with examples',
        "include_examples 'has class reader', :class_reader"

      it 'should pass with 1 example, 0 failures' do
        results = run_spec_file

        expect(results).to include '1 example, 0 failures'
      end # it
    end # describe

    describe 'with a non-matching value expectation' do
      describe 'with the name of an undefined class method' do
        include_context 'with a spec file with examples',
          "include_examples 'has class reader', :undefined_class_reader, 42"

        it 'should fail with 1 example, 1 failure' do
          results = run_spec_file

          expect(results).to include '1 example, 1 failure'
          expect(results).
            to include 'expected ClassWithClassProperties to respond to :undefined_class_reader and return 42, but did not respond to :undefined_class_reader'
        end # it
      end # describe

      describe 'with the name of a private class reader' do
        include_context 'with a spec file with examples',
          "include_examples 'has class reader', :private_class_reader, 42"

        it 'should fail with 1 example, 1 failure' do
          results = run_spec_file

          expect(results).to include '1 example, 1 failure'
          expect(results).
            to include 'expected ClassWithClassProperties to respond to :private_class_reader and return 42, but did not respond to :private_class_reader'
        end # it
      end # describe

      describe 'with the name of a public class reader' do
        include_context 'with a spec file with examples',
          "include_examples 'has class reader', :class_reader, 42"

        it 'should fail with 1 example, 1 failure' do
          results = run_spec_file

          expect(results).to include '1 example, 1 failure'
          expect(results).
            to include 'expected ClassWithClassProperties to respond to :class_reader and return 42, but returned nil'
        end # it
      end # describe
    end # describe

    describe 'with a matching value expectation' do
      describe 'with the name of a private reader method' do
        include_context 'with a spec file with examples',
          "before(:example) { described_class.send(:class_property=, 42) }"\
          "\n\ninclude_examples 'has class reader', :class_property, 42"

        it 'should pass with 1 example, 0 failures' do
          results = run_spec_file

          expect(results).to include '1 example, 0 failures'
        end # it
      end # describe
    end # describe
  end # describe

  describe '"should have class reader"' do
    describe 'with the name of an undefined class method' do
      include_context 'with a spec file with examples',
        "include_examples 'should have class reader', :undefined_class_reader"

      it 'should fail with 1 example, 1 failure' do
        results = run_spec_file

        expect(results).to include '1 example, 1 failure'
        expect(results).
          to include 'expected ClassWithClassProperties to respond to :undefined_class_reader, but did not respond to :undefined_class_reader'
      end # it
    end # describe

    describe 'with the name of a private class reader' do
      include_context 'with a spec file with examples',
        "include_examples 'should have class reader', :private_class_reader"

      it 'should fail with 1 example, 1 failure' do
        results = run_spec_file

        expect(results).to include '1 example, 1 failure'
        expect(results).
          to include 'expected ClassWithClassProperties to respond to :private_class_reader, but did not respond to :private_class_reader'
      end # it
    end # describe

    describe 'with the name of a public class reader' do
      include_context 'with a spec file with examples',
        "include_examples 'should have class reader', :class_reader"

      it 'should pass with 1 example, 0 failures' do
        results = run_spec_file

        expect(results).to include '1 example, 0 failures'
      end # it
    end # describe

    describe 'with a non-matching value expectation' do
      describe 'with the name of an undefined class method' do
        include_context 'with a spec file with examples',
          "include_examples 'should have class reader', :undefined_class_reader, 42"

        it 'should fail with 1 example, 1 failure' do
          results = run_spec_file

          expect(results).to include '1 example, 1 failure'
          expect(results).
            to include 'expected ClassWithClassProperties to respond to :undefined_class_reader and return 42, but did not respond to :undefined_class_reader'
        end # it
      end # describe

      describe 'with the name of a private class reader' do
        include_context 'with a spec file with examples',
          "include_examples 'should have class reader', :private_class_reader, 42"

        it 'should fail with 1 example, 1 failure' do
          results = run_spec_file

          expect(results).to include '1 example, 1 failure'
          expect(results).
            to include 'expected ClassWithClassProperties to respond to :private_class_reader and return 42, but did not respond to :private_class_reader'
        end # it
      end # describe

      describe 'with the name of a public class reader' do
        include_context 'with a spec file with examples',
          "include_examples 'should have class reader', :class_reader, 42"

        it 'should fail with 1 example, 1 failure' do
          results = run_spec_file

          expect(results).to include '1 example, 1 failure'
          expect(results).
            to include 'expected ClassWithClassProperties to respond to :class_reader and return 42, but returned nil'
        end # it
      end # describe
    end # describe

    describe 'with a matching value expectation' do
      describe 'with the name of a private reader method' do
        include_context 'with a spec file with examples',
          "before(:example) { described_class.send(:class_property=, 42) }"\
          "\n\ninclude_examples 'should have class reader', :class_property, 42"

        it 'should pass with 1 example, 0 failures' do
          results = run_spec_file

          expect(results).to include '1 example, 0 failures'
        end # it
      end # describe
    end # describe
  end # describe

  describe '"does not have class reader"' do
    describe 'with the name of an undefined class method' do
      include_context 'with a spec file with examples',
        "include_examples 'does not have class reader', :undefined_class_reader"

      it 'should pass with 1 example, 0 failures' do
        results = run_spec_file

        expect(results).to include '1 example, 0 failures'
      end # it
    end # describe

    describe 'with the name of a private class method' do
      include_context 'with a spec file with examples',
        "include_examples 'does not have class reader', :private_class_reader"

      it 'should pass with 1 example, 0 failures' do
        results = run_spec_file

        expect(results).to include '1 example, 0 failures'
      end # it
    end # describe

    describe 'with the name of a public class method' do
      include_context 'with a spec file with examples',
        "include_examples 'does not have class reader', :class_reader"

      it 'should fail with 1 example, 1 failure' do
        results = run_spec_file

        expect(results).to include '1 example, 1 failure'
        expect(results).
          to include 'expected ClassWithClassProperties not to respond to :class_reader, but responded to :class_reader'
      end # it
    end # describe
  end # describe

  describe '"should not have class reader"' do
    describe 'with the name of an undefined class method' do
      include_context 'with a spec file with examples',
        "include_examples 'should not have class reader', :undefined_class_reader"

      it 'should pass with 1 example, 0 failures' do
        results = run_spec_file

        expect(results).to include '1 example, 0 failures'
      end # it
    end # describe

    describe 'with the name of a private class method' do
      include_context 'with a spec file with examples',
        "include_examples 'should not have class reader', :private_class_reader"

      it 'should pass with 1 example, 0 failures' do
        results = run_spec_file

        expect(results).to include '1 example, 0 failures'
      end # it
    end # describe

    describe 'with the name of a public class method' do
      include_context 'with a spec file with examples',
        "include_examples 'should not have class reader', :class_reader"

      it 'should fail with 1 example, 1 failure' do
        results = run_spec_file

        expect(results).to include '1 example, 1 failure'
        expect(results).
          to include 'expected ClassWithClassProperties not to respond to :class_reader, but responded to :class_reader'
      end # it
    end # describe
  end # describe

  describe '"has class writer"' do
    describe 'with the name of an undefined class method' do
      include_context 'with a spec file with examples',
        "include_examples 'has class writer', :undefined_class_writer"

      it 'should fail with 1 example, 1 failure' do
        results = run_spec_file

        expect(results).to include '1 example, 1 failure'
        expect(results).
          to include 'expected ClassWithClassProperties to respond to :undefined_class_writer=, but did not respond to :undefined_class_writer='
      end # it
    end # describe

    describe 'with the name of a private class writer' do
      include_context 'with a spec file with examples',
        "include_examples 'has class writer', :private_class_writer"

      it 'should fail with 1 example, 1 failure' do
        results = run_spec_file

        expect(results).to include '1 example, 1 failure'
        expect(results).
          to include 'expected ClassWithClassProperties to respond to :private_class_writer=, but did not respond to :private_class_writer='
      end # it
    end # describe

    describe 'with the name of a public class writer' do
      include_context 'with a spec file with examples',
        "include_examples 'has class writer', :class_writer"

      it 'should pass with 1 example, 0 failures' do
        results = run_spec_file

        expect(results).to include '1 example, 0 failures'
      end # it
    end # describe
  end # describe

  describe '"should have class writer"' do
    describe 'with the name of an undefined class method' do
      include_context 'with a spec file with examples',
        "include_examples 'should have class writer', :undefined_class_writer"

      it 'should fail with 1 example, 1 failure' do
        results = run_spec_file

        expect(results).to include '1 example, 1 failure'
        expect(results).
          to include 'expected ClassWithClassProperties to respond to :undefined_class_writer=, but did not respond to :undefined_class_writer='
      end # it
    end # describe

    describe 'with the name of a private class writer' do
      include_context 'with a spec file with examples',
        "include_examples 'should have class writer', :private_class_writer"

      it 'should fail with 1 example, 1 failure' do
        results = run_spec_file

        expect(results).to include '1 example, 1 failure'
        expect(results).
          to include 'expected ClassWithClassProperties to respond to :private_class_writer=, but did not respond to :private_class_writer='
      end # it
    end # describe

    describe 'with the name of a public class writer' do
      include_context 'with a spec file with examples',
        "include_examples 'should have class writer', :class_writer"

      it 'should pass with 1 example, 0 failures' do
        results = run_spec_file

        expect(results).to include '1 example, 0 failures'
      end # it
    end # describe
  end # describe

  describe '"does not have class writer"' do
    describe 'with the name of an undefined class method' do
      include_context 'with a spec file with examples',
        "include_examples 'does not have class writer', :undefined_class_writer"

      it 'should pass with 1 example, 0 failures' do
        results = run_spec_file

        expect(results).to include '1 example, 0 failures'
      end # it
    end # describe

    describe 'with the name of a private class method' do
      include_context 'with a spec file with examples',
        "include_examples 'does not have class writer', :private_class_writer"

      it 'should pass with 1 example, 0 failures' do
        results = run_spec_file

        expect(results).to include '1 example, 0 failures'
      end # it
    end # describe

    describe 'with the name of a public class method' do
      include_context 'with a spec file with examples',
        "include_examples 'does not have class writer', :class_writer"

      it 'should fail with 1 example, 1 failure' do
        results = run_spec_file

        expect(results).to include '1 example, 1 failure'
        expect(results).
          to include 'expected ClassWithClassProperties not to respond to :class_writer=, but responded to :class_writer='
      end # it
    end # describe
  end # describe

  describe '"should not have class writer"' do
    describe 'with the name of an undefined class method' do
      include_context 'with a spec file with examples',
        "include_examples 'should not have class writer', :undefined_class_writer"

      it 'should pass with 1 example, 0 failures' do
        results = run_spec_file

        expect(results).to include '1 example, 0 failures'
      end # it
    end # describe

    describe 'with the name of a private class method' do
      include_context 'with a spec file with examples',
        "include_examples 'should not have class writer', :private_class_writer"

      it 'should pass with 1 example, 0 failures' do
        results = run_spec_file

        expect(results).to include '1 example, 0 failures'
      end # it
    end # describe

    describe 'with the name of a public class method' do
      include_context 'with a spec file with examples',
        "include_examples 'should not have class writer', :class_writer"

      it 'should fail with 1 example, 1 failure' do
        results = run_spec_file

        expect(results).to include '1 example, 1 failure'
        expect(results).
          to include 'expected ClassWithClassProperties not to respond to :class_writer=, but responded to :class_writer='
      end # it
    end # describe
  end # describe

  describe '"has class property"' do
    describe 'with the name of an undefined property' do
      include_context 'with a spec file with examples',
        "include_examples 'has class property', :undefined_class_property"

      it 'should fail with 1 example, 1 failure' do
        results = run_spec_file

        expect(results).to include '1 example, 1 failure'
        expect(results).
          to include 'expected ClassWithClassProperties to respond to :undefined_class_property and :undefined_class_property=, but did not respond to :undefined_class_property or :undefined_class_property='
      end # it
    end # describe

    describe 'with the name of a reader method' do
      include_context 'with a spec file with examples',
        "include_examples 'has class property', :class_reader"

      it 'should fail with 1 example, 1 failure' do
        results = run_spec_file

        expect(results).to include '1 example, 1 failure'
        expect(results).
          to include 'expected ClassWithClassProperties to respond to :class_reader and :class_reader=, but did not respond to :class_reader='
      end # it
    end # describe

    describe 'with the name of a writer method' do
      include_context 'with a spec file with examples',
        "include_examples 'has class property', :class_writer"

      it 'should fail with 1 example, 1 failure' do
        results = run_spec_file

        expect(results).to include '1 example, 1 failure'
        expect(results).
          to include 'expected ClassWithClassProperties to respond to :class_writer and :class_writer=, but did not respond to :class_writer'
      end # it
    end # describe

    describe 'with the name of a private property' do
      include_context 'with a spec file with examples',
        "include_examples 'has class property', :private_class_property"

      it 'should fail with 1 example, 1 failure' do
        results = run_spec_file

        expect(results).to include '1 example, 1 failure'
        expect(results).
          to include 'expected ClassWithClassProperties to respond to :private_class_property and :private_class_property=, but did not respond to :private_class_property or :private_class_property='
      end # it
    end # describe

    describe 'with the name of a public property' do
      include_context 'with a spec file with examples',
        "include_examples 'has class property', :class_property"

      it 'should pass with 1 example, 0 failures' do
        results = run_spec_file

        expect(results).to include '1 example, 0 failures'
      end # it
    end # describe

    describe 'with a non-matching value expectation' do
      describe 'with the name of an undefined property' do
        include_context 'with a spec file with examples',
          "include_examples 'has class property', :undefined_class_property, 42"

        it 'should fail with 1 example, 1 failure' do
          results = run_spec_file

          expect(results).to include '1 example, 1 failure'
          expect(results).
            to include 'expected ClassWithClassProperties to respond to :undefined_class_property and :undefined_class_property= and return 42, but did not respond to :undefined_class_property or :undefined_class_property='
        end # it
      end # describe

      describe 'with the name of a reader method' do
        include_context 'with a spec file with examples',
          "include_examples 'has class property', :class_reader, 42"

        it 'should fail with 1 example, 1 failure' do
          results = run_spec_file

          expect(results).to include '1 example, 1 failure'
          expect(results).
            to include 'expected ClassWithClassProperties to respond to :class_reader and :class_reader= and return 42, but did not respond to :class_reader='
        end # it
      end # describe

      describe 'with the name of a writer method' do
        include_context 'with a spec file with examples',
          "include_examples 'has class property', :class_writer, 42"

        it 'should fail with 1 example, 1 failure' do
          results = run_spec_file

          expect(results).to include '1 example, 1 failure'
          expect(results).
            to include 'expected ClassWithClassProperties to respond to :class_writer and :class_writer= and return 42, but did not respond to :class_writer'
        end # it
      end # describe

      describe 'with the name of a private property' do
        include_context 'with a spec file with examples',
          "include_examples 'has class property', :private_class_property, 42"

        it 'should fail with 1 example, 1 failure' do
          results = run_spec_file

          expect(results).to include '1 example, 1 failure'
          expect(results).
            to include 'expected ClassWithClassProperties to respond to :private_class_property and :private_class_property= and return 42, but did not respond to :private_class_property or :private_class_property='
        end # it
      end # describe

      describe 'with the name of a public property' do
        include_context 'with a spec file with examples',
          "include_examples 'has class property', :class_property, 42"

        it 'should fail with 1 example, 1 failure' do
          results = run_spec_file

          expect(results).to include '1 example, 1 failure'
          expect(results).
            to include 'expected ClassWithClassProperties to respond to :class_property and :class_property= and return 42, but returned nil'
        end # it
      end # describe
    end # describe

    describe 'with a matching value expectation' do
      describe 'with the name of a public property' do
        include_context 'with a spec file with examples',
          "before(:example) { described_class.send(:class_property=, 42) }"\
          "\n\ninclude_examples 'has class property', :class_property, 42"

        it 'should pass with 1 example, 0 failures' do
          results = run_spec_file

          expect(results).to include '1 example, 0 failures'
        end # it
      end # describe
    end # describe
  end # describe

  describe '"should have class property"' do
    describe 'with the name of an undefined property' do
      include_context 'with a spec file with examples',
        "include_examples 'should have class property', :undefined_class_property"

      it 'should fail with 1 example, 1 failure' do
        results = run_spec_file

        expect(results).to include '1 example, 1 failure'
        expect(results).
          to include 'expected ClassWithClassProperties to respond to :undefined_class_property and :undefined_class_property=, but did not respond to :undefined_class_property or :undefined_class_property='
      end # it
    end # describe

    describe 'with the name of a reader method' do
      include_context 'with a spec file with examples',
        "include_examples 'should have class property', :class_reader"

      it 'should fail with 1 example, 1 failure' do
        results = run_spec_file

        expect(results).to include '1 example, 1 failure'
        expect(results).
          to include 'expected ClassWithClassProperties to respond to :class_reader and :class_reader=, but did not respond to :class_reader='
      end # it
    end # describe

    describe 'with the name of a writer method' do
      include_context 'with a spec file with examples',
        "include_examples 'should have class property', :class_writer"

      it 'should fail with 1 example, 1 failure' do
        results = run_spec_file

        expect(results).to include '1 example, 1 failure'
        expect(results).
          to include 'expected ClassWithClassProperties to respond to :class_writer and :class_writer=, but did not respond to :class_writer'
      end # it
    end # describe

    describe 'with the name of a private property' do
      include_context 'with a spec file with examples',
        "include_examples 'should have class property', :private_class_property"

      it 'should fail with 1 example, 1 failure' do
        results = run_spec_file

        expect(results).to include '1 example, 1 failure'
        expect(results).
          to include 'expected ClassWithClassProperties to respond to :private_class_property and :private_class_property=, but did not respond to :private_class_property or :private_class_property='
      end # it
    end # describe

    describe 'with the name of a public property' do
      include_context 'with a spec file with examples',
        "include_examples 'should have class property', :class_property"

      it 'should pass with 1 example, 0 failures' do
        results = run_spec_file

        expect(results).to include '1 example, 0 failures'
      end # it
    end # describe

    describe 'with a non-matching value expectation' do
      describe 'with the name of an undefined property' do
        include_context 'with a spec file with examples',
          "include_examples 'should have class property', :undefined_class_property, 42"

        it 'should fail with 1 example, 1 failure' do
          results = run_spec_file

          expect(results).to include '1 example, 1 failure'
          expect(results).
            to include 'expected ClassWithClassProperties to respond to :undefined_class_property and :undefined_class_property= and return 42, but did not respond to :undefined_class_property or :undefined_class_property='
        end # it
      end # describe

      describe 'with the name of a reader method' do
        include_context 'with a spec file with examples',
          "include_examples 'should have class property', :class_reader, 42"

        it 'should fail with 1 example, 1 failure' do
          results = run_spec_file

          expect(results).to include '1 example, 1 failure'
          expect(results).
            to include 'expected ClassWithClassProperties to respond to :class_reader and :class_reader= and return 42, but did not respond to :class_reader='
        end # it
      end # describe

      describe 'with the name of a writer method' do
        include_context 'with a spec file with examples',
          "include_examples 'should have class property', :class_writer, 42"

        it 'should fail with 1 example, 1 failure' do
          results = run_spec_file

          expect(results).to include '1 example, 1 failure'
          expect(results).
            to include 'expected ClassWithClassProperties to respond to :class_writer and :class_writer= and return 42, but did not respond to :class_writer'
        end # it
      end # describe

      describe 'with the name of a private property' do
        include_context 'with a spec file with examples',
          "include_examples 'should have class property', :private_class_property, 42"

        it 'should fail with 1 example, 1 failure' do
          results = run_spec_file

          expect(results).to include '1 example, 1 failure'
          expect(results).
            to include 'expected ClassWithClassProperties to respond to :private_class_property and :private_class_property= and return 42, but did not respond to :private_class_property or :private_class_property='
        end # it
      end # describe

      describe 'with the name of a public property' do
        include_context 'with a spec file with examples',
          "include_examples 'should have class property', :class_property, 42"

        it 'should fail with 1 example, 1 failure' do
          results = run_spec_file

          expect(results).to include '1 example, 1 failure'
          expect(results).
            to include 'expected ClassWithClassProperties to respond to :class_property and :class_property= and return 42, but returned nil'
        end # it
      end # describe
    end # describe

    describe 'with a matching value expectation' do
      describe 'with the name of a public property' do
        include_context 'with a spec file with examples',
          "before(:example) { described_class.send(:class_property=, 42) }"\
          "\n\ninclude_examples 'should have class property', :class_property, 42"

        it 'should pass with 1 example, 0 failures' do
          results = run_spec_file

          expect(results).to include '1 example, 0 failures'
        end # it
      end # describe
    end # describe
  end # describe
end # describe
