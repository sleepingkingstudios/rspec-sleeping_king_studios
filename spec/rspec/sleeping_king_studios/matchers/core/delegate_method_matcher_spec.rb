# spec/rspec/sleeping_king_studios/matchers/core/delegate_method_matcher_spec.rb

require 'spec_helper'
require 'rspec/sleeping_king_studios/concerns/focus_examples'
require 'rspec/sleeping_king_studios/concerns/wrap_examples'
require 'rspec/sleeping_king_studios/examples/rspec_matcher_examples'
require 'rspec/sleeping_king_studios/matchers/built_in/respond_to'
require 'rspec/sleeping_king_studios/matchers/core/alias_method'
require 'rspec/sleeping_king_studios/matchers/core/have_reader'

require 'rspec/sleeping_king_studios/matchers/core/delegate_method_matcher'

RSpec.describe RSpec::SleepingKingStudios::Matchers::Core::DelegateMethodMatcher do
  extend  RSpec::SleepingKingStudios::Concerns::WrapExamples
  extend  RSpec::SleepingKingStudios::Concerns::FocusExamples
  include RSpec::SleepingKingStudios::Examples::RSpecMatcherExamples

  let(:method_name) { :delegated_method }
  let(:instance)    { described_class.new method_name }

  def build_method_definition parameter_names:, keywords_names:, method_body:, block_given: false
    str = '->('

    str << build_method_parameters(
      :parameter_names => parameter_names,
      :keywords_names  => keywords_names,
      :block_given     => block_given
    ) # end build_method_parameters

    str << ') {'

    unless method_body.empty?
      str << "\n"

      method_body.each_line { |line| str << '  ' << line }

      str << "\n"
    end # unless

    str << '}'
  end # method build_method_definition

  def build_method_parameters parameter_names:, keywords_names:, block_given:
    normalized = []

    parameter_names.each { |name| normalized << name.to_s }
    keywords_names.each  { |name| normalized << "#{name}:" }

    normalized << "&block" if block_given

    normalized.join ', '
  end # method build_method_parameters

  describe '#and_return' do
    it { expect(instance).to respond_to(:and_return).with_unlimited_arguments }

    it { expect(instance.and_return(:uno, :dos, :tres)).to be instance }
  end # describe

  describe '#description' do
    it { expect(instance).to respond_to(:description).with(0).arguments }

    it { expect(instance.description).to be == "delegate method #{method_name.inspect}" }

    describe 'with a delegate' do
      let(:delegate) { double('delegate') }
      let(:instance) { super().to delegate }

      it { expect(instance.description).to be == "delegate method #{method_name.inspect} to #{delegate.inspect}" }
    end # describe
  end # describe

  describe '#expected' do
    it { expect(instance).to have_reader(:expected).with_value(method_name) }

    it { expect(instance).to alias_method(:expected).as(:method_name) }
  end # describe

  describe '#matches?' do
    shared_context 'with an actual that responds to the method' do
      let(:method_body)            { defined?(super()) ? super() : '' }
      let(:method_parameter_names) { defined?(super()) ? super() : [] }
      let(:method_keyword_names)   { defined?(super()) ? super() : [] }
      let(:method_block_given)     { defined?(super()) ? super() : false }
      let(:method_definition) do
        build_method_definition(
          :parameter_names => method_parameter_names,
          :keywords_names  => method_keyword_names,
          :block_given     => method_block_given,
          :method_body     => method_body,
        ) # end build_method_definition
      end # let
      let(:method_implementation) do
        method = method_name
        target = delegate

        eval method_definition
      end # let

      before(:example) do
        actual_class.send :define_method, method_name, method_implementation
      end # before example
    end # shared_context

    shared_context 'with a delegate that responds to the method' do
      let(:delegate_body)            { defined?(super()) ? super() : '' }
      let(:delegate_parameter_names) { defined?(super()) ? super() : [] }
      let(:delegate_keyword_names)   { defined?(super()) ? super() : [] }
      let(:delegate_block_given)     { defined?(super()) ? super() : false }
      let(:delegate_return_cursor)   { double('cursor', :next => nil) }
      let(:delegate_definition) do
        build_method_definition(
          :parameter_names => delegate_parameter_names,
          :keywords_names  => delegate_keyword_names,
          :block_given     => delegate_block_given,
          :method_body     => delegate_body,
        ) # end build_method_definition
      end # let
      let(:delegate_implementation) do
        cursor = delegate_return_cursor

        eval delegate_definition
      end # let
      let(:instance) { super().to(delegate) }

      before(:example) do
        delegate_class.send :define_method, method_name, delegate_implementation
      end # before example
    end # shared_context

    shared_context 'with a delegate that returns a value' do
      let(:delegate_return_values) { defined?(super()) ? super() : [] }
      let(:delegate_return_cursor) { delegate_return_values.each }
      let(:delegate_body)          { 'cursor.next' }
    end # shared_context

    shared_examples 'should require a target' do
      it 'should raise an error' do
        expect {
          instance.matches? double('actual')
        }.to raise_error ArgumentError, 'must specify a target'
      end # it
    end # shared_examples

    shared_examples 'should require a target that responds to the method' do
      include_examples 'should require a target'

      context 'with a delegate that does not respond to the method' do
        let(:failure_message) do
          super() <<
            ", but #{delegate.inspect} does not respond to "\
            "#{method_name.inspect}"
        end # let
        let(:delegate) do
          Class.new do
            def to_s
              '#<Target>'
            end # method to_s
            alias_method :inspect, :to_s
          end.new # class
        end # let
        let(:instance) { super().to(delegate) }

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end # context
    end # shared_examples

    shared_examples 'should require an actual that delegates to the target' do
      wrap_context 'with a delegate that responds to the method' do
        describe 'should require an actual that delegates to the target' do
          let(:failure_message) do
            super() <<
              ", but calling ##{method_name} on the object does not call "\
              "##{method_name} on the delegate"
          end # let

          include_examples 'should fail with a positive expectation'

          include_examples 'should pass with a negative expectation'
        end # describe
      end # wrap_context
    end # shared_examples

    shared_examples 'should handle raised errors' do
      describe 'should handle raised errors' do
        include_context 'with a delegate that responds to the method'

        let(:arguments) { defined?(super()) ? super() : [] }
        let(:keywords)  { defined?(super()) ? super() : {} }
        let(:failure_message) do
          super() << format_arguments <<
            ", but ##{method_name} raised #{exception_class.name}: "\
            "#{exception_message}"
        end # let

        describe 'with an actual that raises an ArgumentError' do
          let(:arguments)       { super() << :too << :many << :arguments }
          let(:exception_class) { ArgumentError }
          let(:exception_message) do
            begin
              args = arguments.dup
              args << keywords unless keywords.empty?

              actual.send(method_name, *args)
            rescue ArgumentError => exception
              exception.message
            end # begin-rescue
          end # let

          let(:instance) { super().with_arguments(*arguments) }

          include_examples 'should fail with a positive expectation'

          include_examples 'should pass with a negative expectation'
        end # describe

        describe 'with an actual that raises a custom error' do
          let(:exception_class) do
            Class.new(StandardError) do
              def self.name
                'CustomError'
              end # class method name
            end # let
          end # let
          let(:exception_message) do
            'Unable to log out because you are not logged in. Please log in so '\
            'you can log out.'
          end # let
          let(:method_body) { "raise #{exception_class.name}, #{exception_message.inspect}" }

          around(:each) do |example|
            begin
              Object.const_set :CustomError, exception_class

              example.call
            ensure
              Object.send :remove_const, :CustomError if Object.const_defined?(:CustomError)
            end # begin-ensure
          end # around each

          include_examples 'should fail with a positive expectation'

          include_examples 'should pass with a negative expectation'
        end # describe
      end # describe
    end # shared_examples

    shared_examples 'should require the actual to return the delegate value' do
      wrap_context 'with a delegate that returns a value' do
        let(:delegate_return_values) { %w(hana duul set) }
        let(:return_values)          { delegate_return_values }
        let(:instance)               { super().and_return(*return_values) }

        describe 'with an actual that does not return the delegate value' do
          let(:failure_message) do
            super() << format_return_values <<
              ', but returned nil, nil, and nil'
          end # let
          let(:method_body) { super() << "\nreturn nil" }

          include_examples 'should fail with a positive expectation'

          include_examples 'should pass with a negative expectation'
        end # describe

        describe 'with an actual that returns the delegate value one time' do
          let(:failure_message) do
            value = return_values.first.inspect

            super() << format_return_values <<
              ", but returned #{value}, #{value}, and #{value}"
          end # let

          let(:method_body) do
            "if @first_return\n"\
            "  #{super()}\n"\
            "  @first_return\n"\
            "else\n"\
            "  @first_return = #{super()}\n"\
            "end"
          end # let

          include_examples 'should fail with a positive expectation'

          include_examples 'should pass with a negative expectation'
        end # describe

        describe 'with an actual that returns the delegate value many times' do
          let(:failure_message_when_negated) do
            super() << format_return_values
          end # let

          include_examples 'should pass with a positive expectation'

          include_examples 'should fail with a negative expectation'
        end # describe
      end # wrap_context
    end # shared_examples

    let(:delegate_class) do
      klass = Class.new do
        def to_s
          '#<Target>'
        end # method to_s
        alias_method :inspect, :to_s
      end # class
    end # let
    let(:delegate) { delegate_class.new }
    let(:actual_class) do
      Class.new do
        def to_s
          '#<Actual>'
        end # method to_s
        alias_method :inspect, :to_s
      end # class
    end # let
    let(:actual)        { actual_class.new }
    let(:arguments)     { [] }
    let(:keywords)      { {} }
    let(:block_given)   { false }
    let(:return_values) { [] }
    let(:failure_message) do
      build_failure_message negated: false
    end # let
    let(:failure_message_when_negated) do
      build_failure_message negated: true
    end # let

    def build_failure_message negated: false
      message = "expected #{actual.inspect} "
      message << 'not ' if negated
      message << "to delegate #{method_name.inspect} to #{delegate.inspect}"
    end # method build_failure_message

    def format_arguments
      fragments = []

      unless arguments.empty?
        args = SleepingKingStudios::Tools::ArrayTools.humanize_list(arguments.map &:inspect)

        fragments << ('arguments ' << args)
      end # unless

      unless keywords.empty?
        kwargs = keywords.map { |key, value| "#{key.inspect}=>#{value.inspect}" }
        kwargs = SleepingKingStudios::Tools::ArrayTools.humanize_list(kwargs)

        fragments << ('keywords ' << kwargs)
      end # unless

      if fragments.empty?
        arguments = ' with no arguments'
      else
        arguments = ' with ' << fragments.join(' and ')
      end # if-else

      arguments << ' and yield a block' if block_given

      arguments
    end # method format_arguments

    def format_return_values
      return '' if return_values.empty?

      tools  = SleepingKingStudios::Tools::ArrayTools
      values = return_values.map(&:inspect)

      " and return #{tools.humanize_list values}"
    end # method format_return_values

    it { expect(instance).to respond_to(:matches?).with(1).arguments }

    describe 'with an actual that does not respond to the method' do
      include_examples 'should require a target'

      wrap_context 'with a delegate that responds to the method' do
        let(:failure_message) do
          super() <<
            ", but #{actual.inspect} does not respond to #{method_name.inspect}"
        end # let

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end # context
    end # describe

    describe 'with an actual that responds to the method with no arguments' do
      include_context 'with an actual that responds to the method'

      include_examples 'should require a target that responds to the method'

      include_examples 'should require an actual that delegates to the target'

      include_examples 'should handle raised errors'

      describe 'with an actual that delegates the method to the target' do
        include_context 'with a delegate that responds to the method'

        let(:method_body) { 'target.send(method)' }
        let(:failure_message) do
          super() << format_arguments
        end # let
        let(:failure_message_when_negated) do
          super() << format_arguments
        end # let

        include_examples 'should pass with a positive expectation'

        include_examples 'should fail with a negative expectation'

        include_examples 'should require the actual to return the delegate value'
      end # describe
    end # describe

    describe 'with an actual that responds to the method with required arguments' do
      include_context 'with an actual that responds to the method'

      let(:method_parameter_names) { %i(foo bar baz) }
      let(:arguments)              { %i(ichi ni san) }
      let(:instance)               { super().with_arguments(*arguments) }

      include_examples 'should require a target that responds to the method'

      include_examples 'should require an actual that delegates to the target'

      include_examples 'should handle raised errors'

      describe 'with an actual that delegates the method to the target with no arguments' do
        include_context 'with a delegate that responds to the method'

        let(:method_body) { 'target.send(method)' }
        let(:failure_message) do
          include(
            super() << format_arguments <<
              ", but #{delegate.inspect} received :#{method_name} with "\
              "unexpected arguments"
          ).and include(
            "expected: (:ichi, :ni, :san)"
          ).and include(
            "got: (no args)"
          ) # end match
        end # let

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end # describe

      describe 'with an actual that delegates the method to the target with the required arguments' do
        include_context 'with a delegate that responds to the method'

        let(:method_body) do
          "target.send(method, #{method_parameter_names.join (', ')})"
        end # let
        let(:delegate_parameter_names) { method_parameter_names }
        let(:failure_message) do
          super() << format_arguments
        end # let
        let(:failure_message_when_negated) do
          super() << format_arguments
        end # let

        include_examples 'should pass with a positive expectation'

        include_examples 'should fail with a negative expectation'

        include_examples 'should require the actual to return the delegate value'
      end # describe
    end # describe

    describe 'with an actual that responds to the method with required keywords' do
      include_context 'with an actual that responds to the method'

      let(:method_keyword_names) { keywords.keys }
      let(:keywords) do
        { :foo => 'foo', :bar => 'bar', :baz => 'baz' }
      end # let
      let(:instance) { super().with_keywords(keywords) }

      include_examples 'should require a target that responds to the method'

      include_examples 'should require an actual that delegates to the target'

      include_examples 'should handle raised errors'

      describe 'with an actual that delegates the method to the target with no arguments' do
        include_context 'with a delegate that responds to the method'

        let(:method_body) { 'target.send(method)' }
        let(:expected_keywords) do
          ':bar=>"bar", :baz=>"baz", :foo=>"foo"'
        end # let
        let(:failure_message) do
          include(
            super() << format_arguments <<
              ", but #{delegate.inspect} received :#{method_name} with "\
              "unexpected arguments"
          ).and include(
            "expected: ({#{expected_keywords}})"
          ).and include(
            "got: (no args)"
          ) # end match
        end # let

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end # describe

      describe 'with an actual that delegates the method to the target with the required keywords' do
        include_context 'with a delegate that responds to the method'

        let(:method_body) do
          keyword_names = method_keyword_names.map do |keyword_name|
            "#{keyword_name}: #{keyword_name}"
          end.join(', ')

          "target.send(method, #{keyword_names})"
        end # let
        let(:delegate_keyword_names) { method_keyword_names }
        let(:failure_message) do
          super() << format_arguments
        end # let
        let(:failure_message_when_negated) do
          super() << format_arguments
        end # let

        include_examples 'should pass with a positive expectation'

        include_examples 'should fail with a negative expectation'

        include_examples 'should require the actual to return the delegate value'
      end # describe
    end # describe

    describe 'with an actual that responds to the method with a block' do
      include_context 'with an actual that responds to the method'

      let(:method_block_name)  { 'block' }
      let(:method_block_given) { true }
      let(:block_given)        { method_block_given }
      let(:instance)           { super().with_a_block }

      include_examples 'should require a target that responds to the method'

      include_examples 'should require an actual that delegates to the target'

      include_examples 'should handle raised errors'

      describe 'with an actual that delegates the method to the target without the block' do
        include_context 'with a delegate that responds to the method'

        let(:method_body) { 'target.send(method)' }
        let(:failure_message) do
          super() << format_arguments <<
            ', but the block was not passed to the delegate'
        end # let

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end # describe

      describe 'with an actual that delegates the method to the target with the block' do
        include_context 'with a delegate that responds to the method'

        let(:method_body) { "target.send(method, &#{method_block_name})" }
        let(:failure_message_when_negated) do
          super() << format_arguments
        end # let

        include_examples 'should fail with a negative expectation'

        include_examples 'should pass with a positive expectation'
      end # describe
    end # describe

    describe 'with an actual that responds to the method with required arguments, keywords, and a block' do
      include_context 'with an actual that responds to the method'

      let(:method_parameter_names) { %i(foo bar baz) }
      let(:method_keyword_names)   { keywords.keys }
      let(:arguments)              { %i(ichi ni san) }
      let(:keywords) do
        { :uno => 'uno', :dos => 'dos', :tres => 'tres' }
      end # let
      let(:expected_keywords) do
        ':dos=>"dos", :tres=>"tres", :uno=>"uno"'
      end # let
      let(:method_block_name)      { 'block' }
      let(:method_block_given)     { true }
      let(:block_given)            { method_block_given }
      let(:instance) do
        super().with_arguments(*arguments).with_keywords(keywords).with_a_block
      end # let

      include_examples 'should require a target that responds to the method'

      include_examples 'should require an actual that delegates to the target'

      include_examples 'should handle raised errors'

      describe 'with an actual that delegates the method to the target with no arguments' do
        include_context 'with a delegate that responds to the method'

        let(:method_body) { 'target.send(method)' }
        let(:failure_message) do
          include(
            super() << format_arguments <<
              ", but #{delegate.inspect} received :#{method_name} with "\
              "unexpected arguments"
          ).and include(
            "expected: (:ichi, :ni, :san, {#{expected_keywords}})"
          ).and include(
            "got: (no args)"
          ) # end match
        end # let

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end # describe

      describe 'with an actual that delegates the method to the target with the required arguments' do
        include_context 'with a delegate that responds to the method'

        let(:method_body) do
          "target.send(method, #{method_parameter_names.join (', ')})"
        end # let
        let(:delegate_parameter_names) { method_parameter_names }
        let(:failure_message) do
          include(
            super() << format_arguments <<
              ", but #{delegate.inspect} received :#{method_name} with "\
              "unexpected arguments"
          ).and include(
            "expected: (:ichi, :ni, :san, {#{expected_keywords}})"
          ).and include(
            "got: (:ichi, :ni, :san)"
          ) # end match
        end # let

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end # describe

      describe 'with an actual that delegates the method to the target with the required keywords' do
        include_context 'with a delegate that responds to the method'

        let(:method_body) do
          keyword_names = method_keyword_names.map do |keyword_name|
            "#{keyword_name}: #{keyword_name}"
          end.join(', ')

          "target.send(method, #{keyword_names})"
        end # let
        let(:delegate_keyword_names) { method_keyword_names }
        let(:failure_message) do
          include(
            super() << format_arguments <<
              ", but #{delegate.inspect} received :#{method_name} with "\
              "unexpected arguments"
          ).and include(
            "expected: (:ichi, :ni, :san, {#{expected_keywords}})"
          ).and include(
            "got: ({#{expected_keywords}})"
          ) # end match
        end # let

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end # describe

      describe 'with an actual that delegates the method to the target with the required arguments and keywords' do
        include_context 'with a delegate that responds to the method'

        let(:method_body) do
          keyword_names = method_keyword_names.map do |keyword_name|
            "#{keyword_name}: #{keyword_name}"
          end.join(', ')

          "target.send(method, #{method_parameter_names.join (', ')}, "\
          "#{keyword_names})"
        end # let
        let(:delegate_parameter_names) { method_parameter_names }
        let(:delegate_keyword_names)   { method_keyword_names }
        let(:failure_message) do
          super() << format_arguments <<
            ', but the block was not passed to the delegate'
        end # let

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end # describe

      describe 'with an actual that delegates the method to the target with the required arguments, keywords, and block' do
        include_context 'with a delegate that responds to the method'

        let(:method_body) do
          keyword_names = method_keyword_names.map do |keyword_name|
            "#{keyword_name}: #{keyword_name}"
          end.join(', ')

          "target.send(method, #{method_parameter_names.join (', ')}, "\
          "#{keyword_names}, &#{method_block_name})"
        end # let
        let(:delegate_parameter_names) { method_parameter_names }
        let(:delegate_keyword_names)   { method_keyword_names }
        let(:failure_message_when_negated) do
          super() << format_arguments
        end # let

        include_examples 'should fail with a negative expectation'

        include_examples 'should pass with a positive expectation'
      end # describe
    end # describe
  end # describe

  describe '#to' do
    let(:delegate) { double('delegate') }

    it { expect(instance).to respond_to(:to).with(1).arguments }

    it { expect(instance.to delegate).to be instance }
  end # describe to

  describe '#with_a_block' do
    it { expect(instance).to respond_to(:with_a_block).with(0).arguments }

    it { expect(instance).to alias_method(:with_a_block).as(:and_a_block) }

    it { expect(instance.with_a_block).to be instance }
  end # describe

  describe '#with_arguments' do
    it { expect(instance).to respond_to(:with_arguments).with_unlimited_arguments }

    it { expect(instance).to alias_method(:with_arguments).as(:and_arguments) }

    it { expect(instance.with_arguments :ichi, :ni, :san).to be instance }
  end # describe to

  describe '#with_keywords' do
    it { expect(instance).to respond_to(:with_keywords).with_any_keywords }

    it { expect(instance).to alias_method(:with_keywords).as(:and_keywords) }

    it { expect(instance.with_keywords :foo => 'foo', :bar => 'bar').to be instance }
  end # describe to
end # describe
