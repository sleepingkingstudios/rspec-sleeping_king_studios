# spec/rspec/sleeping_king_studios/examples/property_examples/class_properties_spec.rb

require 'spec_helper'

require 'rspec/sleeping_king_studios/examples/property_examples'

require 'support/shared_examples/file_examples'
require 'support/shared_examples/shared_example_group_examples'

RSpec.describe RSpec::SleepingKingStudios::Examples::PropertyExamples do
  include Spec::Support::SharedExamples::FileExamples
  include Spec::Support::SharedExamples::SharedExampleGroupExamples

  def self.spec_namespace
    %w(examples property_examples class_properties)
  end # class method spec_namespace

  shared_context 'with a spec file with examples' do |custom_contents|
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
  end # shared_context

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

  describe '"should have class property"' do
    let(:failure_message) do
      "expected ClassWithClassProperties to respond to #{property_name} and " \
      "#{property_name}="
    end # let

    include_examples 'should alias shared example group',
      'should have class property',
      'defines class property'

    include_examples 'should alias shared example group',
      'should have class property',
      'has class property'

    include_examples 'should alias shared example group',
      'should have class property',
      'should define class property'

    describe 'with the name of an undefined property' do
      let(:property_name) { ':undefined_class_property' }
      let(:failure_message) do
        super() + ", but did not respond to #{property_name} or " \
                  "#{property_name}="
      end # let

      include_context 'with a spec file with examples',
        "include_examples 'should have class property', :undefined_class_property"

      include_examples 'should fail with 1 example and 1 failure'
    end # describe

    describe 'with the name of a reader method' do
      let(:property_name) { ':class_reader' }
      let(:failure_message) do
        super() + ", but did not respond to #{property_name}="
      end # let

      include_context 'with a spec file with examples',
        "include_examples 'should have class property', :class_reader"

      include_examples 'should fail with 1 example and 1 failure'
    end # describe

    describe 'with the name of a writer method' do
      let(:property_name) { ':class_writer' }
      let(:failure_message) do
        super() + ", but did not respond to #{property_name}"
      end # let

      include_context 'with a spec file with examples',
        "include_examples 'should have class property', :class_writer"

      include_examples 'should fail with 1 example and 1 failure'
    end # describe

    describe 'with the name of a private property' do
      let(:property_name) { ':private_class_property' }
      let(:failure_message) do
        super() + ", but did not respond to #{property_name} or " \
                  "#{property_name}="
      end # let

      include_context 'with a spec file with examples',
        "include_examples 'should have class property', :private_class_property"

      include_examples 'should fail with 1 example and 1 failure'
    end # describe

    describe 'with the name of a public property' do
      include_context 'with a spec file with examples',
        "include_examples 'should have class property', :class_property"

      include_examples 'should pass with 1 example and 0 failures'
    end # describe

    describe 'with a non-matching value expectation' do
      let(:failure_message) do
        super() + ' and return 42'
      end # let

      describe 'with the name of an undefined property' do
        let(:property_name) { ':undefined_class_property' }
        let(:failure_message) do
          super() + ", but did not respond to #{property_name} or " \
                    "#{property_name}="
        end # let

        include_context 'with a spec file with examples',
          "include_examples 'should have class property', :undefined_class_property, 42"

        include_examples 'should fail with 1 example and 1 failure'
      end # describe

      describe 'with the name of a reader method' do
        let(:property_name) { ':class_reader' }
        let(:failure_message) do
          super() + ", but did not respond to #{property_name}="
        end # let

        include_context 'with a spec file with examples',
          "include_examples 'should have class property', :class_reader, 42"

        include_examples 'should fail with 1 example and 1 failure'
      end # describe

      describe 'with the name of a writer method' do
        let(:property_name) { ':class_writer' }
        let(:failure_message) do
          super() + ", but did not respond to #{property_name}"
        end # let

        include_context 'with a spec file with examples',
          "include_examples 'should have class property', :class_writer, 42"

        include_examples 'should fail with 1 example and 1 failure'
      end # describe

      describe 'with the name of a private property' do
        let(:property_name) { ':private_class_property' }
        let(:failure_message) do
          super() + ", but did not respond to #{property_name} or " \
                    "#{property_name}="
        end # let

        include_context 'with a spec file with examples',
          "include_examples 'should have class property', :private_class_property, 42"

        include_examples 'should fail with 1 example and 1 failure'
      end # describe

      describe 'with the name of a public property' do
        let(:property_name) { ':class_property' }
        let(:failure_message) do
          super() + ', but returned nil'
        end # let

        include_context 'with a spec file with examples',
          "include_examples 'should have class property', :class_property, 42"

        include_examples 'should fail with 1 example and 1 failure'
      end # describe
    end # describe

    describe 'with a matching value expectation' do
      describe 'with the name of a public property' do
        include_context 'with a spec file with examples',
          "before(:example) { described_class.send(:class_property=, 42) }"\
          "\n\ninclude_examples 'should have class property', :class_property, 42"

        include_examples 'should pass with 1 example and 0 failures'
      end # describe
    end # describe
  end # describe

  describe '"should have class reader"' do
    let(:failure_message) do
      "expected ClassWithClassProperties to respond to #{reader_name}"
    end # let

    include_examples 'should alias shared example group',
      'should have class reader',
      'defines class reader'

    include_examples 'should alias shared example group',
      'should have class reader',
      'has class reader'

    include_examples 'should alias shared example group',
      'should have class reader',
      'should define class reader'

    describe 'with the name of an undefined class method' do
      let(:reader_name) { ':undefined_class_reader' }
      let(:failure_message) do
        super() + ", but did not respond to #{reader_name}"
      end # let

      include_context 'with a spec file with examples',
        "include_examples 'should have class reader', :undefined_class_reader"

      include_examples 'should fail with 1 example and 1 failure'
    end # describe

    describe 'with the name of a private class reader' do
      let(:reader_name) { ':private_class_reader' }
      let(:failure_message) do
        super() + ", but did not respond to #{reader_name}"
      end # let

      include_context 'with a spec file with examples',
        "include_examples 'should have class reader', :private_class_reader"

      include_examples 'should fail with 1 example and 1 failure'
    end # describe

    describe 'with the name of a public class reader' do
      include_context 'with a spec file with examples',
        "include_examples 'should have class reader', :class_reader"

      include_examples 'should pass with 1 example and 0 failures'
    end # describe

    describe 'with a non-matching value expectation' do
      let(:failure_message) do
        super() + ' and return 42'
      end # let

      describe 'with the name of an undefined class method' do
        let(:reader_name) { ':undefined_class_reader' }
        let(:failure_message) do
          super() + ", but did not respond to #{reader_name}"
        end # let

        include_context 'with a spec file with examples',
          "include_examples 'should have class reader', :undefined_class_reader, 42"

        include_examples 'should fail with 1 example and 1 failure'
      end # describe

      describe 'with the name of a private class reader' do
        let(:reader_name) { ':private_class_reader' }
        let(:failure_message) do
          super() + ", but did not respond to #{reader_name}"
        end # let

        include_context 'with a spec file with examples',
          "include_examples 'should have class reader', :private_class_reader, 42"

        include_examples 'should fail with 1 example and 1 failure'
      end # describe

      describe 'with the name of a public class reader' do
        let(:reader_name) { ':class_reader' }
        let(:failure_message) do
          super() + ', but returned nil'
        end # let

        include_context 'with a spec file with examples',
          "include_examples 'should have class reader', :class_reader, 42"

        include_examples 'should fail with 1 example and 1 failure'
      end # describe
    end # describe

    describe 'with a matching value expectation' do
      describe 'with the name of a private reader method' do
        include_context 'with a spec file with examples',
          "before(:example) { described_class.send(:class_property=, 42) }"\
          "\n\ninclude_examples 'should have class reader', :class_property, 42"

        include_examples 'should pass with 1 example and 0 failures'
      end # describe
    end # describe
  end # describe

  describe '"should have class writer"' do
    let(:failure_message) do
      "expected ClassWithClassProperties to respond to #{writer_name}"
    end # let

    include_examples 'should alias shared example group',
      'should have class writer',
      'defines class writer'

    include_examples 'should alias shared example group',
      'should have class writer',
      'has class writer'

    include_examples 'should alias shared example group',
      'should have class writer',
      'should define class writer'

    describe 'with the name of an undefined class method' do
      let(:writer_name) { ':undefined_class_writer=' }
      let(:failure_message) do
        super() + ", but did not respond to #{writer_name}"
      end # let

      include_context 'with a spec file with examples',
        "include_examples 'should have class writer', :undefined_class_writer"

      include_examples 'should fail with 1 example and 1 failure'
    end # describe

    describe 'with the name of an undefined class method' do
      let(:writer_name) { ':undefined_class_writer=' }
      let(:failure_message) do
        super() + ", but did not respond to #{writer_name}"
      end # let

      include_context 'with a spec file with examples',
        "include_examples 'should have class writer', :undefined_class_writer="

      include_examples 'should fail with 1 example and 1 failure'
    end # describe

    describe 'with the name of a private class writer' do
      let(:writer_name) { ':private_class_writer=' }
      let(:failure_message) do
        super() + ", but did not respond to #{writer_name}"
      end # let

      include_context 'with a spec file with examples',
        "include_examples 'should have class writer', :private_class_writer"

      include_examples 'should fail with 1 example and 1 failure'
    end # describe

    describe 'with the name of a private class writer' do
      let(:writer_name) { ':private_class_writer=' }
      let(:failure_message) do
        super() + ", but did not respond to #{writer_name}"
      end # let

      include_context 'with a spec file with examples',
        "include_examples 'should have class writer', :private_class_writer="

      include_examples 'should fail with 1 example and 1 failure'
    end # describe

    describe 'with the name of a public class writer' do
      include_context 'with a spec file with examples',
        "include_examples 'should have class writer', :class_writer"

      include_examples 'should pass with 1 example and 0 failures'
    end # describe

    describe 'with the name of a public class writer' do
      include_context 'with a spec file with examples',
        "include_examples 'should have class writer', :class_writer="

      include_examples 'should pass with 1 example and 0 failures'
    end # describe
  end # describe

  describe '"should not have class reader"' do
    let(:failure_message) do
      "expected ClassWithClassProperties not to respond to #{reader_name}"
    end # let

    include_examples 'should alias shared example group',
      'should not have class reader',
      'does not define class reader'

    include_examples 'should alias shared example group',
      'should not have class reader',
      'does not have class reader'

    include_examples 'should alias shared example group',
      'should not have class reader',
      'should not define class reader'

    describe 'with the name of an undefined class method' do
      include_context 'with a spec file with examples',
        "include_examples 'should not have class reader', :undefined_class_reader"

      include_examples 'should pass with 1 example and 0 failures'
    end # describe

    describe 'with the name of a private class method' do
      include_context 'with a spec file with examples',
        "include_examples 'should not have class reader', :private_class_reader"

      include_examples 'should pass with 1 example and 0 failures'
    end # describe

    describe 'with the name of a public class method' do
      let(:reader_name) { ':class_reader' }
      let(:failure_message) do
        super() + ', but responded to :class_reader'
      end # let

      include_context 'with a spec file with examples',
        "include_examples 'should not have class reader', :class_reader"

      include_examples 'should fail with 1 example and 1 failure'
    end # describe
  end # describe

  describe '"should not have class writer"' do
    let(:failure_message) do
      "expected ClassWithClassProperties not to respond to #{writer_name}"
    end # let

    include_examples 'should alias shared example group',
      'should not have class writer',
      'does not define class writer'

    include_examples 'should alias shared example group',
      'should not have class writer',
      'does not have class writer'

    include_examples 'should alias shared example group',
      'should not have class writer',
      'should not define class writer'

    describe 'with the name of an undefined class method' do
      include_context 'with a spec file with examples',
        "include_examples 'should not have class writer', :undefined_class_writer"

      include_examples 'should pass with 1 example and 0 failures'
    end # describe

    describe 'with the name of an undefined class method' do
      include_context 'with a spec file with examples',
        "include_examples 'should not have class writer', :undefined_class_writer="

      include_examples 'should pass with 1 example and 0 failures'
    end # describe

    describe 'with the name of a private class method' do
      include_context 'with a spec file with examples',
        "include_examples 'should not have class writer', :private_class_writer"

      include_examples 'should pass with 1 example and 0 failures'
    end # describe

    describe 'with the name of a private class method' do
      include_context 'with a spec file with examples',
        "include_examples 'should not have class writer', :private_class_writer="

      include_examples 'should pass with 1 example and 0 failures'
    end # describe

    describe 'with the name of a public class method' do
      let(:writer_name) { ':class_writer=' }
      let(:failure_message) do
        super() + ", but responded to #{writer_name}"
      end # let

      include_context 'with a spec file with examples',
        "include_examples 'should not have class writer', :class_writer"

      include_examples 'should fail with 1 example and 1 failure'
    end # describe

    describe 'with the name of a public class method' do
      let(:writer_name) { ':class_writer=' }
      let(:failure_message) do
        super() + ", but responded to #{writer_name}"
      end # let

      include_context 'with a spec file with examples',
        "include_examples 'should not have class writer', :class_writer="

      include_examples 'should fail with 1 example and 1 failure'
    end # describe
  end # describe
end # describe
