# spec/rspec/sleeping_king_studios/support/method_signature_spec.rb

require 'spec_helper'
require 'rspec/sleeping_king_studios/examples/property_examples'

require 'rspec/sleeping_king_studios/support/method_signature'

RSpec.describe RSpec::SleepingKingStudios::Support::MethodSignature do
  include RSpec::SleepingKingStudios::Examples::PropertyExamples

  let(:method_name)  { :custom_method }
  let(:method_definition) do
    ->() {}
  end # let
  let(:actual_class) do
    name       = method_name
    definition = method_definition

    Class.new do
      define_method name, definition
    end # class
  end # let
  let(:actual)       { actual_class.new }
  let(:method)       { actual.method(method_name) }
  let(:instance)     { described_class.new method }

  include_examples 'should have reader', :any_keywords?

  include_examples 'should have reader', :block_argument?

  include_examples 'should have reader', :keywords

  include_examples 'should have reader', :max_arguments

  include_examples 'should have reader', :min_arguments

  include_examples 'should have reader', :optional_keywords

  include_examples 'should have reader', :required_keywords

  include_examples 'should have reader', :unlimited_arguments?

  describe 'with a method with no parameters' do
    let(:method_definition) { ->() {} }

    it { expect(instance.min_arguments).to be 0 }

    it { expect(instance.max_arguments).to be 0 }

    it { expect(instance.unlimited_arguments?).to be false }

    it { expect(instance.optional_keywords).to be == [] }

    it { expect(instance.required_keywords).to be == [] }

    it { expect(instance.keywords).to be == [] }

    it { expect(instance.any_keywords?).to be false }

    it { expect(instance.block_argument?).to be false }
  end # describe

  describe 'with a method with required parameters' do
    let(:method_definition) { ->(a, b) {} }

    it { expect(instance.min_arguments).to be 2 }

    it { expect(instance.max_arguments).to be 2 }

    it { expect(instance.unlimited_arguments?).to be false }

    it { expect(instance.optional_keywords).to be == [] }

    it { expect(instance.required_keywords).to be == [] }

    it { expect(instance.keywords).to be == [] }

    it { expect(instance.any_keywords?).to be false }

    it { expect(instance.block_argument?).to be false }
  end # describe

  describe 'with a method with optional and required parameters' do
    let(:method_definition) { ->(a, b, c = nil, d = nil) {} }

    it { expect(instance.min_arguments).to be 2 }

    it { expect(instance.max_arguments).to be 4 }

    it { expect(instance.unlimited_arguments?).to be false }

    it { expect(instance.optional_keywords).to be == [] }

    it { expect(instance.required_keywords).to be == [] }

    it { expect(instance.keywords).to be == [] }

    it { expect(instance.any_keywords?).to be false }

    it { expect(instance.block_argument?).to be false }
  end # describe

  describe 'with a method with optional, required, and variadic parameters' do
    let(:method_definition) { ->(a, b, c = nil, d = nil, *args) {} }

    it { expect(instance.min_arguments).to be 2 }

    it { expect(instance.max_arguments).to be 4 }

    it { expect(instance.unlimited_arguments?).to be true }

    it { expect(instance.optional_keywords).to be == [] }

    it { expect(instance.required_keywords).to be == [] }

    it { expect(instance.keywords).to be == [] }

    it { expect(instance.any_keywords?).to be false }

    it { expect(instance.block_argument?).to be false }
  end # describe

  describe 'with a method with optional keywords' do
    let(:method_definition) { ->(u: nil, v: nil) {} }

    it { expect(instance.min_arguments).to be 0 }

    it { expect(instance.max_arguments).to be 0 }

    it { expect(instance.unlimited_arguments?).to be false }

    it { expect(instance.optional_keywords).to contain_exactly :u, :v }

    it { expect(instance.required_keywords).to be == [] }

    it { expect(instance.keywords).to contain_exactly :u, :v }

    it { expect(instance.any_keywords?).to be false }

    it { expect(instance.block_argument?).to be false }
  end # describe

  describe 'with a method with optional and required keywords' do
    let(:method_definition) { ->(x:, y:, u: nil, v: nil) {} }

    it { expect(instance.min_arguments).to be 0 }

    it { expect(instance.max_arguments).to be 0 }

    it { expect(instance.unlimited_arguments?).to be false }

    it { expect(instance.optional_keywords).to contain_exactly :u, :v }

    it { expect(instance.required_keywords).to contain_exactly :x, :y }

    it { expect(instance.keywords).to contain_exactly :x, :y, :u, :v }

    it { expect(instance.any_keywords?).to be false }

    it { expect(instance.block_argument?).to be false }
  end # describe

  describe 'with a method with optional, required, and variadic keywords' do
    let(:method_definition) { ->(x:, y:, u: nil, v: nil, **kwargs) {} }

    it { expect(instance.min_arguments).to be 0 }

    it { expect(instance.max_arguments).to be 0 }

    it { expect(instance.unlimited_arguments?).to be false }

    it { expect(instance.optional_keywords).to contain_exactly :u, :v }

    it { expect(instance.required_keywords).to contain_exactly :x, :y }

    it { expect(instance.keywords).to contain_exactly :x, :y, :u, :v }

    it { expect(instance.any_keywords?).to be true }

    it { expect(instance.block_argument?).to be false }
  end # describe

  describe 'with a method with a block parameter' do
    let(:method_definition) { ->(&block) {} }

    it { expect(instance.min_arguments).to be 0 }

    it { expect(instance.max_arguments).to be 0 }

    it { expect(instance.unlimited_arguments?).to be false }

    it { expect(instance.optional_keywords).to be == [] }

    it { expect(instance.required_keywords).to be == [] }

    it { expect(instance.keywords).to be == [] }

    it { expect(instance.any_keywords?).to be false }

    it { expect(instance.block_argument?).to be true }
  end # describe

  describe 'with a method with complex parameters' do
    let(:method_definition) do
      ->(a, b, c = nil, d = nil, *args, x:, y:, u: nil, v: nil, **kwargs, &block) {}
    end # let

    it { expect(instance.min_arguments).to be 2 }

    it { expect(instance.max_arguments).to be 4 }

    it { expect(instance.unlimited_arguments?).to be true }

    it { expect(instance.optional_keywords).to contain_exactly :u, :v }

    it { expect(instance.required_keywords).to contain_exactly :x, :y }

    it { expect(instance.keywords).to contain_exactly :x, :y, :u, :v }

    it { expect(instance.any_keywords?).to be true }

    it { expect(instance.block_argument?).to be true }
  end # describe
end # describe
