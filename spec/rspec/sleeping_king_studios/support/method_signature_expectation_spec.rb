# spec/rspec/sleeping_king_studios/support/method_signature_expectation_spec.rb

require 'rspec/sleeping_king_studios/examples/property_examples'

require 'rspec/sleeping_king_studios/support/method_signature_expectation'

RSpec.describe RSpec::SleepingKingStudios::Support::MethodSignatureExpectation do
  include RSpec::SleepingKingStudios::Examples::PropertyExamples

  let(:actual)            { Object.new }
  let(:method_name)       { :custom_method }
  let(:method_definition) { ->() {} }
  let(:method) do
    actual.define_singleton_method method_name, method_definition

    actual.method(method_name)
  end # let
  let(:instance)          { described_class.new }

  include_examples 'should have property', :min_arguments, 0

  include_examples 'should have property', :max_arguments, 0

  include_examples 'should have property', :keywords, []

  describe '#any_keywords' do
    include_examples 'should have reader', :any_keywords?, false

    include_examples 'should have writer', :any_keywords=

    it 'should set the predicate' do
      expect { instance.any_keywords = true }.
        to change(instance, :any_keywords?).to be true
    end # it
  end # describe

  describe '#block_argument' do
    include_examples 'should have reader', :block_argument?, false

    include_examples 'should have writer', :block_argument=

    it 'should set the predicate' do
      expect { instance.block_argument = true }.
        to change(instance, :block_argument?).to be true
    end # it
  end # describe

  describe '#unlimited_arguments' do
    include_examples 'should have reader', :unlimited_arguments?, false

    include_examples 'should have writer', :unlimited_arguments=

    it 'should set the predicate' do
      expect { instance.unlimited_arguments = true }.
        to change(instance, :unlimited_arguments?).to be true
    end # it
  end # describe

  include_examples 'should have reader', :errors, ->() { be == {} }

  describe '#description' do
    let(:expected) { 'with 0 arguments' }

    it { expect(instance).to have_reader(:description).with_value(expected) }

    describe 'with an arguments count' do
      let(:arity)    { 3 }
      let(:expected) { "with #{arity} arguments" }

      before(:example) do
        instance.min_arguments = arity
        instance.max_arguments = arity
      end # before example

      it { expect(instance.description).to be == expected }
    end # describe

    describe 'with an arguments range' do
      let(:arity)    { 2..4 }
      let(:expected) { "with #{arity.begin}..#{arity.end} arguments" }

      before(:example) do
        instance.min_arguments = arity.begin
        instance.max_arguments = arity.end
      end # before example

      it { expect(instance.description).to be == expected }
    end # describe

    describe 'with unlimited arguments' do
      let(:expected) { 'with 0 arguments and unlimited arguments' }

      before(:example) do
        instance.unlimited_arguments = true
      end # before example

      it { expect(instance.description).to be == expected }
    end # describe

    describe 'with an arguments count and unlimited arguments' do
      let(:arity)    { 3 }
      let(:expected) do
        "with #{arity} arguments and unlimited arguments"
      end # let

      before(:example) do
        instance.min_arguments       = arity
        instance.max_arguments       = arity
        instance.unlimited_arguments = true
      end # before example

      it { expect(instance.description).to be == expected }
    end # describe

    describe 'with one keyword' do
      let(:keyword)  { :foo }
      let(:expected) { "with 0 arguments and keyword #{keyword.inspect}" }

      before(:example) do
        instance.keywords = [keyword]
      end # before example

      it { expect(instance.description).to be == expected }
    end # describe

    describe 'with two keywords' do
      let(:keywords) { [:foo, :bar] }
      let(:expected) do
        'with 0 arguments and keywords '\
        "#{keywords.first.inspect} and #{keywords.last.inspect}"
      end # let

      before(:example) do
        instance.keywords = keywords
      end # before example

      it { expect(instance.description).to be == expected }
    end # describe

    describe 'with many keywords' do
      let(:keywords) { [:foo, :bar, :baz] }
      let(:expected) do
        'with 0 arguments and keywords '\
        "#{keywords[0...-1].map(&:inspect).join(', ')}, and "\
        "#{keywords.last.inspect}"
      end # let

      before(:example) do
        instance.keywords = keywords
      end # before example

      it { expect(instance.description).to be == expected }
    end # describe

    describe 'with arbitrary keywords' do
      let(:expected) { 'with 0 arguments and arbitrary keywords' }

      before(:example) do
        instance.any_keywords = true
      end # before example

      it { expect(instance.description).to be == expected }
    end # describe

    describe 'with many keywords and arbitrary keywords' do
      let(:keywords) { [:foo, :bar, :baz] }
      let(:expected) do
        'with 0 arguments, keywords '\
        "#{keywords[0...-1].map(&:inspect).join(', ')}, and "\
        "#{keywords.last.inspect}, and arbitrary keywords"
      end # let

      before(:example) do
        instance.keywords     = keywords
        instance.any_keywords = true
      end # before example

      it { expect(instance.description).to be == expected }
    end # describe

    describe 'with a block' do
      let(:expected) { 'with 0 arguments and a block' }

      before(:example) do
        instance.block_argument = true
      end # before example

      it { expect(instance.description).to be == expected }
    end # describe

    describe 'with complex parameters' do
      let(:arity)     { 3 }
      let(:keywords)  { [:foo, :bar, :baz] }
      let(:expected) do
        "with #{arity} arguments" <<
        ', unlimited arguments' <<
        ", keywords #{keywords[0...-1].map(&:inspect).join(', ')}" <<
        ", and #{keywords.last.inspect}" <<
        ', arbitrary keywords' <<
        ', and a block'
      end # let

      before(:example) do
        instance.min_arguments       = 3
        instance.max_arguments       = 3
        instance.unlimited_arguments = true
        instance.keywords            = keywords
        instance.any_keywords        = true
        instance.block_argument      = true
      end # before example

      it { expect(instance.description).to be == expected }
    end # describe
  end # describe

  describe '#matches?' do
    shared_examples 'should match and clear the errors hash' do
      it 'should match and clear the errors hash' do
        instance.errors.update :does_not_match_signature => true

        expect(instance.matches? method).to be true

        expect(instance.errors).to be == {}
      end # it
    end # shared_examples

    shared_examples 'should not match and should set errors' do |expected = {}|
      it 'should not match and should set errors' do
        expect(instance.matches? method).to be false

        expect(instance.errors).to be == expected
      end # it
    end # shared_examples

    it { expect(instance).to respond_to(:matches?).with(1).argument }

    context 'with a method with no arguments' do
      let(:method_definition) { ->() {} }

      describe 'with no argument expectations' do
        include_examples 'should match and clear the errors hash'
      end # describe

      describe 'with too many arguments expected' do
        before(:example) { instance.max_arguments = 2 }

        include_examples 'should not match and should set errors',
          :too_many_args => {
            :expected => 0,
            :received => 2
          } # end hash
      end # describe

      describe 'with unlimited arguments expected' do
        before(:example) { instance.unlimited_arguments = true }

        include_examples 'should not match and should set errors',
          :no_variadic_args => {
            :expected => 0
          } # end hash
      end # describe

      describe 'with invalid keywords expected' do
        before(:example) { instance.keywords = [:r, :s] }

        include_examples 'should not match and should set errors',
          :unexpected_keywords => [:r, :s]
      end # describe

      describe 'with arbitrary keywords expected' do
        before(:example) { instance.any_keywords = true }

        include_examples 'should not match and should set errors',
          :no_variadic_keywords => true
      end # describe

      describe 'with a block argument expected' do
        before(:example) { instance.block_argument = true }

        include_examples 'should not match and should set errors',
          :no_block_argument => true
      end # describe

      describe 'with complex arguments expected' do
        before(:example) do
          instance.max_arguments       = 2
          instance.unlimited_arguments = true
          instance.keywords            = [:r, :s]
          instance.any_keywords        = true
          instance.block_argument      = true
        end # before example

        include_examples 'should not match and should set errors',
          :too_many_args        => {
            :expected => 0,
            :received => 2
          }, # end hash
          :no_variadic_args     => {
            :expected => 0
          }, # end hash
          :unexpected_keywords  => [:r, :s],
          :no_variadic_keywords => true,
          :no_block_argument    => true
      end # describe
    end # context

    context 'with a method with required and optional arguments' do
      let(:method_definition) { ->(a, b, c = nil, d = nil) {} }

      describe 'with no argument expectations' do
        include_examples 'should not match and should set errors',
          :not_enough_args => {
            :expected => 2,
            :received => 0
          } # end hash
      end # describe

      describe 'with not enough arguments expected' do
        before(:example) { instance.min_arguments = 1 }

        include_examples 'should not match and should set errors',
          :not_enough_args => {
            :expected => 2,
            :received => 1
          } # end hash
      end # describe

      describe 'with valid arguments and keywords' do
        before(:example) do
          instance.min_arguments = 2
          instance.max_arguments = 4
        end # before example

        include_examples 'should match and clear the errors hash'
      end # describe

      describe 'with too many arguments expected' do
        before(:example) do
          instance.min_arguments = 2
          instance.max_arguments = 6
        end # before example

        include_examples 'should not match and should set errors',
          :too_many_args => {
            :expected => 4,
            :received => 6
          } # end hash
      end # describe

      describe 'with too few and too many arguments expected' do
        before(:example) do
          instance.min_arguments = 1
          instance.max_arguments = 6
        end # before example

        include_examples 'should not match and should set errors',
          :not_enough_args => {
            :expected => 2,
            :received => 1
          }, # end hash
          :too_many_args => {
            :expected => 4,
            :received => 6
          } # end hash
      end # describe

      describe 'with unlimited arguments expected' do
        before(:example) do
          instance.min_arguments       = 2
          instance.max_arguments       = 4
          instance.unlimited_arguments = true
        end # before example

        include_examples 'should not match and should set errors',
          :no_variadic_args => {
            :expected => 4
          } # end hash
      end # describe

      describe 'with invalid keywords expected' do
        before(:example) do
          instance.min_arguments = 2
          instance.max_arguments = 4
          instance.keywords      = [:r, :s]
        end # before example

        include_examples 'should not match and should set errors',
          :unexpected_keywords => [:r, :s]
      end # describe

      describe 'with arbitrary keywords expected' do
        before(:example) do
          instance.min_arguments = 2
          instance.max_arguments = 4
          instance.any_keywords  = true
        end # before example

        include_examples 'should not match and should set errors',
          :no_variadic_keywords => true
      end # describe

      describe 'with a block argument expected' do
        before(:example) do
          instance.min_arguments  = 2
          instance.max_arguments  = 4
          instance.block_argument = true
        end # before example

        include_examples 'should not match and should set errors',
          :no_block_argument => true
      end # describe

      describe 'with complex arguments expected' do
        before(:example) do
          instance.min_arguments       = 1
          instance.max_arguments       = 6
          instance.unlimited_arguments = true
          instance.keywords            = [:r, :s]
          instance.any_keywords        = true
          instance.block_argument      = true
        end # before example

        include_examples 'should not match and should set errors',
          :not_enough_args      => {
            :expected => 2,
            :received => 1
          }, # end hash
          :too_many_args        => {
            :expected => 4,
            :received => 6
          }, # end hash
          :no_variadic_args     => {
            :expected => 4
          }, # end hash
          :unexpected_keywords  => [:r, :s],
          :no_variadic_keywords => true,
          :no_block_argument    => true
      end # describe
    end # context

    context 'with a method with variadic arguments' do
      let(:method_definition) { ->(*args) {} }

      describe 'with no argument expectations' do
        include_examples 'should match and clear the errors hash'
      end # describe

      describe 'with valid arguments and keywords' do
        before(:example) do
          instance.min_arguments = 0
          instance.max_arguments = 9_001
        end # before example

        include_examples 'should match and clear the errors hash'
      end # describe

      describe 'with unlimited arguments expected' do
        before(:example) { instance.unlimited_arguments = true }

        include_examples 'should match and clear the errors hash'
      end # describe

      describe 'with invalid keywords expected' do
        before(:example) { instance.keywords = [:r, :s] }

        include_examples 'should not match and should set errors',
          :unexpected_keywords => [:r, :s]
      end # describe

      describe 'with arbitrary keywords expected' do
        before(:example) { instance.any_keywords = true }

        include_examples 'should not match and should set errors',
          :no_variadic_keywords => true
      end # describe

      describe 'with a block argument expected' do
        before(:example) { instance.block_argument = true }

        include_examples 'should not match and should set errors',
          :no_block_argument => true
      end # describe

      describe 'with complex arguments expected' do
        before(:example) do
          instance.min_arguments       = 0
          instance.max_arguments       = 9_001
          instance.unlimited_arguments = true
          instance.keywords            = [:r, :s]
          instance.any_keywords        = true
          instance.block_argument      = true
        end # before example

        include_examples 'should not match and should set errors',
          :unexpected_keywords => [:r, :s],
          :no_variadic_keywords => true,
          :no_block_argument => true
      end # describe
    end # context

    context 'with a method with required and optional keywords' do
      let(:method_definition) { ->(x:, y:, u: nil, v: nil) {} }

      describe 'with no argument expectations' do
        include_examples 'should not match and should set errors',
          :missing_keywords => [:x, :y]
      end # describe

      describe 'with valid arguments and keywords' do
        before(:example) do
          instance.keywords = [:u, :v, :x, :y]
        end # before example

        include_examples 'should match and clear the errors hash'
      end # describe

      describe 'with too many arguments expected' do
        before(:example) do
          instance.keywords      = [:u, :v, :x, :y]
          instance.max_arguments = 2
        end # before example

        include_examples 'should not match and should set errors',
          :too_many_args => {
            :expected => 0,
            :received => 2
          } # end hash
      end # describe

      describe 'with unlimited arguments expected' do
        before(:example) do
          instance.keywords            = [:u, :v, :x, :y]
          instance.unlimited_arguments = true
        end # before example

        include_examples 'should not match and should set errors',
          :no_variadic_args => {
            :expected => 0
          } # end hash
      end # describe

      describe 'with expected keywords missing' do
        before(:example) do
          instance.keywords = [:u, :v]
        end # before example

        include_examples 'should not match and should set errors',
          :missing_keywords => [:x, :y]
      end # describe

      describe 'with invalid keywords expected' do
        before(:example) do
          instance.keywords = [:r, :s, :u, :v, :x, :y]
        end # before example

        include_examples 'should not match and should set errors',
          :unexpected_keywords => [:r, :s]
      end # describe

      describe 'with unexpected and missing keywords' do
        before(:example) do
          instance.keywords = [:r, :s, :u, :v]
        end # before example

        include_examples 'should not match and should set errors',
          :missing_keywords    => [:x, :y],
          :unexpected_keywords => [:r, :s]
      end # describe

      describe 'with arbitrary keywords expected' do
        before(:example) do
          instance.keywords     = [:u, :v, :x, :y]
          instance.any_keywords = true
        end # before example

        include_examples 'should not match and should set errors',
          :no_variadic_keywords => true
      end # describe

      describe 'with a block argument expected' do
        before(:example) do
          instance.keywords       = [:u, :v, :x, :y]
          instance.block_argument = true
        end # before example

        include_examples 'should not match and should set errors',
          :no_block_argument => true
      end # describe

      describe 'with complex arguments expected' do
        before(:example) do
          instance.max_arguments       = 2
          instance.unlimited_arguments = true
          instance.keywords            = [:r, :s, :u, :v]
          instance.any_keywords        = true
          instance.block_argument      = true
        end # before example

        include_examples 'should not match and should set errors',
          :too_many_args        => {
            :expected => 0,
            :received => 2
          }, # end hash
          :no_variadic_args     => {
            :expected => 0
          }, # end hash
          :missing_keywords     => [:x, :y],
          :unexpected_keywords  => [:r, :s],
          :no_variadic_keywords => true,
          :no_block_argument    => true
      end # describe
    end # context

    context 'with a method with variadic keywords' do
      let(:method_definition) { ->(**kwargs) {} }

      describe 'with no argument expectations' do
        include_examples 'should match and clear the errors hash'
      end # describe

      describe 'with valid arguments and keywords' do
        before(:example) do
          instance.keywords = [:q, :r, :s, :t]
        end # before example

        include_examples 'should match and clear the errors hash'
      end # describe

      describe 'with too many arguments expected' do
        before(:example) { instance.max_arguments = 2 }

        include_examples 'should not match and should set errors',
          :too_many_args => {
            :expected => 0,
            :received => 2
          } # end hash
      end # describe

      describe 'with unlimited arguments expected' do
        before(:example) { instance.unlimited_arguments = true }

        include_examples 'should not match and should set errors',
          :no_variadic_args => {
            :expected => 0
          } # end hash
      end # describe

      describe 'with arbitrary keywords expected' do
        before(:example) { instance.any_keywords = true }

        include_examples 'should match and clear the errors hash'
      end # describe

      describe 'with a block argument expected' do
        before(:example) { instance.block_argument = true }

        include_examples 'should not match and should set errors',
          :no_block_argument => true
      end # describe

      describe 'with complex arguments expected' do
        before(:example) do
          instance.max_arguments       = 2
          instance.unlimited_arguments = true
          instance.keywords            = [:q, :r, :s, :t]
          instance.any_keywords        = true
          instance.block_argument      = true
        end # before example

        include_examples 'should not match and should set errors',
          :too_many_args     => {
            :expected => 0,
            :received => 2
          }, # end hash
          :no_variadic_args  => {
            :expected => 0
          }, # end hash
          :no_block_argument => true
      end # describe
    end # context

    context 'with a method with a block argument' do
      let(:method_definition) { ->(&block) {} }

      describe 'with no argument expectations' do
        include_examples 'should match and clear the errors hash'
      end # describe

      describe 'with too many arguments expected' do
        before(:example) { instance.max_arguments = 2 }

        include_examples 'should not match and should set errors',
          :too_many_args => {
            :expected => 0,
            :received => 2
          } # end hash
      end # describe

      describe 'with invalid keywords expected' do
        before(:example){ instance.keywords = [:r, :s] }

        include_examples 'should not match and should set errors',
          :unexpected_keywords => [:r, :s]
      end # describe

      describe 'with arbitrary keywords expected' do
        before(:example) { instance.any_keywords = true }

        include_examples 'should not match and should set errors',
          :no_variadic_keywords => true
      end # describe

      describe 'with a block argument expected' do
        before(:example) { instance.block_argument = true }

        include_examples 'should match and clear the errors hash'
      end # describe

      describe 'with complex arguments expected' do
        before(:example) do
          instance.max_arguments       = 2
          instance.unlimited_arguments = true
          instance.keywords            = [:q, :r, :s, :t]
          instance.any_keywords        = true
          instance.block_argument      = true
        end # before example

        include_examples 'should not match and should set errors',
          :too_many_args        => {
            :expected => 0,
            :received => 2
          }, # end hash
          :no_variadic_args     => {
            :expected => 0
          }, # end hash
          :unexpected_keywords  => [:q, :r, :s, :t],
          :no_variadic_keywords => true
      end # describe
    end # context

    context 'with a method with complex arguments' do
      let(:method_definition) do
        ->(a, b, c = nil, d = nil, *args, x:, y:, u: nil, v: nil, **kwargs, &block) {}
      end # let

      describe 'with no argument expectations' do
        include_examples 'should not match and should set errors',
          :not_enough_args  => {
            :expected => 2,
            :received => 0
          }, # end hash
          :missing_keywords => [:x, :y]
      end # describe

      describe 'with not enough arguments expected' do
        before(:example) do
          instance.min_arguments = 1
          instance.keywords      = [:x, :y]
        end # before example

        include_examples 'should not match and should set errors',
          :not_enough_args => {
            :expected => 2,
            :received => 1
          } # end hash
      end # describe

      describe 'with valid arguments and keywords' do
        before(:example) do
          instance.min_arguments = 2
          instance.keywords      = [:x, :y]
        end # before example

        include_examples 'should match and clear the errors hash'
      end # describe

      describe 'with unlimited arguments expected' do
        before(:example) do
          instance.min_arguments       = 2
          instance.unlimited_arguments = true
          instance.keywords            = [:x, :y]
        end # before example

        include_examples 'should match and clear the errors hash'
      end # describe

      describe 'with expected keywords missing' do
        before(:example) do
          instance.min_arguments = 2
          instance.keywords      = [:u, :v]
        end # before example

        include_examples 'should not match and should set errors',
          :missing_keywords => [:x, :y]
      end # describe

      describe 'with arbitrary keywords expected' do
        before(:example) do
          instance.min_arguments = 2
          instance.keywords      = [:x, :y]
          instance.any_keywords  = true
        end # before example

        include_examples 'should match and clear the errors hash'
      end # describe

      describe 'with a block argument expected' do
        before(:example) do
          instance.min_arguments  = 2
          instance.keywords       = [:x, :y]
          instance.block_argument = true
        end # before example

        include_examples 'should match and clear the errors hash'
      end # describe

      describe 'with invalid complex arguments expected' do
        before(:example) do
          instance.min_arguments       = 1
          instance.unlimited_arguments = true
          instance.keywords            = [:r, :s, :u, :v]
          instance.any_keywords        = true
          instance.block_argument      = true
        end # before example

        include_examples 'should not match and should set errors',
          :not_enough_args        => {
            :expected => 2,
            :received => 1
          }, # end hash
          :missing_keywords     => [:x, :y]
      end # describe

      describe 'with valid complex arguments expected' do
        before(:example) do
          instance.min_arguments       = 2
          instance.unlimited_arguments = true
          instance.keywords            = [:r, :s, :u, :v, :x, :y]
          instance.any_keywords        = true
          instance.block_argument      = true
        end # before example

        include_examples 'should match and clear the errors hash'
      end # describe
    end # describe
  end # describe
end # describe
