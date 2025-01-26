# spec/rspec/sleeping_king_studios/examples/property_examples/properties_spec.rb

require 'rspec/sleeping_king_studios/examples/property_examples'

require 'support/shared_examples/file_examples'
require 'support/shared_examples/shared_example_group_examples'

RSpec.describe RSpec::SleepingKingStudios::Examples::PropertyExamples do
  include Spec::Support::SharedExamples::FileExamples
  include Spec::Support::SharedExamples::SharedExampleGroupExamples

  def self.spec_namespace
    %w(examples property_examples properties)
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
        require_relative 'class_with_properties'

        require 'rspec/sleeping_king_studios/examples/property_examples'

        RSpec.describe ClassWithProperties do
          include RSpec::SleepingKingStudios::Examples::PropertyExamples

          subject(:instance) { described_class.new }

          #{ custom_contents }
        end # describe
      RUBY

    include_examples 'with a spec file containing', contents
  end # shared_context

  include_context 'with a temporary file named',
    'examples/property_examples/properties/class_with_properties.rb',
    <<-RUBY
      class ClassWithProperties
        attr_accessor \
          :public_property,
          :property_with_private_reader,
          :property_with_private_writer

        private :property_with_private_reader, :property_with_private_writer=

        attr_reader :public_reader

        attr_writer :public_writer

        def inspect
          '#<ClassWithProperties>'
        end # method inspect

        private

        attr_accessor :private_property

        attr_reader :private_reader

        attr_writer :private_writer
      end # class
    RUBY

  describe '"should have property"' do
    let(:failure_message) do
      "expected #<ClassWithProperties> to respond to #{property_name} and " \
      "#{property_name}="
    end # let

    include_examples 'should alias shared example group',
      'should have property',
      'defines property'

    include_examples 'should alias shared example group',
      'should have property',
      'has property'

    include_examples 'should alias shared example group',
      'should have property',
      'should define property'

    describe 'with the name of an undefined property' do
      let(:property_name) { ':undefined_property' }
      let(:failure_message) do
        super() + ", but did not respond to #{property_name} or " \
                  "#{property_name}="
      end # let

      include_context 'with a spec file with examples',
        "include_examples 'should have property', :undefined_property"

      include_examples 'should fail with 1 example and 1 failure'
    end # describe

    describe 'with the name of a public reader' do
      let(:property_name) { ':public_reader' }
      let(:failure_message) do
        super() + ", but did not respond to #{property_name}="
      end # let

      include_context 'with a spec file with examples',
        "include_examples 'should have property', :public_reader"

      include_examples 'should fail with 1 example and 1 failure'
    end # describe

    describe 'with the name of a public writer' do
      let(:property_name) { ':public_writer' }
      let(:failure_message) do
        super() + ", but did not respond to #{property_name}"
      end # let

      include_context 'with a spec file with examples',
        "include_examples 'should have property', :public_writer"

      include_examples 'should fail with 1 example and 1 failure'
    end # describe

    describe 'with the name of a property with a private reader' do
      let(:property_name) { ':property_with_private_reader' }
      let(:failure_message) do
        super() + ", but did not respond to #{property_name}"
      end # let

      include_context 'with a spec file with examples',
        "include_examples 'should have property', :property_with_private_reader"

      include_examples 'should fail with 1 example and 1 failure'
    end # describe

    describe 'with the name of a property with a private writer' do
      let(:property_name) { ':property_with_private_writer' }
      let(:failure_message) do
        super() + ", but did not respond to #{property_name}="
      end # let

      include_context 'with a spec file with examples',
        "include_examples 'should have property', :property_with_private_writer"

      include_examples 'should fail with 1 example and 1 failure'
    end # describe

    describe 'with the name of a private property' do
      let(:property_name) { ':private_property' }
      let(:failure_message) do
        super() + ", but did not respond to #{property_name} or " \
                  "#{property_name}="
      end # let

      include_context 'with a spec file with examples',
        "include_examples 'should have property', :private_property"

      include_examples 'should fail with 1 example and 1 failure'
    end # describe

    describe 'with the name of a public property' do
      include_context 'with a spec file with examples',
        "include_examples 'should have property', :public_property"

      include_examples 'should pass with 1 example and 0 failures'
    end # describe

    describe 'with :allow_private => true' do
      describe 'with the name of an undefined property' do
        let(:property_name) { ':undefined_property' }
        let(:failure_message) do
          super() + ", but did not respond to #{property_name} or " \
                    "#{property_name}="
        end # let

        include_context 'with a spec file with examples',
          "include_examples 'should have property', :undefined_property" \
          ", :allow_private => true"

        include_examples 'should fail with 1 example and 1 failure'
      end # describe

      describe 'with the name of a public reader' do
        let(:property_name) { ':public_reader' }
        let(:failure_message) do
          super() + ", but did not respond to #{property_name}="
        end # let

        include_context 'with a spec file with examples',
          "include_examples 'should have property', :public_reader" \
          ", :allow_private => true"

        include_examples 'should fail with 1 example and 1 failure'
      end # describe

      describe 'with the name of a public writer' do
        let(:property_name) { ':public_writer' }
        let(:failure_message) do
          super() + ", but did not respond to #{property_name}"
        end # let

        include_context 'with a spec file with examples',
          "include_examples 'should have property', :public_writer" \
          ", :allow_private => true"

        include_examples 'should fail with 1 example and 1 failure'
      end # describe

      describe 'with the name of a property with a private reader' do
        include_context 'with a spec file with examples',
          "include_examples 'should have property', :property_with_private_reader" \
          ", :allow_private => true"

        include_examples 'should pass with 1 example and 0 failures'
      end # describe

      describe 'with the name of a property with a private writer' do
        include_context 'with a spec file with examples',
          "include_examples 'should have property', :property_with_private_writer" \
          ", :allow_private => true"

        include_examples 'should pass with 1 example and 0 failures'
      end # describe

      describe 'with the name of a private property' do
        include_context 'with a spec file with examples',
          "include_examples 'should have property', :private_property" \
          ", :allow_private => true"

        include_examples 'should pass with 1 example and 0 failures'
      end # describe

      describe 'with the name of a public property' do
        include_context 'with a spec file with examples',
          "include_examples 'should have property', :public_property" \
          ", :allow_private => true"

        include_examples 'should pass with 1 example and 0 failures'
      end # describe
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
          "include_examples 'should have property', :undefined_property, 42"

        include_examples 'should fail with 1 example and 1 failure'
      end # describe

      describe 'with the name of a public reader' do
        let(:property_name) { ':public_reader' }
        let(:failure_message) do
          super() + ", but did not respond to #{property_name}="
        end # let

        include_context 'with a spec file with examples',
          "include_examples 'should have property', :public_reader, 42"

        include_examples 'should fail with 1 example and 1 failure'
      end # describe

      describe 'with the name of a public writer' do
        let(:property_name) { ':public_writer' }
        let(:failure_message) do
          super() + ", but did not respond to #{property_name}"
        end # let

        include_context 'with a spec file with examples',
          "include_examples 'should have property', :public_writer, 42"

        include_examples 'should fail with 1 example and 1 failure'
      end # describe

      describe 'with the name of a property with a private reader' do
        let(:property_name) { ':property_with_private_reader' }
        let(:failure_message) do
          super() + ", but did not respond to #{property_name}"
        end # let

        include_context 'with a spec file with examples',
          "include_examples 'should have property', :property_with_private_reader, 42"

        include_examples 'should fail with 1 example and 1 failure'
      end # describe

      describe 'with the name of a property with a private writer' do
        let(:property_name) { ':property_with_private_writer' }
        let(:failure_message) do
          super() + ", but did not respond to #{property_name}="
        end # let

        include_context 'with a spec file with examples',
          "include_examples 'should have property', :property_with_private_writer, 42"

        include_examples 'should fail with 1 example and 1 failure'
      end # describe

      describe 'with the name of a private property' do
        let(:property_name) { ':private_property' }
        let(:failure_message) do
          super() + ", but did not respond to #{property_name} or " \
                    "#{property_name}="
        end # let

        include_context 'with a spec file with examples',
          "include_examples 'should have property', :private_property, 42"

        include_examples 'should fail with 1 example and 1 failure'
      end # describe

      describe 'with the name of a public property' do
        let(:property_name) { ':public_property' }
        let(:failure_message) do
          super() + ', but returned nil'
        end # let

        include_context 'with a spec file with examples',
          "include_examples 'should have property', :public_property, 42"

        include_examples 'should fail with 1 example and 1 failure'
      end # describe

      describe 'with :allow_private => true' do
        describe 'with the name of an undefined property' do
          let(:property_name) { ':undefined_property' }
          let(:failure_message) do
            super() + ", but did not respond to #{property_name} or " \
                      "#{property_name}="
          end # let

          include_context 'with a spec file with examples',
            "include_examples 'should have property', :undefined_property, 42" \
            ", :allow_private => true"

          include_examples 'should fail with 1 example and 1 failure'
        end # describe

        describe 'with the name of a public reader' do
          let(:property_name) { ':public_reader' }
          let(:failure_message) do
            super() + ", but did not respond to #{property_name}="
          end # let

          include_context 'with a spec file with examples',
            "include_examples 'should have property', :public_reader, 42" \
            ", :allow_private => true"

          include_examples 'should fail with 1 example and 1 failure'
        end # describe

        describe 'with the name of a public writer' do
          let(:property_name) { ':public_writer' }
          let(:failure_message) do
            super() + ", but did not respond to #{property_name}"
          end # let

          include_context 'with a spec file with examples',
            "include_examples 'should have property', :public_writer, 42" \
            ", :allow_private => true"

          include_examples 'should fail with 1 example and 1 failure'
        end # describe

        describe 'with the name of a property with a private reader' do
          let(:property_name) { ':property_with_private_reader' }
          let(:failure_message) do
            super() + ', but returned nil'
          end # let

          include_context 'with a spec file with examples',
            "include_examples 'should have property', :property_with_private_reader, 42" \
            ", :allow_private => true"

          include_examples 'should fail with 1 example and 1 failure'
        end # describe

        describe 'with the name of a property with a private writer' do
          let(:property_name) { ':property_with_private_writer' }
          let(:failure_message) do
            super() + ', but returned nil'
          end # let

          include_context 'with a spec file with examples',
            "include_examples 'should have property', :property_with_private_writer, 42" \
            ", :allow_private => true"

          include_examples 'should fail with 1 example and 1 failure'
        end # describe

        describe 'with the name of a private property' do
          let(:property_name) { ':private_property' }
          let(:failure_message) do
            super() + ', but returned nil'
          end # let

          include_context 'with a spec file with examples',
            "include_examples 'should have property', :private_property, 42" \
            ", :allow_private => true"

          include_examples 'should fail with 1 example and 1 failure'
        end # describe

        describe 'with the name of a public property' do
          let(:property_name) { ':public_property' }
          let(:failure_message) do
            super() + ', but returned nil'
          end # let

          include_context 'with a spec file with examples',
            "include_examples 'should have property', :public_property, 42" \
            ", :allow_private => true"

          include_examples 'should fail with 1 example and 1 failure'
        end # describe
      end # describe
    end # describe

    describe 'with a matching value expectation' do
      describe 'with the name of a public property' do
        include_context 'with a spec file with examples',
          "before(:example) { instance.public_property = 42 }" \
          "\n\ninclude_examples 'should have property', :public_property, 42"

        include_examples 'should pass with 1 example and 0 failures'
      end # describe

      describe 'with :allow_private => true' do
        describe 'with the name of a private property' do
          include_context 'with a spec file with examples',
            "before(:example) { instance.send :private_property=, 42 }" \
            "\n\ninclude_examples 'should have property', :private_property, 42" \
            ", :allow_private => true"

          include_examples 'should pass with 1 example and 0 failures'
        end # describe
      end # describe
    end # describe
  end # describe

  describe '"should have reader"' do
    let(:failure_message) do
      "expected #<ClassWithProperties> to respond to #{reader_name}"
    end # let

    include_examples 'should alias shared example group',
      'should have reader',
      'defines reader'

    include_examples 'should alias shared example group',
      'should have reader',
      'has reader'

    include_examples 'should alias shared example group',
      'should have reader',
      'should define reader'

    describe 'with the name of an undefined method' do
      let(:reader_name) { ':undefined_reader' }
      let(:failure_message) do
        super() + ", but did not respond to #{reader_name}"
      end # let

      include_context 'with a spec file with examples',
        "include_examples 'should have reader', :undefined_reader"

      include_examples 'should fail with 1 example and 1 failure'
    end # describe

    describe 'with the name of a private reader' do
      let(:reader_name) { ':private_reader' }
      let(:failure_message) do
        super() + ", but did not respond to #{reader_name}"
      end # let

      include_context 'with a spec file with examples',
        "include_examples 'should have reader', :private_reader"

      include_examples 'should fail with 1 example and 1 failure'
    end # describe

    describe 'with the name of a public reader' do
      include_context 'with a spec file with examples',
        "include_examples 'should have reader', :public_reader"

      include_examples 'should pass with 1 example and 0 failures'
    end # describe

    describe 'with :allow_private => true' do
      describe 'with the name of an undefined method' do
        let(:reader_name) { ':undefined_reader' }
        let(:failure_message) do
          super() + ", but did not respond to #{reader_name}"
        end # let

        include_context 'with a spec file with examples',
          "include_examples 'should have reader', :undefined_reader" \
          ", :allow_private => true"

        include_examples 'should fail with 1 example and 1 failure'
      end # describe

      describe 'with the name of a private reader' do
        include_context 'with a spec file with examples',
          "include_examples 'should have reader', :private_reader" \
          ", :allow_private => true"

        include_examples 'should pass with 1 example and 0 failures'
      end # describe

      describe 'with the name of a public reader' do
        include_context 'with a spec file with examples',
          "include_examples 'should have reader', :public_reader" \
          ", :allow_private => true"

        include_examples 'should pass with 1 example and 0 failures'
      end # describe
    end # describe

    describe 'with a non-matching value expectation' do
      let(:failure_message) { super() + ' and return 42' }

      describe 'with the name of an undefined method' do
        let(:reader_name) { ':undefined_reader' }
        let(:failure_message) do
          super() + ", but did not respond to #{reader_name}"
        end # let

        include_context 'with a spec file with examples',
          "include_examples 'should have reader', :undefined_reader, 42"

        include_examples 'should fail with 1 example and 1 failure'
      end # describe

      describe 'with the name of a private reader' do
        let(:reader_name) { ':private_reader' }
        let(:failure_message) do
          super() + ", but did not respond to #{reader_name}"
        end # let

        include_context 'with a spec file with examples',
          "include_examples 'should have reader', :private_reader, 42"

        include_examples 'should fail with 1 example and 1 failure'
      end # describe

      describe 'with the name of a public reader' do
        let(:reader_name) { ':public_reader' }
        let(:failure_message) do
          super() + ', but returned nil'
        end # let

        include_context 'with a spec file with examples',
          "include_examples 'should have reader', :public_reader, 42"

        include_examples 'should fail with 1 example and 1 failure'
      end # describe

      describe 'with :allow_private => true' do
        describe 'with the name of an undefined method' do
          let(:reader_name) { ':undefined_reader' }
          let(:failure_message) do
            super() + ", but did not respond to #{reader_name}"
          end # let

          include_context 'with a spec file with examples',
            "include_examples 'should have reader', :undefined_reader, 42" \
            ", :allow_private => true"

          include_examples 'should fail with 1 example and 1 failure'
        end # describe

        describe 'with the name of a private reader' do
          let(:reader_name) { ':private_reader' }
          let(:failure_message) do
            super() + ', but returned nil'
          end # let

          include_context 'with a spec file with examples',
            "include_examples 'should have reader', :private_reader, 42" \
            ", :allow_private => true"

          include_examples 'should fail with 1 example and 1 failure'
        end # describe

        describe 'with the name of a public reader' do
          let(:reader_name) { ':public_reader' }
          let(:failure_message) do
            super() + ', but returned nil'
          end # let

          include_context 'with a spec file with examples',
            "include_examples 'should have reader', :public_reader, 42" \
            ", :allow_private => true"

          include_examples 'should fail with 1 example and 1 failure'
        end # describe
      end # describe
    end # describe

    describe 'with a matching value expectation' do
      describe 'with the name of a public reader' do
        include_context 'with a spec file with examples',
          "before(:example) { instance.public_property = 42 }" \
          "\n\ninclude_examples 'should have reader', :public_property, 42"

        include_examples 'should pass with 1 example and 0 failures'
      end # describe

      describe 'with :allow_private => true' do
        describe 'with the name of a private reader' do
          include_context 'with a spec file with examples',
            "before(:example) { instance.send :private_property=, 42 }" \
            "\n\ninclude_examples 'should have reader', :private_property, 42" \
            ", :allow_private => true"

          include_examples 'should pass with 1 example and 0 failures'
        end # describe
      end # describe
    end # describe
  end # describe

  describe '"should have writer"' do
    let(:failure_message) do
      "expected #<ClassWithProperties> to respond to #{writer_name}"
    end # let

    include_examples 'should alias shared example group',
      'should have writer',
      'defines writer'

    include_examples 'should alias shared example group',
      'should have writer',
      'has writer'

    include_examples 'should alias shared example group',
      'should have writer',
      'should define writer'

    describe 'with the name of an undefined method' do
      let(:writer_name) { ':undefined_writer=' }
      let(:failure_message) do
        super() + ", but did not respond to #{writer_name}"
      end # let

      include_context 'with a spec file with examples',
        "include_examples 'should have writer', :undefined_writer"

      include_examples 'should fail with 1 example and 1 failure'
    end # describe

    describe 'with the name of an undefined method' do
      let(:writer_name) { ':undefined_writer=' }
      let(:failure_message) do
        super() + ", but did not respond to #{writer_name}"
      end # let

      include_context 'with a spec file with examples',
        "include_examples 'should have writer', :undefined_writer="

      include_examples 'should fail with 1 example and 1 failure'
    end # describe

    describe 'with the name of a private writer' do
      let(:writer_name) { ':private_writer=' }
      let(:failure_message) do
        super() + ", but did not respond to #{writer_name}"
      end # let

      include_context 'with a spec file with examples',
        "include_examples 'should have writer', :private_writer"

      include_examples 'should fail with 1 example and 1 failure'
    end # describe

    describe 'with the name of a private writer' do
      let(:writer_name) { ':private_writer=' }
      let(:failure_message) do
        super() + ", but did not respond to #{writer_name}"
      end # let

      include_context 'with a spec file with examples',
        "include_examples 'should have writer', :private_writer="

      include_examples 'should fail with 1 example and 1 failure'
    end # describe

    describe 'with the name of a public writer' do
      include_context 'with a spec file with examples',
        "include_examples 'should have writer', :public_writer"

      include_examples 'should pass with 1 example and 0 failures'
    end # describe

    describe 'with the name of a public writer' do
      include_context 'with a spec file with examples',
        "include_examples 'should have writer', :public_writer="

      include_examples 'should pass with 1 example and 0 failures'
    end # describe

    describe 'with :allow_private => true' do
      describe 'with the name of an undefined method' do
        let(:writer_name) { ':undefined_writer=' }
        let(:failure_message) do
          super() + ", but did not respond to #{writer_name}"
        end # let

        include_context 'with a spec file with examples',
          "include_examples 'should have writer', :undefined_writer=" \
          ", :allow_private => true"

        include_examples 'should fail with 1 example and 1 failure'
      end # describe

      describe 'with the name of a public writer' do
        include_context 'with a spec file with examples',
          "include_examples 'should have writer', :private_writer=" \
          ", :allow_private => true"

        include_examples 'should pass with 1 example and 0 failures'
      end # describe

      describe 'with the name of a public writer' do
        include_context 'with a spec file with examples',
          "include_examples 'should have writer', :public_writer="

        include_examples 'should pass with 1 example and 0 failures'
      end # describe
    end # describe
  end # describe

  describe '"should not have reader"' do
    let(:failure_message) do
      "expected #<ClassWithProperties> not to respond to #{reader_name}"
    end # let

    include_examples 'should alias shared example group',
      'should not have reader',
      'does not define reader'

    include_examples 'should alias shared example group',
      'should not have reader',
      'does not have reader'

    include_examples 'should alias shared example group',
      'should not have reader',
      'should not define reader'

    describe 'with the name of an undefined method' do
      include_context 'with a spec file with examples',
        "include_examples 'should not have reader', :undefined_reader"

      include_examples 'should pass with 1 example and 0 failures'
    end # describe

    describe 'with the name of a private reader' do
      include_context 'with a spec file with examples',
        "include_examples 'should not have reader', :private_reader"

      include_examples 'should pass with 1 example and 0 failures'
    end # describe

    describe 'with the name of a public reader' do
      let(:reader_name) { ':public_reader' }
      let(:failure_message) do
        super() + ", but responded to #{reader_name}"
      end # let

      include_context 'with a spec file with examples',
        "include_examples 'should not have reader', :public_reader"

      include_examples 'should fail with 1 example and 1 failure'
    end # describe

    describe 'with :allow_private => true' do
      describe 'with the name of an undefined method' do
        include_context 'with a spec file with examples',
          "include_examples 'should not have reader', :undefined_reader" \
          ", :allow_private => true"

        include_examples 'should pass with 1 example and 0 failures'
      end # describe

      describe 'with the name of a private reader' do
        let(:reader_name) { ':private_reader' }
        let(:failure_message) do
          super() + ", but responded to #{reader_name}"
        end # let

        include_context 'with a spec file with examples',
          "include_examples 'should not have reader', :private_reader" \
          ", :allow_private => true"

        include_examples 'should fail with 1 example and 1 failure'
      end # describe

      describe 'with the name of a public reader' do
        let(:reader_name) { ':public_reader' }
        let(:failure_message) do
          super() + ", but responded to #{reader_name}"
        end # let

        include_context 'with a spec file with examples',
          "include_examples 'should not have reader', :public_reader" \
          ", :allow_private => true"

        include_examples 'should fail with 1 example and 1 failure'
      end # describe
    end # describe
  end # describe

  describe '"should not have writer"' do
    let(:failure_message) do
      "expected #<ClassWithProperties> not to respond to #{writer_name}"
    end # let

    include_examples 'should alias shared example group',
      'should not have writer',
      'does not define writer'

    include_examples 'should alias shared example group',
      'should not have writer',
      'does not have writer'

    include_examples 'should alias shared example group',
      'should not have writer',
      'should not define writer'

    describe 'with the name of an undefined method' do
      include_context 'with a spec file with examples',
        "include_examples 'should not have writer', :undefined_writer"

      include_examples 'should pass with 1 example and 0 failures'
    end # describe

    describe 'with the name of an undefined method' do
      include_context 'with a spec file with examples',
        "include_examples 'should not have writer', :undefined_writer="

      include_examples 'should pass with 1 example and 0 failures'
    end # describe

    describe 'with the name of a private writer' do
      include_context 'with a spec file with examples',
        "include_examples 'should not have writer', :private_writer"

      include_examples 'should pass with 1 example and 0 failures'
    end # describe

    describe 'with the name of a private writer' do
      include_context 'with a spec file with examples',
        "include_examples 'should not have writer', :private_writer="

      include_examples 'should pass with 1 example and 0 failures'
    end # describe

    describe 'with the name of a public writer' do
      let(:writer_name) { ':public_writer=' }
      let(:failure_message) do
        super() + ", but responded to #{writer_name}"
      end # let

      include_context 'with a spec file with examples',
        "include_examples 'should not have writer', :public_writer"

      include_examples 'should fail with 1 example and 1 failure'
    end # describe

    describe 'with the name of a public writer' do
      let(:writer_name) { ':public_writer=' }
      let(:failure_message) do
        super() + ", but responded to #{writer_name}"
      end # let

      include_context 'with a spec file with examples',
        "include_examples 'should not have writer', :public_writer="

      include_examples 'should fail with 1 example and 1 failure'
    end # describe

    describe 'with :allow_private => true' do
      describe 'with the name of an undefined method' do
        include_context 'with a spec file with examples',
          "include_examples 'should not have writer', :undefined_writer=" \
          ", :allow_private => true"

        include_examples 'should pass with 1 example and 0 failures'
      end # describe

      describe 'with the name of a private writer' do
        let(:writer_name) { ':private_writer=' }
        let(:failure_message) do
          super() + ", but responded to #{writer_name}"
        end # let

        include_context 'with a spec file with examples',
          "include_examples 'should not have writer', :private_writer=" \
          ", :allow_private => true"

        include_examples 'should fail with 1 example and 1 failure'
      end # describe

      describe 'with the name of a public writer' do
        let(:writer_name) { ':public_writer=' }
        let(:failure_message) do
          super() + ", but responded to #{writer_name}"
        end # let

        include_context 'with a spec file with examples',
          "include_examples 'should not have writer', :public_writer=" \
          ", :allow_private => true"

        include_examples 'should fail with 1 example and 1 failure'
      end # describe
    end # describe
  end # describe
end # describe
