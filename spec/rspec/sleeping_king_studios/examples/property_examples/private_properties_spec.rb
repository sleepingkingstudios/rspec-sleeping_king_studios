# spec/rspec/sleeping_king_studios/examples/property_examples/private_properties_spec.rb

require 'spec_helper'

require 'rspec/sleeping_king_studios/examples/property_examples'

require 'support/file_examples'

RSpec.describe RSpec::SleepingKingStudios::Examples::PropertyExamples do
  include Spec::Support::FileExamples

  def self.spec_namespace
    %w(examples property_examples private_properties)
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
        require_relative 'class_with_private_properties'

        require 'rspec/sleeping_king_studios/examples/property_examples'

        RSpec.describe ClassWithPrivateProperties do
          include RSpec::SleepingKingStudios::Examples::PropertyExamples

          subject(:instance) { described_class.new }

          #{ custom_contents }
        end # describe
      RUBY

    include_examples 'with a spec file containing', contents
  end # shared_examples

  include_context 'with a temporary file named',
    'examples/property_examples/private_properties/class_with_private_properties.rb',
    <<-RUBY
      class ClassWithPrivateProperties
        attr_accessor \
          :public_property,
          :property_with_private_reader,
          :property_with_private_writer

        private \
          :property_with_private_reader,
          :property_with_private_writer=

        def inspect
          '#<ClassWithPrivateProperties>'
        end # method inspect

        private

        attr_accessor :private_property

        attr_reader :private_reader

        attr_writer :private_writer
      end # class
    RUBY

  describe '"has private reader"' do
    describe 'with the name of an undefined method' do
      include_context 'with a spec file with examples',
        "include_examples 'has private reader', :undefined_reader"

      it 'should fail with 1 example, 1 failure' do
        results = run_spec_file

        expect(results).to include '1 example, 1 failure'
        expect(results).
          to include 'expected #<ClassWithPrivateProperties> to respond to :undefined_reader, but did not respond to :undefined_reader'
      end # it
    end # describe

    describe 'with the name of a public reader method' do
      include_context 'with a spec file with examples',
        "include_examples 'has private reader', :public_property"

      it 'should fail with 1 example, 1 failure' do
        results = run_spec_file

        expect(results).to include '1 example, 1 failure'
        expect(results).
          to include 'expected #<ClassWithPrivateProperties> not to respond to :public_property'
      end # it
    end # describe

    describe 'with the name of a private reader method' do
      include_context 'with a spec file with examples',
        "include_examples 'has private reader', :private_property"

      it 'should pass with 1 example, 0 failures' do
        results = run_spec_file

        expect(results).to include '1 example, 0 failures'
      end # it
    end # describe

    describe 'with a non-matching value expectation' do
      describe 'with the name of an undefined method' do
        include_context 'with a spec file with examples',
          "include_examples 'has private reader', :undefined_reader, 42"

        it 'should fail with 1 example, 1 failure' do
          results = run_spec_file

          expect(results).to include '1 example, 1 failure'
          expect(results).
            to include 'expected #<ClassWithPrivateProperties> to respond to :undefined_reader and return 42, but did not respond to :undefined_reader'
        end # it
      end # describe

      describe 'with the name of a public reader method' do
        include_context 'with a spec file with examples',
          "include_examples 'has private reader', :public_property, 42"

        it 'should fail with 1 example, 1 failure' do
          results = run_spec_file

          expect(results).to include '1 example, 1 failure'
          expect(results).
            to include 'expected #<ClassWithPrivateProperties> not to respond to :public_property'
        end # it
      end # describe

      describe 'with the name of a private reader method' do
        include_context 'with a spec file with examples',
          "include_examples 'has private reader', :private_property, 42"

        it 'should fail with 1 example, 1 failure' do
          results = run_spec_file

          expect(results).to include '1 example, 1 failure'
          expect(results).
            to include 'expected #<ClassWithPrivateProperties> to respond to :private_property and return 42, but returned nil'
        end # it
      end # describe
    end # describe

    describe 'with a matching value expectation' do
      describe 'with the name of a private reader method' do
        include_context 'with a spec file with examples',
          "before(:example) { instance.send(:private_property=, 42) }"\
          "\n\ninclude_examples 'has private reader', :private_property, 42"

        it 'should pass with 1 example, 0 failures' do
          results = run_spec_file

          expect(results).to include '1 example, 0 failures'
        end # it
      end # describe
    end # describe
  end # describe

  describe '"should have private reader"' do
    describe 'with the name of an undefined method' do
      include_context 'with a spec file with examples',
        "include_examples 'should have private reader', :undefined_reader"

      it 'should fail with 1 example, 1 failure' do
        results = run_spec_file

        expect(results).to include '1 example, 1 failure'
        expect(results).
          to include 'expected #<ClassWithPrivateProperties> to respond to :undefined_reader, but did not respond to :undefined_reader'
      end # it
    end # describe

    describe 'with the name of a public reader method' do
      include_context 'with a spec file with examples',
        "include_examples 'should have private reader', :public_property"

      it 'should fail with 1 example, 1 failure' do
        results = run_spec_file

        expect(results).to include '1 example, 1 failure'
        expect(results).
          to include 'expected #<ClassWithPrivateProperties> not to respond to :public_property'
      end # it
    end # describe

    describe 'with the name of a private reader method' do
      include_context 'with a spec file with examples',
        "include_examples 'should have private reader', :private_property"

      it 'should pass with 1 example, 0 failures' do
        results = run_spec_file

        expect(results).to include '1 example, 0 failures'
      end # it
    end # describe

    describe 'with a non-matching value expectation' do
      describe 'with the name of an undefined method' do
        include_context 'with a spec file with examples',
          "include_examples 'should have private reader', :undefined_reader, 42"

        it 'should fail with 1 example, 1 failure' do
          results = run_spec_file

          expect(results).to include '1 example, 1 failure'
          expect(results).
            to include 'expected #<ClassWithPrivateProperties> to respond to :undefined_reader and return 42, but did not respond to :undefined_reader'
        end # it
      end # describe

      describe 'with the name of a public reader method' do
        include_context 'with a spec file with examples',
          "include_examples 'should have private reader', :public_property, 42"

        it 'should fail with 1 example, 1 failure' do
          results = run_spec_file

          expect(results).to include '1 example, 1 failure'
          expect(results).
            to include 'expected #<ClassWithPrivateProperties> not to respond to :public_property'
        end # it
      end # describe

      describe 'with the name of a private reader method' do
        include_context 'with a spec file with examples',
          "include_examples 'should have private reader', :private_property, 42"

        it 'should fail with 1 example, 1 failure' do
          results = run_spec_file

          expect(results).to include '1 example, 1 failure'
          expect(results).
            to include 'expected #<ClassWithPrivateProperties> to respond to :private_property and return 42, but returned nil'
        end # it
      end # describe
    end # describe

    describe 'with a matching value expectation' do
      describe 'with the name of a private reader method' do
        include_context 'with a spec file with examples',
          "before(:example) { instance.send(:private_property=, 42)}"\
          "\n  include_examples 'should have private reader', :private_property, 42"

        it 'should pass with 1 example, 0 failures' do
          results = run_spec_file

          expect(results).to include '1 example, 0 failures'
        end # it
      end # describe
    end # describe
  end # describe

  describe '"has private writer"' do
    describe 'with the name of an undefined method' do
      include_context 'with a spec file with examples',
        "include_examples 'has private writer', :undefined_writer"

      it 'should fail with 1 example, 1 failure' do
        results = run_spec_file

        expect(results).to include '1 example, 1 failure'
        expect(results).
          to include 'expected #<ClassWithPrivateProperties> to respond to :undefined_writer=, but did not respond to :undefined_writer='
      end # it
    end # describe

    describe 'with the name of a public writer method' do
      include_context 'with a spec file with examples',
        "include_examples 'has private writer', :public_property="

      it 'should fail with 1 example, 1 failure' do
        results = run_spec_file

        expect(results).to include '1 example, 1 failure'
        expect(results).
          to include 'expected #<ClassWithPrivateProperties> not to respond to :public_property='
      end # it
    end # describe

    describe 'with the name of a private writer method' do
      include_context 'with a spec file with examples',
        "include_examples 'has private writer', :private_property="

      it 'should pass with 1 example, 0 failures' do
        results = run_spec_file

        expect(results).to include '1 example, 0 failures'
      end # it
    end # describe
  end # describe

  describe '"should have private writer"' do
    describe 'with the name of an undefined method' do
      include_context 'with a spec file with examples',
        "include_examples 'should have private writer', :undefined_writer"

      it 'should fail with 1 example, 1 failure' do
        results = run_spec_file

        expect(results).to include '1 example, 1 failure'
        expect(results).
          to include 'expected #<ClassWithPrivateProperties> to respond to :undefined_writer=, but did not respond to :undefined_writer='
      end # it
    end # describe

    describe 'with the name of a public writer method' do
      include_context 'with a spec file with examples',
        "include_examples 'should have private writer', :public_property="

      it 'should fail with 1 example, 1 failure' do
        results = run_spec_file

        expect(results).to include '1 example, 1 failure'
        expect(results).
          to include 'expected #<ClassWithPrivateProperties> not to respond to :public_property='
      end # it
    end # describe

    describe 'with the name of a private writer method' do
      include_context 'with a spec file with examples',
        "include_examples 'should have private writer', :private_property="

      it 'should pass with 1 example, 0 failures' do
        results = run_spec_file

        expect(results).to include '1 example, 0 failures'
      end # it
    end # describe
  end # describe

  describe '"has private property"' do
    describe 'with the name of an undefined property' do
      include_context 'with a spec file with examples',
        "include_examples 'has private property', :undefined_property"

      it 'should fail with 1 example, 1 failure' do
        results = run_spec_file

        expect(results).to include '1 example, 1 failure'
        expect(results).
          to include 'expected #<ClassWithPrivateProperties> to respond to :undefined_property and :undefined_property=, but did not respond to :undefined_property or :undefined_property='
      end # it
    end # describe

    describe 'with the name of a private reader' do
      include_context 'with a spec file with examples',
        "include_examples 'has private property', :private_reader"

      it 'should fail with 1 example, 1 failure' do
        results = run_spec_file

        expect(results).to include '1 example, 1 failure'
        expect(results).
          to include 'expected #<ClassWithPrivateProperties> to respond to :private_reader and :private_reader=, but did not respond to :private_reader='
      end # it
    end # describe

    describe 'with the name of a private writer' do
      include_context 'with a spec file with examples',
        "include_examples 'has private property', :private_writer"

      it 'should fail with 1 example, 1 failure' do
        results = run_spec_file

        expect(results).to include '1 example, 1 failure'
        expect(results).
          to include 'expected #<ClassWithPrivateProperties> to respond to :private_writer and :private_writer=, but did not respond to :private_writer'
      end # it
    end # describe

    describe 'with the name of a property with a private reader' do
      include_context 'with a spec file with examples',
        "include_examples 'has private property', :property_with_private_reader"

      it 'should fail with 1 example, 1 failure' do
        results = run_spec_file

        expect(results).to include '1 example, 1 failure'
        expect(results).
          to include 'expected #<ClassWithPrivateProperties> not to respond to :property_with_private_reader='
      end # it
    end # describe

    describe 'with the name of a property with a private writer' do
      include_context 'with a spec file with examples',
        "include_examples 'has private property', :property_with_private_writer"

      it 'should fail with 1 example, 1 failure' do
        results = run_spec_file

        expect(results).to include '1 example, 1 failure'
        expect(results).
          to include 'expected #<ClassWithPrivateProperties> not to respond to :property_with_private_writer'
      end # it
    end # describe

    describe 'with the name of a private property' do
      include_context 'with a spec file with examples',
        "include_examples 'has private property', :private_property"

      it 'should fail with 1 example, 0 failures' do
        results = run_spec_file

        expect(results).to include '1 example, 0 failures'
      end # it
    end # describe

    describe 'with a non-matching value expectation' do
      describe 'with the name of an undefined property' do
        include_context 'with a spec file with examples',
          "include_examples 'has private property', :undefined_property, 42"

        it 'should fail with 1 example, 1 failure' do
          results = run_spec_file

          expect(results).to include '1 example, 1 failure'
          expect(results).
            to include 'expected #<ClassWithPrivateProperties> to respond to :undefined_property and :undefined_property= and return 42, but did not respond to :undefined_property or :undefined_property='
        end # it
      end # describe

      describe 'with the name of a private reader' do
        include_context 'with a spec file with examples',
          "include_examples 'has private property', :private_reader, 42"

        it 'should fail with 1 example, 1 failure' do
          results = run_spec_file

          expect(results).to include '1 example, 1 failure'
          expect(results).
            to include 'expected #<ClassWithPrivateProperties> to respond to :private_reader and :private_reader= and return 42, but did not respond to :private_reader='
        end # it
      end # describe

      describe 'with the name of a private writer' do
        include_context 'with a spec file with examples',
          "include_examples 'has private property', :private_writer, 42"

        it 'should fail with 1 example, 1 failure' do
          results = run_spec_file

          expect(results).to include '1 example, 1 failure'
          expect(results).
            to include 'expected #<ClassWithPrivateProperties> to respond to :private_writer and :private_writer= and return 42, but did not respond to :private_writer'
        end # it
      end # describe

      describe 'with the name of a property with a private reader' do
        include_context 'with a spec file with examples',
          "include_examples 'has private property', :property_with_private_reader, 42"

        it 'should fail with 1 example, 1 failure' do
          results = run_spec_file

          expect(results).to include '1 example, 1 failure'
          expect(results).
            to include 'expected #<ClassWithPrivateProperties> not to respond to :property_with_private_reader='
        end # it
      end # describe

      describe 'with the name of a property with a private writer' do
        include_context 'with a spec file with examples',
          "include_examples 'has private property', :property_with_private_writer, 42"

        it 'should fail with 1 example, 1 failure' do
          results = run_spec_file

          expect(results).to include '1 example, 1 failure'
          expect(results).
            to include 'expected #<ClassWithPrivateProperties> not to respond to :property_with_private_writer'
        end # it
      end # describe

      describe 'with the name of a private property' do
        include_context 'with a spec file with examples',
          "include_examples 'has private property', :private_property, 42"

        it 'should fail with 1 example, 1 failure' do
          results = run_spec_file

          expect(results).to include '1 example, 1 failure'
          expect(results).
            to include 'expected #<ClassWithPrivateProperties> to respond to :private_property and :private_property= and return 42, but returned nil'
        end # it
      end # describe
    end # describe

    describe 'with a matching value expectation' do
      describe 'with the name of a private property' do
        include_context 'with a spec file with examples',
          "before(:example) { instance.send(:private_property=, 42) }"\
          "\n\ninclude_examples 'has private property', :private_property, 42"

        it 'should pass with 1 example, 0 failures' do
          results = run_spec_file

          expect(results).to include '1 example, 0 failures'
        end # it
      end # describe
    end # describe
  end # describe

  describe '"should have private property"' do
    describe 'with the name of an undefined property' do
      include_context 'with a spec file with examples',
        "include_examples 'should have private property', :undefined_property"

      it 'should fail with 1 example, 1 failure' do
        results = run_spec_file

        expect(results).to include '1 example, 1 failure'
        expect(results).
          to include 'expected #<ClassWithPrivateProperties> to respond to :undefined_property and :undefined_property=, but did not respond to :undefined_property or :undefined_property='
      end # it
    end # describe

    describe 'with the name of a private reader' do
      include_context 'with a spec file with examples',
        "include_examples 'should have private property', :private_reader"

      it 'should fail with 1 example, 1 failure' do
        results = run_spec_file

        expect(results).to include '1 example, 1 failure'
        expect(results).
          to include 'expected #<ClassWithPrivateProperties> to respond to :private_reader and :private_reader=, but did not respond to :private_reader='
      end # it
    end # describe

    describe 'with the name of a private writer' do
      include_context 'with a spec file with examples',
        "include_examples 'should have private property', :private_writer"

      it 'should fail with 1 example, 1 failure' do
        results = run_spec_file

        expect(results).to include '1 example, 1 failure'
        expect(results).
          to include 'expected #<ClassWithPrivateProperties> to respond to :private_writer and :private_writer=, but did not respond to :private_writer'
      end # it
    end # describe

    describe 'with the name of a property with a private reader' do
      include_context 'with a spec file with examples',
        "include_examples 'should have private property', :property_with_private_reader"

      it 'should fail with 1 example, 1 failure' do
        results = run_spec_file

        expect(results).to include '1 example, 1 failure'
        expect(results).
          to include 'expected #<ClassWithPrivateProperties> not to respond to :property_with_private_reader='
      end # it
    end # describe

    describe 'with the name of a property with a private writer' do
      include_context 'with a spec file with examples',
        "include_examples 'should have private property', :property_with_private_writer"

      it 'should fail with 1 example, 1 failure' do
        results = run_spec_file

        expect(results).to include '1 example, 1 failure'
        expect(results).
          to include 'expected #<ClassWithPrivateProperties> not to respond to :property_with_private_writer'
      end # it
    end # describe

    describe 'with the name of a private property' do
      include_context 'with a spec file with examples',
        "include_examples 'should have private property', :private_property"

      it 'should fail with 1 example, 0 failures' do
        results = run_spec_file

        expect(results).to include '1 example, 0 failures'
      end # it
    end # describe

    describe 'with a non-matching value expectation' do
      describe 'with the name of an undefined property' do
        include_context 'with a spec file with examples',
          "include_examples 'should have private property', :undefined_property, 42"

        it 'should fail with 1 example, 1 failure' do
          results = run_spec_file

          expect(results).to include '1 example, 1 failure'
          expect(results).
            to include 'expected #<ClassWithPrivateProperties> to respond to :undefined_property and :undefined_property= and return 42, but did not respond to :undefined_property or :undefined_property='
        end # it
      end # describe

      describe 'with the name of a private reader' do
        include_context 'with a spec file with examples',
          "include_examples 'should have private property', :private_reader, 42"

        it 'should fail with 1 example, 1 failure' do
          results = run_spec_file

          expect(results).to include '1 example, 1 failure'
          expect(results).
            to include 'expected #<ClassWithPrivateProperties> to respond to :private_reader and :private_reader= and return 42, but did not respond to :private_reader='
        end # it
      end # describe

      describe 'with the name of a private writer' do
        include_context 'with a spec file with examples',
          "include_examples 'should have private property', :private_writer, 42"

        it 'should fail with 1 example, 1 failure' do
          results = run_spec_file

          expect(results).to include '1 example, 1 failure'
          expect(results).
            to include 'expected #<ClassWithPrivateProperties> to respond to :private_writer and :private_writer= and return 42, but did not respond to :private_writer'
        end # it
      end # describe

      describe 'with the name of a property with a private reader' do
        include_context 'with a spec file with examples',
          "include_examples 'should have private property', :property_with_private_reader, 42"

        it 'should fail with 1 example, 1 failure' do
          results = run_spec_file

          expect(results).to include '1 example, 1 failure'
          expect(results).
            to include 'expected #<ClassWithPrivateProperties> not to respond to :property_with_private_reader='
        end # it
      end # describe

      describe 'with the name of a property with a private writer' do
        include_context 'with a spec file with examples',
          "include_examples 'should have private property', :property_with_private_writer, 42"

        it 'should fail with 1 example, 1 failure' do
          results = run_spec_file

          expect(results).to include '1 example, 1 failure'
          expect(results).
            to include 'expected #<ClassWithPrivateProperties> not to respond to :property_with_private_writer'
        end # it
      end # describe

      describe 'with the name of a private property' do
        include_context 'with a spec file with examples',
          "include_examples 'should have private property', :private_property, 42"

        it 'should fail with 1 example, 1 failure' do
          results = run_spec_file

          expect(results).to include '1 example, 1 failure'
          expect(results).
            to include 'expected #<ClassWithPrivateProperties> to respond to :private_property and :private_property= and return 42, but returned nil'
        end # it
      end # describe
    end # describe

    describe 'with a matching value expectation' do
      describe 'with the name of a private property' do
        include_context 'with a spec file with examples',
          "before(:example) { instance.send(:private_property=, 42) }"\
          "\n\ninclude_examples 'should have private property', :private_property, 42"

        it 'should pass with 1 example, 0 failures' do
          results = run_spec_file

          expect(results).to include '1 example, 0 failures'
        end # it
      end # describe
    end # describe
  end # describe
end # describe
