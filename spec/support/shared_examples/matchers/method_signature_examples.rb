# spec/support/shared_examples/matchers/method_signature_examples.rb

require 'support/shared_examples/matchers'
require 'sleeping_king_studios/tools/array_tools'

require 'rspec/sleeping_king_studios/concerns/shared_example_group'

module Spec::Support::SharedExamples::Matchers
  module MethodSignatureExamples
    extend RSpec::SleepingKingStudios::Concerns::SharedExampleGroup

    shared_examples 'should respond to method with signature' do |**signature|
      let(:with_arguments_message) { ' with arguments:' }

      private def count_arguments arity
        "#{arity} arguments"
      end # method count_arguments

      private def list_keywords keywords
        tools  = ::SleepingKingStudios::Tools::ArrayTools
        tools.humanize_list(keywords.map(&:inspect))
      end # method list_keywords

      describe 'with no argument expectation' do
        include_examples 'should pass with a positive expectation'

        include_examples 'should fail with a negative expectation'
      end # describe

      min_arguments       = signature.fetch(:min_arguments, 0)
      max_arguments       = signature.fetch(:max_arguments, min_arguments)
      unlimited_arguments = signature.fetch(:unlimited_arguments, false)
      valid_count         = (min_arguments + max_arguments) / 2
      insufficient_count  = [0, min_arguments - 2].min

      optional_keywords   = signature.fetch(:optional_keywords, [])
      required_keywords   = signature.fetch(:required_keywords, [])
      arbitrary_keywords  = signature.fetch(:arbitrary_keywords, false)
      allowed_keywords    = optional_keywords + required_keywords
      invalid_keywords    = [:forbidden, :disallowed]

      block_argument      = signature.fetch(:block_argument, false)

      if min_arguments > 0
        describe 'with not enough arguments' do
          let(:failure_message) do
            include(
              super() << with_arguments_message
            ).and include(
              "expected at least #{min_arguments} arguments, but received "\
              "#{insufficient_count}"
            ) # end include
          end # let
          let(:instance) do
            matcher = super()

            unless required_keywords.empty?
              matcher.with_keywords(*required_keywords)
            end # unless

            matcher.with(insufficient_count).arguments
          end # let

          include_examples 'should fail with a positive expectation'

          include_examples 'should pass with a negative expectation'
        end # describe
      end # if-else

      describe 'with a valid number of arguments' do
        let(:failure_message_when_negated) do
          message = super()

          message << " with #{valid_count} arguments"

          unless required_keywords.empty?
            message << " and keywords #{list_keywords required_keywords}"
          end # unless

          message
        end # let
        let(:instance) do
          matcher = super()

          matcher.with(valid_count).arguments

          unless required_keywords.empty?
            matcher.with_keywords(*required_keywords)
          end # unless

          matcher
        end # let

        include_examples 'should pass with a positive expectation'

        include_examples 'should fail with a negative expectation'
      end # describe

      if unlimited_arguments
        excessive_count = 9001

        describe 'with an excessive number of arguments' do
          let(:failure_message_when_negated) do
            super() << " with #{excessive_count} arguments"
          end # let
          let(:instance) do
            matcher = super()

            unless required_keywords.empty?
              matcher.with_keywords(*required_keywords)
            end # unless

            matcher.with(excessive_count).arguments
          end # let

          include_examples 'should pass with a positive expectation'

          include_examples 'should fail with a negative expectation'
        end # describe

        if min_arguments > 0
          describe 'with unlimited arguments' do
            let(:failure_message) do
              include(
                super() << ' with arguments:'
              ).and include(
                "expected at least #{min_arguments} arguments, but received "\
                "#{insufficient_count}"
              ) # end include
            end # let
            let(:instance) do
              matcher = super()

              unless required_keywords.empty?
                matcher.with_keywords(*required_keywords)
              end # unless

              matcher.with_unlimited_arguments
            end # let

            include_examples 'should fail with a positive expectation'

            include_examples 'should pass with a negative expectation'
          end # describe
        else
          describe 'with unlimited arguments' do
            let(:failure_message_when_negated) do
              super() << ' with unlimited arguments'
            end # let
            let(:instance) do
              matcher = super()

              unless required_keywords.empty?
                matcher.with_keywords(*required_keywords)
              end # unless

              matcher.with_unlimited_arguments
            end # let

            include_examples 'should pass with a positive expectation'

            include_examples 'should fail with a negative expectation'
          end # describe
        end # if-else

        describe 'with a valid number of arguments and unlimited arguments' do
          let(:failure_message_when_negated) do
            super() << " with #{valid_count} arguments and unlimited arguments"
          end # let
          let(:instance) do
            matcher = super()

            unless required_keywords.empty?
              matcher.with_keywords(*required_keywords)
            end # unless

            matcher.with(valid_count).arguments.and_unlimited_arguments
          end # let

          include_examples 'should pass with a positive expectation'

          include_examples 'should fail with a negative expectation'
        end # describe
      else
        excessive_count = max_arguments + 2

        describe 'with too many arguments' do
          let(:failure_message) do
            include(
              super() << ' with arguments:'
            ).and include(
              "expected at most #{max_arguments} arguments, but received "\
              "#{excessive_count}"
            ) # end include
          end # let
          let(:instance) do
            matcher = super()

            unless required_keywords.empty?
              matcher.with_keywords(*required_keywords)
            end # unless

            matcher.with(excessive_count).arguments
          end # let

          include_examples 'should fail with a positive expectation'

          include_examples 'should pass with a negative expectation'
        end # describe

        describe 'with unlimited arguments' do
          let(:failure_message) do
            include(
              super() << ' with arguments:'
            ).and include(
              "expected at most #{max_arguments} arguments, but received "\
              "unlimited arguments"
            ) # end include
          end # let
          let(:instance) do
            matcher = super()

            unless required_keywords.empty?
              matcher.with_keywords(*required_keywords)
            end # unless

            matcher.with_unlimited_arguments
          end # let

          include_examples 'should fail with a positive expectation'

          include_examples 'should pass with a negative expectation'
        end # describe

        describe 'with a valid number of arguments and unlimited_arguments' do
          let(:failure_message) do
            include(
              super() << ' with arguments:'
            ).and include(
              "expected at most #{max_arguments} arguments, but received "\
              "unlimited arguments"
            ) # end include
          end # let
          let(:instance) do
            matcher = super()

            unless required_keywords.empty?
              matcher.with_keywords(*required_keywords)
            end # unless

            matcher.with(valid_count).arguments.and_unlimited_arguments
          end # let
        end # describe
      end # if-else

      unless optional_keywords.empty?
        describe 'with valid keywords' do
          let(:keywords) { required_keywords + optional_keywords }
          let(:failure_message_when_negated) do
            message = super() << ' with'

            message << " #{min_arguments} arguments and"

            message << " keywords #{list_keywords keywords}"

            message
          end # let
          let(:instance) do
            matcher = super()

            matcher.with(min_arguments).arguments if min_arguments > 0

            matcher.with_keywords(*keywords)
          end # let

          include_examples 'should pass with a positive expectation'

          include_examples 'should fail with a negative expectation'
        end # describe

        describe 'with valid keywords using the deprecated syntax' do
          let(:keywords) { required_keywords + optional_keywords }
          let(:failure_message_when_negated) do
            message = super() << ' with'

            message << " #{min_arguments} arguments and"

            message << " keywords #{list_keywords keywords}"

            message
          end # let
          let(:instance) do
            matcher = super()

            matcher.with(min_arguments).arguments if min_arguments > 0

            matcher.with_keywords(*keywords)
          end # let

          include_examples 'should pass with a positive expectation'

          include_examples 'should fail with a negative expectation'
        end # describe
      end # unless

      unless required_keywords.empty?
        describe 'with required keywords' do
          let(:failure_message_when_negated) do
            message = super() << ' with'

            message << " #{min_arguments} arguments and"

            message << " keywords #{list_keywords required_keywords}"

            message
          end # let
          let(:instance) do
            matcher = super()

            matcher.with(min_arguments).arguments if min_arguments > 0

            matcher.with_keywords(*required_keywords)
          end # let

          include_examples 'should pass with a positive expectation'

          include_examples 'should fail with a negative expectation'
        end # describe

        describe 'with required keywords using the deprecated syntax' do
          let(:failure_message_when_negated) do
            message = super() << ' with'

            message << " #{min_arguments} arguments and"

            message << " keywords #{list_keywords required_keywords}"

            message
          end # let
          let(:instance) do
            matcher = super()

            matcher.with(min_arguments).arguments if min_arguments > 0

            matcher.with_keywords(*required_keywords)
          end # let

          include_examples 'should pass with a positive expectation'

          include_examples 'should fail with a negative expectation'
        end # describe

        describe 'with missing keywords' do
          let(:failure_message) do
            include(
              super() << with_arguments_message
            ).and include(
              "missing keywords #{list_keywords required_keywords}"
            ) # end include
          end # let
          let(:instance) do
            matcher = super()

            matcher.with(min_arguments).arguments if min_arguments > 0

            matcher.with_keywords(*optional_keywords)
          end # let

          include_examples 'should fail with a positive expectation'

          include_examples 'should pass with a negative expectation'
        end # describe
      end # unless

      if arbitrary_keywords
        describe 'with unexpected keywords' do
          let(:keywords) { required_keywords + invalid_keywords }
          let(:failure_message_when_negated) do
            message = super() << ' with'

            message << " #{min_arguments} arguments and"

            message << " keywords #{list_keywords keywords}"

            message
          end # let
          let(:instance) do
            matcher = super()

            matcher.with(min_arguments).arguments if min_arguments > 0

            matcher.with_keywords(*keywords)
          end # let

          include_examples 'should pass with a positive expectation'

          include_examples 'should fail with a negative expectation'
        end # describe

        describe 'with arbitrary keywords' do
          let(:failure_message_when_negated) do
            message  = super() << ' with '
            messages = []

            messages << "#{min_arguments} arguments"

            unless required_keywords.empty?
              messages << "keywords #{list_keywords required_keywords}"
            end # unless

            messages << 'arbitrary keywords'

            tools = ::SleepingKingStudios::Tools::ArrayTools
            message << tools.humanize_list(messages)

            message
          end # let
          let(:instance) do
            matcher = super()

            matcher.with(min_arguments).arguments if min_arguments > 0

            unless required_keywords.empty?
              matcher.with_keywords(*required_keywords)
            end # unless

            matcher.with_arbitrary_keywords
          end # let

          include_examples 'should pass with a positive expectation'

          include_examples 'should fail with a negative expectation'
        end # describe

        describe 'with unexpected and arbitrary keywords' do
          let(:keywords) { required_keywords + invalid_keywords }
          let(:failure_message_when_negated) do
            message = super() << ' with'

            message << " #{min_arguments} arguments,"

            message << " keywords #{list_keywords keywords},"

            message << ' and arbitrary keywords'

            message
          end # let
          let(:instance) do
            matcher = super()

            matcher.with(min_arguments).arguments if min_arguments > 0

            matcher.with_keywords(*keywords).and_arbitrary_keywords
          end # let

          include_examples 'should pass with a positive expectation'

          include_examples 'should fail with a negative expectation'
        end # describe
      else
        describe 'with unexpected keywords' do
          let(:keywords) { required_keywords + invalid_keywords }
          let(:failure_message) do
            include(
              super() << with_arguments_message
            ).and include(
              "unexpected keywords #{list_keywords invalid_keywords}"
            ) # end include
          end # let
          let(:instance) do
            matcher = super()

            matcher.with(min_arguments).arguments if min_arguments > 0

            matcher.with_keywords(*keywords)
          end # let

          include_examples 'should fail with a positive expectation'

          include_examples 'should pass with a negative expectation'
        end # describe

        describe 'with arbitrary keywords' do
          let(:failure_message) do
            include(
              super() << with_arguments_message
            ).and include(
              'expected arbitrary keywords'
            ) # end include
          end # let
          let(:instance) do
            matcher = super()

            matcher.with(min_arguments).arguments if min_arguments > 0

            unless required_keywords.empty?
              matcher.with_keywords(*required_keywords)
            end # unless

            matcher.with_arbitrary_keywords
          end # let

          include_examples 'should fail with a positive expectation'

          include_examples 'should pass with a negative expectation'
        end # describe

        describe 'with unexpected keywords and arbitrary keywords' do
          let(:keywords) { required_keywords + invalid_keywords }
          let(:failure_message) do
            include(
              super() << with_arguments_message
            ).and include(
              "unexpected keywords #{list_keywords invalid_keywords}"
            ).and include(
              'expected arbitrary keywords'
            ) # end include
          end # let
          let(:instance) do
            matcher = super()

            matcher.with(min_arguments).arguments if min_arguments > 0

            matcher.with_keywords(*keywords).and_arbitrary_keywords
          end # let

          include_examples 'should fail with a positive expectation'

          include_examples 'should pass with a negative expectation'
        end # describe
      end # if-else

      if block_argument
        describe 'without a block' do
          include_examples 'should pass with a positive expectation'

          include_examples 'should fail with a negative expectation'
        end # describe

        describe 'with a block' do
          let(:failure_message_when_negated) do
            message  = super() << ' with '
            messages = []

            messages << "#{min_arguments} arguments"

            unless required_keywords.empty?
              messages << "keywords #{list_keywords required_keywords}"
            end # unless

            messages << 'a block'

            tools = ::SleepingKingStudios::Tools::ArrayTools
            message << tools.humanize_list(messages)

            message
          end # let
          let(:instance) do
            matcher = super()

            matcher.with(min_arguments).arguments if min_arguments > 0

            unless required_keywords.empty?
              matcher.with_keywords(*required_keywords)
            end # unless

            matcher.with_a_block
          end # let

          include_examples 'should pass with a positive expectation'

          include_examples 'should fail with a negative expectation'
        end # describe
      else
        describe 'with a block' do
          let(:failure_message) do
            include(
              super() << with_arguments_message
            ).and include(
              'unexpected block'
            ) # end include
          end # let
          let(:instance) { super().with_a_block }

          include_examples 'should fail with a positive expectation'

          include_examples 'should pass with a negative expectation'
        end # describe
      end # if-else
    end # shared_examples
  end # module
end # module
