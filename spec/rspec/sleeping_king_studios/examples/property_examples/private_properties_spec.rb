# spec/rspec/sleeping_king_studios/examples/property_examples/private_properties_spec.rb

require 'spec_helper'

require 'rspec/sleeping_king_studios/examples/property_examples'

require 'support/shared_examples/file_examples'
require 'support/shared_examples/shared_example_group_examples'

RSpec.describe RSpec::SleepingKingStudios::Examples::PropertyExamples do
  include Spec::Support::SharedExamples::FileExamples
  include Spec::Support::SharedExamples::SharedExampleGroupExamples

  def self.spec_namespace
    %w(examples property_examples private_properties)
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
        require_relative 'class_with_private_properties'

        require 'rspec/sleeping_king_studios/examples/property_examples'

        RSpec.describe ClassWithPrivateProperties do
          include RSpec::SleepingKingStudios::Examples::PropertyExamples

          subject(:instance) { described_class.new }

          #{ custom_contents }
        end # describe
      RUBY

    include_examples 'with a spec file containing', contents
  end # shared_context

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

  describe '"should have private reader"' do
    let(:failure_message) do
      "expected #<ClassWithPrivateProperties> to respond to #{reader_name}"
    end # let

    include_examples 'should alias shared example group',
      'has private reader',
      'should have private reader'

    describe 'with the name of an undefined method' do
      let(:reader_name) { ':undefined_reader' }
      let(:failure_message) do
        super() + ", but did not respond to #{reader_name}"
      end # let

      include_context 'with a spec file with examples',
        "include_examples 'should have private reader', :undefined_reader"

      include_examples 'should fail with 1 example and 1 failure'
    end # describe

    describe 'with the name of a public reader method' do
      let(:reader_name) { ':public_property' }
      let(:failure_message) do
        super().sub /to respond/, 'not to respond'
      end # let

      include_context 'with a spec file with examples',
        "include_examples 'should have private reader', :public_property"

      include_examples 'should fail with 1 example and 1 failure'
    end # describe

    describe 'with the name of a private reader method' do
      include_context 'with a spec file with examples',
        "include_examples 'should have private reader', :private_property"

      include_examples 'should pass with 1 example and 0 failures'
    end # describe

    describe 'with a non-matching value expectation' do
      let(:failure_message) do
        super() + ' and return 42'
      end # let

      describe 'with the name of an undefined method' do
        let(:reader_name) { ':undefined_reader' }
        let(:failure_message) do
          super() + ", but did not respond to #{reader_name}"
        end # let

        include_context 'with a spec file with examples',
          "include_examples 'should have private reader', :undefined_reader, 42"

        include_examples 'should fail with 1 example and 1 failure'
      end # describe

      describe 'with the name of a public reader method' do
        let(:reader_name) { ':public_property' }
        let(:failure_message) do
          "expected #<ClassWithPrivateProperties> not to respond to " \
          "#{reader_name}"
        end # let

        include_context 'with a spec file with examples',
          "include_examples 'should have private reader', :public_property, 42"

        include_examples 'should fail with 1 example and 1 failure'
      end # describe

      describe 'with the name of a private reader method' do
        let(:reader_name) { ':private_property' }
        let(:failure_message) do
          super() + ', but returned nil'
        end # let

        include_context 'with a spec file with examples',
          "include_examples 'should have private reader', :private_property, 42"

        include_examples 'should fail with 1 example and 1 failure'
      end # describe
    end # describe

    describe 'with a matching value expectation' do
      describe 'with the name of a private reader method' do
        include_context 'with a spec file with examples',
          "before(:example) { instance.send(:private_property=, 42)}"\
          "\n  include_examples 'should have private reader', :private_property, 42"

        include_examples 'should pass with 1 example and 0 failures'
      end # describe
    end # describe
  end # describe

  describe '"should have private writer"' do
    let(:failure_message) do
      "expected #<ClassWithPrivateProperties> to respond to #{writer_name}"
    end # let

    include_examples 'should alias shared example group',
      'has private writer',
      'should have private writer'

    describe 'with the name of an undefined method' do
      let(:writer_name) { ':undefined_writer=' }
      let(:failure_message) do
        super() + ", but did not respond to #{writer_name}"
      end # let

      include_context 'with a spec file with examples',
        "include_examples 'should have private writer', :undefined_writer"

      include_examples 'should fail with 1 example and 1 failure'
    end # describe

    describe 'with the name of an undefined method' do
      let(:writer_name) { ':undefined_writer=' }
      let(:failure_message) do
        super() + ", but did not respond to #{writer_name}"
      end # let

      include_context 'with a spec file with examples',
        "include_examples 'should have private writer', :undefined_writer="

      include_examples 'should fail with 1 example and 1 failure'
    end # describe

    describe 'with the name of a public writer method' do
      let(:writer_name) { ':public_property=' }
      let(:failure_message) do
        super().sub /to respond/, 'not to respond'
      end # let

      include_context 'with a spec file with examples',
        "include_examples 'should have private writer', :public_property"

      include_examples 'should fail with 1 example and 1 failure'
    end # describe

    describe 'with the name of a public writer method' do
      let(:writer_name) { ':public_property=' }
      let(:failure_message) do
        super().sub /to respond/, 'not to respond'
      end # let

      include_context 'with a spec file with examples',
        "include_examples 'should have private writer', :public_property="

      include_examples 'should fail with 1 example and 1 failure'
    end # describe

    describe 'with the name of a private writer method' do
      include_context 'with a spec file with examples',
        "include_examples 'should have private writer', :private_property"

      include_examples 'should pass with 1 example and 0 failures'
    end # describe

    describe 'with the name of a private writer method' do
      include_context 'with a spec file with examples',
        "include_examples 'should have private writer', :private_property="

      include_examples 'should pass with 1 example and 0 failures'
    end # describe
  end # describe

  describe '"should have private property"' do
    let(:failure_message) do
      "expected #<ClassWithPrivateProperties> to respond to #{property_name}" \
      " and #{property_name}="
    end # let

    include_examples 'should alias shared example group',
      'has private property',
      'should have private property'

    describe 'with the name of an undefined property' do
      let(:property_name) { ':undefined_property' }
      let(:failure_message) do
        super() + ", but did not respond to #{property_name} or " \
                  "#{property_name}="
      end # let

      include_context 'with a spec file with examples',
        "include_examples 'should have private property', :undefined_property"

      include_examples 'should fail with 1 example and 1 failure'
    end # describe

    describe 'with the name of a private reader' do
      let(:property_name) { ':private_reader' }
      let(:failure_message) do
        super() + ", but did not respond to #{property_name}="
      end # let

      include_context 'with a spec file with examples',
        "include_examples 'should have private property', :private_reader"

      include_examples 'should fail with 1 example and 1 failure'
    end # describe

    describe 'with the name of a private writer' do
      let(:property_name) { ':private_writer' }
      let(:failure_message) do
        super() + ", but did not respond to #{property_name}"
      end # let

      include_context 'with a spec file with examples',
        "include_examples 'should have private property', :private_writer"

      include_examples 'should fail with 1 example and 1 failure'
    end # describe

    describe 'with the name of a property with a private reader' do
      let(:property_name) { ':property_with_private_reader' }
      let(:failure_message) do
        "expected #<ClassWithPrivateProperties> not to respond to " \
        "#{property_name}="
      end # let

      include_context 'with a spec file with examples',
        "include_examples 'should have private property', :property_with_private_reader"

      include_examples 'should fail with 1 example and 1 failure'
    end # describe

    describe 'with the name of a property with a private writer' do
      let(:property_name) { ':property_with_private_writer' }
      let(:failure_message) do
        "expected #<ClassWithPrivateProperties> not to respond to " \
        "#{property_name}"
      end # let

      include_context 'with a spec file with examples',
        "include_examples 'should have private property', :property_with_private_writer"

      include_examples 'should fail with 1 example and 1 failure'
    end # describe

    describe 'with the name of a private property' do
      include_context 'with a spec file with examples',
        "include_examples 'should have private property', :private_property"

      include_examples 'should pass with 1 example and 0 failures'
    end # describe

    describe 'with a non-matching value expectation' do
      let(:failure_message) do
        super() + ' and return 42'
      end # let

      describe 'with the name of an undefined property' do
        let(:property_name) { ':undefined_property' }
        let(:failure_message) do
          super() + ", but did not respond to #{property_name} or " \
                    "#{property_name}="
        end # let

        include_context 'with a spec file with examples',
          "include_examples 'should have private property', :undefined_property, 42"

        include_examples 'should fail with 1 example and 1 failure'
      end # describe

      describe 'with the name of a private reader' do
        let(:property_name) { ':private_reader' }
        let(:failure_message) do
          super() + ", but did not respond to #{property_name}="
        end # let

        include_context 'with a spec file with examples',
          "include_examples 'should have private property', :private_reader, 42"

        include_examples 'should fail with 1 example and 1 failure'
      end # describe

      describe 'with the name of a private writer' do
        let(:property_name) { ':private_writer' }
        let(:failure_message) do
          super() + ", but did not respond to #{property_name}"
        end # let

        include_context 'with a spec file with examples',
          "include_examples 'should have private property', :private_writer, 42"

        include_examples 'should fail with 1 example and 1 failure'
      end # describe

      describe 'with the name of a property with a private reader' do
        let(:property_name) { ':property_with_private_reader' }
        let(:failure_message) do
          "expected #<ClassWithPrivateProperties> not to respond to " \
          "#{property_name}="
        end # let

        include_context 'with a spec file with examples',
          "include_examples 'should have private property', :property_with_private_reader, 42"

        include_examples 'should fail with 1 example and 1 failure'
      end # describe

      describe 'with the name of a property with a private writer' do
        let(:property_name) { ':property_with_private_writer' }
        let(:failure_message) do
          "expected #<ClassWithPrivateProperties> not to respond to " \
          "#{property_name}"
        end # let

        include_context 'with a spec file with examples',
          "include_examples 'should have private property', :property_with_private_writer, 42"

        include_examples 'should fail with 1 example and 1 failure'
      end # describe

      describe 'with the name of a private property' do
        let(:property_name) { ':private_property' }
        let(:failure_message) do
          super() + ', but returned nil'
        end # let

        include_context 'with a spec file with examples',
          "include_examples 'should have private property', :private_property, 42"

        include_examples 'should fail with 1 example and 1 failure'
      end # describe
    end # describe

    describe 'with a matching value expectation' do
      describe 'with the name of a private property' do
        include_context 'with a spec file with examples',
          "before(:example) { instance.send(:private_property=, 42) }"\
          "\n\ninclude_examples 'should have private property', :private_property, 42"

        include_examples 'should pass with 1 example and 0 failures'
      end # describe
    end # describe
  end # describe
end # describe
