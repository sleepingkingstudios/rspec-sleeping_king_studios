# spec/rspec/sleeping_king_studios/examples/property_examples/constants_spec.rb

require 'rspec/sleeping_king_studios/examples/property_examples'

require 'support/shared_examples/file_examples'
require 'support/shared_examples/shared_example_group_examples'

RSpec.describe RSpec::SleepingKingStudios::Examples::PropertyExamples do
  include Spec::Support::SharedExamples::FileExamples
  include Spec::Support::SharedExamples::SharedExampleGroupExamples

  def self.spec_namespace
    %w(examples property_examples constants)
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
        require_relative 'module_with_constants'

        require 'rspec/sleeping_king_studios/examples/property_examples'

        RSpec.describe ModuleWithConstants do
          include RSpec::SleepingKingStudios::Examples::PropertyExamples

          subject(:instance) { described_class.new }

          #{ custom_contents }
        end # describe
      RUBY

    include_examples 'with a spec file containing', contents
  end # shared_context

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

  describe '"should have constant"' do
    let(:failure_message) do
      "expected ModuleWithConstants to have constant #{constant_name}"
    end # let

    include_examples 'should alias shared example group',
      'should have constant',
      'defines constant'

    include_examples 'should alias shared example group',
      'should have constant',
      'has constant'

    include_examples 'should alias shared example group',
      'should have constant',
      'should define constant'

    describe 'with the name of an undefined constant' do
      let(:constant_name) { ':UNDEFINED_CONSTANT' }
      let(:failure_message) do
        super() + ", but ModuleWithConstants does not define constant " \
                  "#{constant_name}"
      end # let

      include_context 'with a spec file with examples',
        "include_examples 'should have constant', :UNDEFINED_CONSTANT"

      include_examples 'should fail with 1 example and 1 failure'
    end # describe

    describe 'with the name of a defined constant' do
      include_context 'with a spec file with examples',
        "include_examples 'should have constant', :DEFINED_CONSTANT"

      include_examples 'should pass with 1 example and 0 failures'
    end # describe

    describe 'with a non-matching value expectation' do
      let(:failure_message) do
        super() + ' with value 42'
      end # let

      describe 'with the name of an undefined constant' do
        let(:constant_name) { ':UNDEFINED_CONSTANT' }
        let(:failure_message) do
          super() + ", but ModuleWithConstants does not define constant " \
                    "#{constant_name}"
        end # let

        include_context 'with a spec file with examples',
          "include_examples 'should have constant', :UNDEFINED_CONSTANT, 42"

        include_examples 'should fail with 1 example and 1 failure'
      end # describe

      describe 'with the name of a defined constant' do
        let(:constant_name) { ':DEFINED_CONSTANT_WITH_VALUE' }
        let(:failure_message) do
          super() + ", but constant #{constant_name} has value \"The Answer\""
        end # let

        include_context 'with a spec file with examples',
          "include_examples 'should have constant', :DEFINED_CONSTANT_WITH_VALUE, 42"

        include_examples 'should fail with 1 example and 1 failure'
      end # describe
    end # describe

    describe 'with a matching value expectation' do
      describe 'with the name of a defined constant' do
        include_context 'with a spec file with examples',
          "include_examples 'should have constant', :DEFINED_CONSTANT_WITH_VALUE, 'The Answer'"

        include_examples 'should pass with 1 example and 0 failures'
      end # describe
    end # describe
  end # describe

  describe '"should have immutable constant"' do
    let(:failure_message) do
      "expected ModuleWithConstants to have immutable constant #{constant_name}"
    end # let

    include_examples 'should alias shared example group',
      'should have immutable constant',
      'defines frozen constant'

    include_examples 'should alias shared example group',
      'should have immutable constant',
      'defines immutable constant'

    include_examples 'should alias shared example group',
      'should have immutable constant',
      'has frozen constant'

    include_examples 'should alias shared example group',
      'should have immutable constant',
      'has immutable constant'

    include_examples 'should alias shared example group',
      'should have immutable constant',
      'should define frozen constant'

    include_examples 'should alias shared example group',
      'should have immutable constant',
      'should define immutable constant'

    include_examples 'should alias shared example group',
      'should have immutable constant',
      'should have frozen constant'

    describe 'with the name of an undefined constant' do
      let(:constant_name) { ':UNDEFINED_CONSTANT' }
      let(:failure_message) do
        super() + ", but ModuleWithConstants does not define constant " \
                  "#{constant_name}"
      end # let

      include_context 'with a spec file with examples',
        "include_examples 'should have immutable constant', :UNDEFINED_CONSTANT"

      include_examples 'should fail with 1 example and 1 failure'
    end # describe

    describe 'with the name of a mutable constant' do
      let(:constant_name) { ':DEFINED_CONSTANT' }
      let(:failure_message) do
        super() + ", but the value of #{constant_name} was mutable"
      end # let

      include_context 'with a spec file with examples',
        "include_examples 'should have immutable constant', :DEFINED_CONSTANT"

      include_examples 'should fail with 1 example and 1 failure'
    end # describe

    describe 'with the name of an immutable constant' do
      include_context 'with a spec file with examples',
        "include_examples 'has constant', :IMMUTABLE_CONSTANT"

      include_examples 'should pass with 1 example and 0 failures'
    end # describe

    describe 'with a non-matching value expectation' do
      let(:failure_message) do
        super() + ' with value 42'
      end # let

      describe 'with the name of an undefined constant' do
        let(:constant_name) { ':UNDEFINED_CONSTANT' }
        let(:failure_message) do
          super() + ", but ModuleWithConstants does not define constant " \
                    "#{constant_name}"
        end # let

        include_context 'with a spec file with examples',
          "include_examples 'should have immutable constant', :UNDEFINED_CONSTANT, 42"

        include_examples 'should fail with 1 example and 1 failure'
      end # describe

      describe 'with the name of a mutable constant' do
        let(:constant_name) { ':DEFINED_CONSTANT_WITH_VALUE' }
        let(:failure_message) do
          super() + ", but constant #{constant_name} has value \"The Answer\"" \
                    " and the value of #{constant_name} was mutable"
        end # let

        include_context 'with a spec file with examples',
          "include_examples 'should have immutable constant', :DEFINED_CONSTANT_WITH_VALUE, 42"

        include_examples 'should fail with 1 example and 1 failure'
      end # describe

      describe 'with the name of an immutable constant' do
        let(:constant_name) { ':IMMUTABLE_CONSTANT_WITH_VALUE' }
        let(:failure_message) do
          super() + ", but constant #{constant_name} has value \"The Answer\""
        end # let

        include_context 'with a spec file with examples',
          "include_examples 'has immutable constant', :IMMUTABLE_CONSTANT_WITH_VALUE, 42"

        include_examples 'should fail with 1 example and 1 failure'
      end # describe
    end # describe

    describe 'with a matching value expectation' do
      describe 'with the name of an immutable constant' do
        include_context 'with a spec file with examples',
          "include_examples 'has immutable constant', :IMMUTABLE_CONSTANT_WITH_VALUE, 'The Answer'"

        include_examples 'should pass with 1 example and 0 failures'
      end # describe
    end # describe
  end # describe
end # describe
