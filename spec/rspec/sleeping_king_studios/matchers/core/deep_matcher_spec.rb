# frozen_string_literal: true

require 'bigdecimal'

require 'spec_helper'

require 'rspec/sleeping_king_studios/concerns/example_constants'
require 'rspec/sleeping_king_studios/examples/rspec_matcher_examples'
require 'rspec/sleeping_king_studios/matchers/core/construct'
require 'rspec/sleeping_king_studios/matchers/core/deep_matcher'

RSpec.describe RSpec::SleepingKingStudios::Matchers::Core::DeepMatcher do
  extend  RSpec::SleepingKingStudios::Concerns::ExampleConstants
  include RSpec::SleepingKingStudios::Examples::RSpecMatcherExamples

  subject(:matcher) { described_class.new(expected) }

  let(:expected) { expected }

  describe '::new' do
    it { expect(described_class).to be_constructible.with(1).argument }
  end

  describe '#description' do
    let(:description) { "match #{expected.inspect}" }

    context 'when expected is nil' do
      let(:expected) { nil }

      it { expect(matcher.description).to be == description }
    end

    context 'when expected is an Object' do
      let(:expected) { Object.new }

      it { expect(matcher.description).to be == description }
    end

    context 'when expected is a String' do
      let(:expected) { 'What lies beyond the furthest reaches of the sky?' }

      it { expect(matcher.description).to be == description }
    end

    context 'when expected is a matcher' do
      let(:expected)    { an_instance_of(String) }
      let(:description) { "match #{expected.description}" }

      it { expect(matcher.description).to be == description }
    end

    context 'when expected is an Array' do
      let(:expected) { %w[ichi ni san] }

      it { expect(matcher.description).to be == description }
    end

    context 'when expected is a Hash with string keys' do
      let(:expected) do
        {
          'ichi' => 1,
          'ni'   => 2,
          'san'  => 3
        }
      end

      it { expect(matcher.description).to be == description }
    end

    context 'when expected is a Hash with string keys and mixed values' do
      let(:author) { Spec::Author.new('J.R.R. Tolkien') }
      let(:expected) do
        {
          'id'     => an_instance_of(Integer),
          'title'  => 'The Hobbit',
          'author' => author
        }
      end
      let(:description) do
        "match #{format_expected(expected)}"
      end

      example_class 'Spec::Author', Struct.new(:name)

      it { expect(matcher.description).to be == description }
    end

    context 'when expected is a Hash with symbol keys' do
      let(:expected) do
        {
          ichi: 1,
          ni:   2,
          san:  3
        }
      end
      let(:description) do
        "match #{format_expected(expected)}"
      end

      it { expect(matcher.description).to be == description }
    end
  end

  describe '#matches?' do
    let(:failure_message) do
      "expected: == #{format_expected(expected)}\n" \
        "     got:    #{format_expected(actual)}"
    end
    let(:failure_message_when_negated) do
      "`expect(#{format_expected(expected)}).not_to be == " \
        "#{format_expected(actual)}`"
    end
    let(:diff_message) do
      "\n\n(compared using Hashdiff)\n\nDiff:\n"
    end

    context 'when expected is nil' do
      let(:expected) { nil }

      describe 'with nil' do
        let(:actual) { nil }

        include_examples 'should pass with a positive expectation'

        include_examples 'should fail with a negative expectation'
      end

      describe 'with an Object' do
        let(:actual) { Object.new }

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end

      describe 'with a String' do
        let(:actual) { 'The waves that flow and dye the land gold.' }

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end

      describe 'with an Array' do
        let(:actual) { %w[ichi ni san] }

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end

      describe 'with a Hash' do
        let(:actual) do
          {
            ichi: 1,
            ni:   2,
            san:  3
          }
        end

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end
    end

    context 'when expected is an Object' do
      let(:expected) { Object.new }

      describe 'with nil' do
        let(:actual) { nil }

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end

      describe 'with a non-matching Object' do
        let(:actual) { Object.new }

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end

      describe 'with a matching Object' do
        let(:actual) { expected }

        include_examples 'should pass with a positive expectation'

        include_examples 'should fail with a negative expectation'
      end

      describe 'with a String' do
        let(:actual) { 'The waves that flow and dye the land gold.' }

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end

      describe 'with an Array' do
        let(:actual) { %w[ichi ni san] }

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end

      describe 'with a Hash' do
        let(:actual) do
          {
            ichi: 1,
            ni:   2,
            san:  3
          }
        end

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end
    end

    context 'when expected is a String' do
      let(:expected) { 'What lies beyond the furthest reaches of the sky?' }

      describe 'with nil' do
        let(:actual) { nil }

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end

      describe 'with an Object' do
        let(:actual) { Object.new }

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end

      describe 'with a non-matching String' do
        let(:actual) { 'The waves that flow and dye the land gold.' }

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end

      describe 'with a matching String' do
        let(:actual) { 'What lies beyond the furthest reaches of the sky?' }

        include_examples 'should pass with a positive expectation'

        include_examples 'should fail with a negative expectation'
      end

      describe 'with an Array' do
        let(:actual) { %w[ichi ni san] }

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end

      describe 'with a Hash' do
        let(:actual) do
          {
            ichi: 1,
            ni:   2,
            san:  3
          }
        end

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end
    end

    context 'when expected is a matcher' do
      let(:expected) { be_a(String) }
      let(:failure_message) do
        be_a(String).tap { |mch| mch.matches?(actual) }.failure_message
      end
      let(:failure_message_when_negated) do
        be_a(String)
          .tap { |mch| mch.matches?(actual) }
          .failure_message_when_negated
      end

      describe 'with an object that does not satisfy the matcher' do
        let(:actual) { Object.new }

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end

      describe 'with an object that satisfies the matcher' do
        let(:actual) { 'The path the angels descend upon.' }

        include_examples 'should pass with a positive expectation'

        include_examples 'should fail with a negative expectation'
      end
    end

    context 'when expected is an Array' do
      let(:expected) { %w[ichi ni san] }

      describe 'with nil' do
        let(:actual) { nil }

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end

      describe 'with an Object' do
        let(:actual) { Object.new }

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end

      describe 'with a String' do
        let(:actual) { 'The waves that flow and dye the land gold.' }

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end

      describe 'with a Hash' do
        let(:actual) do
          {
            ichi: 1,
            ni:   2,
            san:  3
          }
        end

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end

      describe 'with an empty Array' do
        let(:actual) { [] }
        let(:failure_message) do
          super() + diff_message + expected_diff
        end
        let(:expected_diff) do
          <<~STRING.strip
            - 0 => expected "ichi"
            - 1 => expected "ni"
            - 2 => expected "san"
          STRING
        end

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end

      describe 'with a non-matching Array' do
        let(:actual) { %w[yon go roku] }
        let(:failure_message) do
          super() + diff_message + expected_diff
        end
        let(:expected_diff) do
          <<~STRING.strip
            ~ 0 => expected "ichi", got "yon"
            ~ 1 => expected "ni", got "go"
            ~ 2 => expected "san", got "roku"
          STRING
        end

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end

      describe 'with a matching Array' do
        let(:actual) { %w[ichi ni san] }

        include_examples 'should pass with a positive expectation'

        include_examples 'should fail with a negative expectation'
      end

      describe 'with an array with missing items' do
        let(:actual) { %w[ichi san] }
        let(:failure_message) do
          super() + diff_message + expected_diff
        end
        let(:expected_diff) do
          '- 1 => expected "ni"'
        end

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end

      describe 'with an array with added items' do
        let(:actual) { %w[rei ichi ni san yon] }
        let(:failure_message) do
          super() + diff_message + expected_diff
        end
        let(:expected_diff) do
          <<~STRING.strip
            + 0 => got "rei"
            + 4 => got "yon"
          STRING
        end

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end

      describe 'with an array with changed items' do
        let(:actual) { %w[ichi two san] }
        let(:failure_message) do
          super() + diff_message + expected_diff
        end
        let(:expected_diff) do
          '~ 1 => expected "ni", got "two"'
        end

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end

      describe 'with an array with misordered items' do
        let(:actual) { %w[ni san ichi] }
        let(:failure_message) do
          super() + diff_message + expected_diff
        end
        let(:expected_diff) do
          <<~STRING.strip
            ~ 0 => expected "ichi", got "ni"
            ~ 1 => expected "ni", got "san"
            ~ 2 => expected "san", got "ichi"
          STRING
        end

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end

      describe 'with an array with different items' do
        let(:actual) { %w[rei ichi two san yon go] }
        let(:failure_message) do
          super() + diff_message + expected_diff
        end
        let(:expected_diff) do
          <<~STRING.strip
            + 0 => got "rei"
            ~ 1 => expected "ni", got "two"
            + 4 => got "yon"
            + 5 => got "go"
          STRING
        end

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end
    end

    context 'when expected is an Array of matchers' do
      let(:expected) do
        [
          an_instance_of(String),
          an_instance_of(Integer),
          an_instance_of(String)
        ]
      end
      let(:expected_descriptions) do
        '[' \
          'an instance of String, ' \
          'an instance of Integer, ' \
          'an instance of String' \
          ']'
      end
      let(:failure_message) do
        "expected: == #{expected_descriptions}\n" \
          "     got:    #{format_expected(actual)}"
      end
      let(:failure_message_when_negated) do
        "`expect(#{expected_descriptions}).not_to be == " \
          "#{format_expected(actual)}`"
      end

      describe 'with nil' do
        let(:actual) { nil }

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end

      describe 'with an Object' do
        let(:actual) { Object.new }

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end

      describe 'with a String' do
        let(:actual) { 'The waves that flow and dye the land gold.' }

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end

      describe 'with a Hash' do
        let(:actual) do
          {
            ichi: 1,
            ni:   2,
            san:  3
          }
        end

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end

      describe 'with an empty Array' do
        let(:actual) { [] }
        let(:failure_message) do
          super() + diff_message + expected_diff
        end
        let(:expected_diff) do
          <<~STRING.strip
            - 0 => expected an instance of String
            - 1 => expected an instance of Integer
            - 2 => expected an instance of String
          STRING
        end

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end

      describe 'with a non-matching Array' do
        let(:actual) { %i[ichi ni san] }
        let(:failure_message) do
          super() + diff_message + expected_diff
        end
        let(:expected_diff) do
          <<~STRING.strip
            ~ 0 => expected an instance of String, got :ichi
            ~ 1 => expected an instance of Integer, got :ni
            ~ 2 => expected an instance of String, got :san
          STRING
        end

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end

      describe 'with a partially matching Array' do
        let(:actual) { ['There are', 'four', 'lights'] }
        let(:failure_message) do
          super() + diff_message + expected_diff
        end
        let(:expected_diff) do
          '~ 1 => expected an instance of Integer, got "four"'
        end

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end

      describe 'with a matching Array' do
        let(:actual) { ['There are', 4, 'lights'] }

        include_examples 'should pass with a positive expectation'

        include_examples 'should fail with a negative expectation'
      end
    end

    context 'when expected is an Array with nested Arrays' do
      let(:expected) do
        [
          %w[ichi ni san],
          %w[uno dos tres],
          %w[one two three]
        ]
      end

      describe 'with nil' do
        let(:actual) { nil }

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end

      describe 'with an Object' do
        let(:actual) { Object.new }

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end

      describe 'with a String' do
        let(:actual) { 'The waves that flow and dye the land gold.' }

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end

      describe 'with a Hash' do
        let(:actual) do
          {
            ichi: 1,
            ni:   2,
            san:  3
          }
        end

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end

      describe 'with an empty Array' do
        let(:actual) { [] }
        let(:failure_message) do
          super() + diff_message + expected_diff
        end
        let(:expected_diff) do
          <<~STRING.strip
            - 0 => expected ["ichi", "ni", "san"]
            - 1 => expected ["uno", "dos", "tres"]
            - 2 => expected ["one", "two", "three"]
          STRING
        end

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end

      describe 'with a non-matching Array' do
        let(:actual) { %w[yon go roku] }
        let(:failure_message) do
          super() + diff_message + expected_diff
        end
        let(:expected_diff) do
          <<~STRING.strip
            ~ 0 => expected ["ichi", "ni", "san"], got "yon"
            ~ 1 => expected ["uno", "dos", "tres"], got "go"
            ~ 2 => expected ["one", "two", "three"], got "roku"
          STRING
        end

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end

      describe 'with a matching Array' do
        let(:actual) do
          [
            %w[ichi ni san],
            %w[uno dos tres],
            %w[one two three]
          ]
        end

        include_examples 'should pass with a positive expectation'

        include_examples 'should fail with a negative expectation'
      end

      describe 'with an Array with missing items' do
        let(:actual) do
          [
            %w[ichi ni san],
            %w[one two three]
          ]
        end
        let(:failure_message) do
          super() + diff_message + expected_diff
        end
        let(:expected_diff) do
          '- 1 => expected ["uno", "dos", "tres"]'
        end

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end

      describe 'with an Array with missing sub-items' do
        let(:actual) do
          [
            %w[ni san],
            %w[uno tres],
            %w[one two]
          ]
        end
        let(:failure_message) do
          super() + diff_message + expected_diff
        end
        let(:expected_diff) do
          <<~STRING.strip
            - 0.0 => expected "ichi"
            - 1.1 => expected "dos"
            - 2.2 => expected "three"
          STRING
        end

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end

      describe 'with an Array with added items' do
        let(:actual) do
          [
            %w[yi er san],
            %w[ichi ni san],
            %w[un deux trois],
            %w[uno dos tres],
            %w[one two three],
            %w[et to tre]
          ]
        end
        let(:failure_message) do
          super() + diff_message + expected_diff
        end
        let(:expected_diff) do
          <<~STRING.strip
            + 0 => got ["yi", "er", "san"]
            + 2 => got ["un", "deux", "trois"]
            + 5 => got ["et", "to", "tre"]
          STRING
        end

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end

      describe 'with an Array with added sub-items' do
        let(:actual) do
          [
            %w[rei ichi ni san],
            %w[uno dos dos-y-medio tres],
            %w[one two three four]
          ]
        end
        let(:failure_message) do
          super() + diff_message + expected_diff
        end
        let(:expected_diff) do
          <<~STRING.strip
            + 0.0 => got "rei"
            + 1.2 => got "dos-y-medio"
            + 2.3 => got "four"
          STRING
        end

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end

      describe 'with an Array with changed items' do
        let(:actual) do
          [
            %w[ichi ni san],
            %w[un deux trois],
            %w[one two three]
          ]
        end
        let(:failure_message) do
          super() + diff_message + expected_diff
        end
        let(:expected_diff) do
          <<~STRING.strip
            ~ 1.0 => expected "uno", got "un"
            ~ 1.1 => expected "dos", got "deux"
            ~ 1.2 => expected "tres", got "trois"
          STRING
        end

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end

      describe 'with an Array with changed sub-items' do
        let(:actual) do
          [
            %w[yi ni san],
            %w[uno deux tres],
            %w[one two tre]
          ]
        end
        let(:failure_message) do
          super() + diff_message + expected_diff
        end
        let(:expected_diff) do
          <<~STRING.strip
            ~ 0.0 => expected "ichi", got "yi"
            ~ 1.1 => expected "dos", got "deux"
            ~ 2.2 => expected "three", got "tre"
          STRING
        end

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end

      describe 'with an Array with different items and sub-items' do
        let(:actual) do
          [
            %w[rei ichi ni],
            %w[one two three],
            %w[et to tre]
          ]
        end
        let(:failure_message) do
          super() + diff_message + expected_diff
        end
        let(:expected_diff) do
          <<~STRING.strip
            ~ 0.0 => expected "ichi", got "rei"
            ~ 0.1 => expected "ni", got "ichi"
            ~ 0.2 => expected "san", got "ni"
            ~ 1.0 => expected "uno", got "one"
            ~ 1.1 => expected "dos", got "two"
            ~ 1.2 => expected "tres", got "three"
            ~ 2.0 => expected "one", got "et"
            ~ 2.1 => expected "two", got "to"
            ~ 2.2 => expected "three", got "tre"
          STRING
        end

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end
    end

    context 'when expected is an Array with nested Hashes' do
      let(:expected) do
        [
          {
            id:     1,
            title:  'The Fellowship of the Ring',
            author: 'J.R.R. Tolkien'
          },
          {
            id:     2,
            title:  'The Two Towers',
            author: 'J.R.R. Tolkien'
          },
          {
            id:     3,
            title:  'The Return of the King',
            author: 'J.R.R. Tolkien'
          }
        ]
      end

      describe 'with nil' do
        let(:actual) { nil }

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end

      describe 'with an Object' do
        let(:actual) { Object.new }

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end

      describe 'with a String' do
        let(:actual) { 'The waves that flow and dye the land gold.' }

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end

      describe 'with a Hash' do
        let(:actual) do
          {
            ichi: 1,
            ni:   2,
            san:  3
          }
        end

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end

      describe 'with an empty Array' do
        let(:actual) { [] }
        let(:failure_message) do
          super() + diff_message + expected_diff
        end
        let(:expected_diff) do
          <<~STRING.strip
            - 0 => expected #{format_expected(expected[0])}
            - 1 => expected #{format_expected(expected[1])}
            - 2 => expected #{format_expected(expected[2])}
          STRING
        end

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end

      describe 'with a non-matching Array' do
        let(:actual) { %w[yon go roku] }
        let(:failure_message) do
          super() + diff_message + expected_diff
        end
        let(:expected_diff) do
          <<~STRING.strip
            ~ 0 => expected #{format_expected(expected[0])}, got "yon"
            ~ 1 => expected #{format_expected(expected[1])}, got "go"
            ~ 2 => expected #{format_expected(expected[2])}, got "roku"
          STRING
        end

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end

      describe 'with a matching Array' do
        let(:actual) do
          [
            {
              id:     1,
              title:  'The Fellowship of the Ring',
              author: 'J.R.R. Tolkien'
            },
            {
              id:     2,
              title:  'The Two Towers',
              author: 'J.R.R. Tolkien'
            },
            {
              id:     3,
              title:  'The Return of the King',
              author: 'J.R.R. Tolkien'
            }
          ]
        end

        include_examples 'should pass with a positive expectation'

        include_examples 'should fail with a negative expectation'
      end

      describe 'with an Array with missing items' do
        let(:actual) do
          [
            {
              id:     1,
              title:  'The Fellowship of the Ring',
              author: 'J.R.R. Tolkien'
            },
            {
              id:     3,
              title:  'The Return of the King',
              author: 'J.R.R. Tolkien'
            }
          ]
        end
        let(:failure_message) do
          super() + diff_message + expected_diff
        end
        let(:expected_diff) do
          "- 1 => expected #{format_expected(expected[1])}"
        end

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end

      describe 'with an Array with missing sub-keys' do
        let(:actual) do
          [
            {
              title:  'The Fellowship of the Ring',
              author: 'J.R.R. Tolkien'
            },
            {
              id:     2,
              author: 'J.R.R. Tolkien'
            },
            {
              id:    3,
              title: 'The Return of the King'
            }
          ]
        end
        let(:failure_message) do
          super() + diff_message + expected_diff
        end
        let(:expected_diff) do
          <<~STRING.strip
            - 0.:id => expected 1
            - 1.:title => expected "The Two Towers"
            - 2.:author => expected "J.R.R. Tolkien"
          STRING
        end

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end

      describe 'with an Array with extra items' do
        let(:actual) do
          [
            {
              id:     0,
              title:  'The Hobbit',
              author: 'J.R.R. Tolkien'
            },
            {
              id:     1,
              title:  'The Fellowship of the Ring',
              author: 'J.R.R. Tolkien'
            },
            {
              id:     2,
              title:  'The Two Towers',
              author: 'J.R.R. Tolkien'
            },
            {
              id:     3,
              title:  'The Return of the King',
              author: 'J.R.R. Tolkien'
            }
          ]
        end
        let(:failure_message) do
          super() + diff_message + expected_diff
        end
        let(:expected_diff) do
          "+ 0 => got #{format_expected(actual.first)}"
        end

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end

      describe 'with an Array with extra sub-keys' do
        let(:actual) do
          [
            {
              book:   '1..2 of 6',
              id:     1,
              title:  'The Fellowship of the Ring',
              author: 'J.R.R. Tolkien'
            },
            {
              id:      2,
              title:   'The Two Towers',
              hobbits: 'taken to Isengard',
              author:  'J.R.R. Tolkien'
            },
            {
              id:     3,
              title:  'The Return of the King',
              author: 'J.R.R. Tolkien',
              shire:  :scoured
            }
          ]
        end
        let(:failure_message) do
          super() + diff_message + expected_diff
        end
        let(:expected_diff) do
          <<~STRING.strip
            + 0.:book => got "1..2 of 6"
            + 1.:hobbits => got "taken to Isengard"
            + 2.:shire => got :scoured
          STRING
        end

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end

      describe 'with an Array with changed items' do
        let(:actual) do
          [
            {
              id:     1,
              title:  'The Fellowship of the Ring',
              author: 'J.R.R. Tolkien'
            },
            Struct.new(:title).new('The Two Towers'),
            {
              id:     3,
              title:  'The Return of the King',
              author: 'J.R.R. Tolkien'
            }
          ]
        end
        let(:failure_message) do
          super() + diff_message + expected_diff
        end
        let(:expected_diff) do
          "~ 1 => expected #{format_expected(expected[1])}, got " \
            '#<struct title="The Two Towers">'
        end

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end

      describe 'with an Array with changed sub-keys' do
        let(:actual) do
          [
            {
              id:     1,
              title:  'The Fellowship of the Ring',
              author: 'Tolkien'
            },
            {
              id:     2,
              title:  'Isengard and Minas Morgul',
              author: 'J.R.R. Tolkien'
            },
            {
              id:     'Three',
              title:  'The Return of the King',
              author: 'J.R.R. Tolkien'
            }
          ]
        end
        let(:failure_message) do
          super() + diff_message + expected_diff
        end
        let(:expected_diff) do
          <<~STRING.strip
            ~ 0.:author => expected "J.R.R. Tolkien", got "Tolkien"
            ~ 1.:title => expected "The Two Towers", got "Isengard and Minas Morgul"
            ~ 2.:id => expected 3, got "Three"
          STRING
        end

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end

      describe 'with an Array with different items and sub-keys' do
        let(:actual) do
          [
            {
              id:     0,
              title:  'The Hobbit',
              author: 'J.R.R. Tolkien'
            },
            {
              book:  '1..2 of 6',
              id:    1,
              title: 'The Fellowship of the Ring'
            },
            Struct.new(:title).new('The Two Towers'),
            {
              id:     'Three',
              title:  'The Return of the King',
              author: 'J.R.R. Tolkien'
            }
          ]
        end
        let(:failure_message) do
          super() + diff_message + expected_diff
        end
        let(:expected_diff) do
          <<~STRING.strip
            ~ 0.:id => expected 1, got 0
            ~ 0.:title => expected "The Fellowship of the Ring", got "The Hobbit"
            - 1.:author => expected "J.R.R. Tolkien"
            + 1.:book => got "1..2 of 6"
            ~ 1.:id => expected 2, got 1
            ~ 1.:title => expected "The Two Towers", got "The Fellowship of the Ring"
            ~ 2 => expected #{format_expected(expected[2])}, got #<struct title="The Two Towers">
            + 3 => got #{format_expected(actual.last)}
          STRING
        end

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end
    end

    context 'when expected is a Hash with string keys' do
      let(:expected) do
        {
          'ichi' => 1,
          'ni'   => 2,
          'san'  => 3
        }
      end

      describe 'with nil' do
        let(:actual) { nil }

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end

      describe 'with an Object' do
        let(:actual) { Object.new }

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end

      describe 'with a String' do
        let(:actual) { 'The waves that flow and dye the land gold.' }

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end

      describe 'with an Array' do
        let(:actual) { %w[ichi ni san] }

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end

      describe 'with an empty Hash' do
        let(:actual) { {} }
        let(:failure_message) do
          super() + diff_message + expected_diff
        end
        let(:expected_diff) do
          <<~STRING.strip
            - "ichi" => expected 1
            - "ni" => expected 2
            - "san" => expected 3
          STRING
        end

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end

      describe 'with a non-matching Hash with String keys' do
        let(:actual) do
          {
            'yon'  => 4,
            'go'   => 5,
            'roku' => 6
          }
        end
        let(:failure_message) do
          super() + diff_message + expected_diff
        end
        let(:expected_diff) do
          <<~STRING.strip
            + "go" => got 5
            - "ichi" => expected 1
            - "ni" => expected 2
            + "roku" => got 6
            - "san" => expected 3
            + "yon" => got 4
          STRING
        end

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end

      describe 'with a matching Hash with String keys' do
        let(:actual) do
          {
            'ichi' => 1,
            'ni'   => 2,
            'san'  => 3
          }
        end

        include_examples 'should pass with a positive expectation'

        include_examples 'should fail with a negative expectation'
      end

      describe 'with a Hash with String keys and missing values' do
        let(:actual) do
          {
            'ichi' => 1,
            'san'  => 3
          }
        end
        let(:failure_message) do
          super() + diff_message + expected_diff
        end
        let(:expected_diff) do
          '- "ni" => expected 2'
        end

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end

      describe 'with a Hash with String keys and added values' do
        let(:actual) do
          {
            'ichi' => 1,
            'ni'   => 2,
            'san'  => 3,
            'yon'  => 4
          }
        end
        let(:failure_message) do
          super() + diff_message + expected_diff
        end
        let(:expected_diff) do
          '+ "yon" => got 4'
        end

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end

      describe 'with a Hash with String keys and changed values' do
        let(:actual) do
          {
            'ichi' => 1,
            'ni'   => 2,
            'san'  => 'three'
          }
        end
        let(:failure_message) do
          super() + diff_message + expected_diff
        end
        let(:expected_diff) do
          '~ "san" => expected 3, got "three"'
        end

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end

      describe 'with a Hash with String keys and different keys and values' do
        let(:actual) do
          {
            'ichi' => 1,
            'san'  => 'three',
            'yon'  => 4,
            'go'   => 5,
            'roku' => 6
          }
        end
        let(:failure_message) do
          super() + diff_message + expected_diff
        end
        let(:expected_diff) do
          <<~STRING.strip
            + "go" => got 5
            - "ni" => expected 2
            + "roku" => got 6
            ~ "san" => expected 3, got "three"
            + "yon" => got 4
          STRING
        end

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end

      describe 'with a non-matching Hash with Symbol keys' do
        let(:actual) do
          {
            yon:  4,
            go:   5,
            roku: 6
          }
        end
        let(:failure_message) do
          super() + diff_message + expected_diff
        end
        let(:expected_diff) do
          <<~STRING.strip
            + :go => got 5
            - "ichi" => expected 1
            - "ni" => expected 2
            + :roku => got 6
            - "san" => expected 3
            + :yon => got 4
          STRING
        end

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end

      describe 'with a matching Hash with Symbol keys' do
        let(:actual) do
          {
            ichi: 1,
            ni:   2,
            san:  3
          }
        end
        let(:failure_message) do
          super() + diff_message + expected_diff
        end
        let(:expected_diff) do
          <<~STRING.strip
            - "ichi" => expected 1
            + :ichi => got 1
            - "ni" => expected 2
            + :ni => got 2
            - "san" => expected 3
            + :san => got 3
          STRING
        end

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end
    end

    context 'when expected is a Hash with string keys and Array values' do
      let(:expected) do
        {
          'japanese'  => %w[daito shoto tachi],
          'european'  => %w[einhänder zweihänder spatha],
          'legendary' => %w[excalibur kusanagi durendal]
        }
      end

      describe 'with nil' do
        let(:actual) { nil }

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end

      describe 'with an Object' do
        let(:actual) { Object.new }

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end

      describe 'with a String' do
        let(:actual) { 'The waves that flow and dye the land gold.' }

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end

      describe 'with an Array' do
        let(:actual) { %w[ichi ni san] }

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end

      describe 'with an empty Hash' do
        let(:actual) { {} }
        let(:failure_message) do
          super() + diff_message + expected_diff
        end
        let(:expected_diff) do
          <<~STRING.strip
            - "european" => expected ["einhänder", "zweihänder", "spatha"]
            - "japanese" => expected ["daito", "shoto", "tachi"]
            - "legendary" => expected ["excalibur", "kusanagi", "durendal"]
          STRING
        end

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end

      describe 'with a non-matching Hash with String keys' do
        let(:actual) do
          {
            'yon'  => 4,
            'go'   => 5,
            'roku' => 6
          }
        end
        let(:failure_message) do
          super() + diff_message + expected_diff
        end
        let(:expected_diff) do
          <<~STRING.strip
            - "european" => expected ["einhänder", "zweihänder", "spatha"]
            + "go" => got 5
            - "japanese" => expected ["daito", "shoto", "tachi"]
            - "legendary" => expected ["excalibur", "kusanagi", "durendal"]
            + "roku" => got 6
            + "yon" => got 4
          STRING
        end

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end

      describe 'with a matching Hash with String keys' do
        let(:actual) do
          {
            'japanese'  => %w[daito shoto tachi],
            'european'  => %w[einhänder zweihänder spatha],
            'legendary' => %w[excalibur kusanagi durendal]
          }
        end

        include_examples 'should pass with a positive expectation'

        include_examples 'should fail with a negative expectation'
      end

      describe 'with a Hash with String keys and missing values' do
        let(:actual) do
          {
            'european'  => %w[einhänder zweihänder spatha],
            'legendary' => %w[excalibur kusanagi durendal]
          }
        end
        let(:failure_message) do
          super() + diff_message + expected_diff
        end
        let(:expected_diff) do
          '- "japanese" => expected ["daito", "shoto", "tachi"]'
        end

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end

      describe 'with a Hash with String keys and missing sub-items' do
        let(:actual) do
          {
            'japanese'  => %w[shoto tachi],
            'european'  => %w[einhänder spatha],
            'legendary' => %w[excalibur kusanagi]
          }
        end
        let(:failure_message) do
          super() + diff_message + expected_diff
        end
        let(:expected_diff) do
          <<~STRING.strip
            - "european".1 => expected "zweihänder"
            - "japanese".0 => expected "daito"
            - "legendary".2 => expected "durendal"
          STRING
        end

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end

      describe 'with a Hash with String keys and added values' do
        let(:actual) do
          {
            'japanese'  => %w[daito shoto tachi],
            'european'  => %w[einhänder zweihänder spatha],
            'generic'   => %w[shortsword longsword greatsword],
            'legendary' => %w[excalibur kusanagi durendal]
          }
        end
        let(:failure_message) do
          super() + diff_message + expected_diff
        end
        let(:expected_diff) do
          '+ "generic" => got ["shortsword", "longsword", "greatsword"]'
        end

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end

      describe 'with a Hash with String keys and added sub-items' do
        let(:actual) do
          {
            'japanese'  => %w[wakizashi daito shoto tachi],
            'european'  => %w[einhänder zweihänder claymore spatha],
            'legendary' => %w[excalibur kusanagi durendal kalevanmiekka]
          }
        end
        let(:failure_message) do
          super() + diff_message + expected_diff
        end
        let(:expected_diff) do
          <<~STRING.strip
            + "european".2 => got "claymore"
            + "japanese".0 => got "wakizashi"
            + "legendary".3 => got "kalevanmiekka"
          STRING
        end

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end

      describe 'with a Hash with String keys and changed values' do
        let(:actual) do
          {
            'japanese'  => %w[daito shoto tachi],
            'european'  => %w[einhänder zweihänder spatha],
            'legendary' => [
              'Mmaagha Kamalu',
              'Thuận Thiên',
              'Cura Si Manjakini'
            ]
          }
        end
        let(:failure_message) do
          super() + diff_message + expected_diff
        end
        let(:expected_diff) do
          <<~STRING.strip
            ~ "legendary".0 => expected "excalibur", got "Mmaagha Kamalu"
            ~ "legendary".1 => expected "kusanagi", got "Thuận Thiên"
            ~ "legendary".2 => expected "durendal", got "Cura Si Manjakini"
          STRING
        end

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end

      describe 'with a Hash with String keys and changed sub-items' do
        let(:actual) do
          {
            'japanese'  => %w[wakizashi shoto tachi],
            'european'  => %w[einhänder claymore spatha],
            'legendary' => %w[excalibur kusanagi kalevanmiekka]
          }
        end
        let(:failure_message) do
          super() + diff_message + expected_diff
        end
        let(:expected_diff) do
          <<~STRING.strip
            ~ "european".1 => expected "zweihänder", got "claymore"
            ~ "japanese".0 => expected "daito", got "wakizashi"
            ~ "legendary".2 => expected "durendal", got "kalevanmiekka"
          STRING
        end

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end

      describe 'with a Hash with String keys and different values' do
        let(:actual) do
          {
            'european'  => %w[einhänder zweihänder claymore],
            'legendary' => [
              'Mmaagha Kamalu',
              'Thuận Thiên',
              'Cura Si Manjakini'
            ],
            'generic'   => %w[shortsword longsword greatsword]
          }
        end
        let(:failure_message) do
          super() + diff_message + expected_diff
        end
        let(:expected_diff) do
          <<~STRING.strip
            ~ "european".2 => expected "spatha", got "claymore"
            + "generic" => got ["shortsword", "longsword", "greatsword"]
            - "japanese" => expected ["daito", "shoto", "tachi"]
            ~ "legendary".0 => expected "excalibur", got "Mmaagha Kamalu"
            ~ "legendary".1 => expected "kusanagi", got "Thuận Thiên"
            ~ "legendary".2 => expected "durendal", got "Cura Si Manjakini"
          STRING
        end

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end

      describe 'with a non-matching Hash with Symbol keys' do
        let(:actual) do
          {
            yon:  4,
            go:   5,
            roku: 6
          }
        end
        let(:failure_message) do
          super() + diff_message + expected_diff
        end
        let(:expected_diff) do
          <<~STRING.strip
            - "european" => expected ["einhänder", "zweihänder", "spatha"]
            + :go => got 5
            - "japanese" => expected ["daito", "shoto", "tachi"]
            - "legendary" => expected ["excalibur", "kusanagi", "durendal"]
            + :roku => got 6
            + :yon => got 4
          STRING
        end

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end

      describe 'with a matching Hash with Symbol keys' do
        let(:actual) do
          {
            japanese:  %w[daito shoto tachi],
            european:  %w[einhänder zweihänder spatha],
            legendary: %w[excalibur kusanagi durendal]
          }
        end
        let(:failure_message) do
          super() + diff_message + expected_diff
        end
        let(:expected_diff) do
          <<~STRING.strip
            - "european" => expected ["einhänder", "zweihänder", "spatha"]
            + :european => got ["einhänder", "zweihänder", "spatha"]
            - "japanese" => expected ["daito", "shoto", "tachi"]
            + :japanese => got ["daito", "shoto", "tachi"]
            - "legendary" => expected ["excalibur", "kusanagi", "durendal"]
            + :legendary => got ["excalibur", "kusanagi", "durendal"]
          STRING
        end

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end
    end

    context 'when expected is a Hash with string keys and Hash values' do
      let(:expected) do
        {
          'english' => {
            'one'   => 1,
            'two'   => 2,
            'three' => 3
          },
          'spanish' => {
            'cuatro' => 4,
            'cinco'  => 5,
            'seis'   => 6
          },
          'chinese' => {
            'qi'  => 7,
            'ba'  => 8,
            'jiu' => 9
          }
        }
      end

      describe 'with nil' do
        let(:actual) { nil }

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end

      describe 'with an Object' do
        let(:actual) { Object.new }

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end

      describe 'with a String' do
        let(:actual) { 'The waves that flow and dye the land gold.' }

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end

      describe 'with an Array' do
        let(:actual) { %w[ichi ni san] }

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end

      describe 'with an empty Hash' do
        let(:actual) { {} }
        let(:failure_message) do
          super() + diff_message + expected_diff
        end
        let(:expected_diff) do
          <<~STRING.strip
            - "chinese" => expected #{format_expected(expected['chinese'])}
            - "english" => expected #{format_expected(expected['english'])}
            - "spanish" => expected #{format_expected(expected['spanish'])}
          STRING
        end

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end

      describe 'with a non-matching Hash with String keys' do
        let(:actual) do
          {
            'yon'  => 4,
            'go'   => 5,
            'roku' => 6
          }
        end
        let(:failure_message) do
          super() + diff_message + expected_diff
        end
        let(:expected_diff) do
          <<~STRING.strip
            - "chinese" => expected #{format_expected(expected['chinese'])}
            - "english" => expected #{format_expected(expected['english'])}
            + "go" => got 5
            + "roku" => got 6
            - "spanish" => expected #{format_expected(expected['spanish'])}
            + "yon" => got 4
          STRING
        end

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end

      describe 'with a Hash with matching String keys' do
        let(:actual) do
          {
            'english' => {
              'one'   => 1,
              'two'   => 2,
              'three' => 3
            },
            'spanish' => {
              'cuatro' => 4,
              'cinco'  => 5,
              'seis'   => 6
            },
            'chinese' => {
              'qi'  => 7,
              'ba'  => 8,
              'jiu' => 9
            }
          }
        end

        include_examples 'should pass with a positive expectation'

        include_examples 'should fail with a negative expectation'
      end

      describe 'with a Hash with String keys and missing values' do
        let(:actual) do
          {
            'english' => {
              'one'   => 1,
              'two'   => 2,
              'three' => 3
            },
            'spanish' => {
              'cuatro' => 4,
              'seis'   => 6
            }
          }
        end
        let(:failure_message) do
          super() + diff_message + expected_diff
        end
        let(:expected_diff) do
          <<~STRING.strip
            - "chinese" => expected #{format_expected(expected['chinese'])}
            - "spanish"."cinco" => expected 5
          STRING
        end

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end

      describe 'with a Hash with String keys and added values' do
        let(:actual) do
          {
            'english' => {
              'one'   => 1,
              'two'   => 2,
              'three' => 3
            },
            'spanish' => {
              'cuatro' => 4,
              'cinco'  => 5,
              'seis'   => 6
            },
            'chinese' => {
              'qi'  => 7,
              'ba'  => 8,
              'jiu' => 9,
              'shi' => 10
            },
            'french'  => {
              'onze'   => 11,
              'douze'  => 12,
              'trieze' => 13
            }
          }
        end
        let(:failure_message) do
          super() + diff_message + expected_diff
        end
        let(:expected_diff) do
          <<~STRING.strip
            + "chinese"."shi" => got 10
            + "french" => got #{format_expected(actual['french'])}
          STRING
        end

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end

      describe 'with a Hash with String keys and changed values' do
        let(:actual) do
          {
            'english' => {
              'one'   => 1,
              'two'   => 2,
              'three' => 3
            },
            'spanish' => {
              'cuatro' => 4,
              'cinco'  => 5,
              'seis'   => 'six'
            },
            'chinese' => 'Tonal pronunciation is important'
          }
        end
        let(:failure_message) do
          super() + diff_message + expected_diff
        end
        let(:expected_diff) do
          <<~STRING.strip
            ~ "chinese" => expected #{format_expected(expected['chinese'])}, got "Tonal pronunciation is important"
            ~ "spanish"."seis" => expected 6, got "six"
          STRING
        end

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end

      describe 'with a Hash with String keys and different keys and values' do
        let(:actual) do
          {
            'english' => {
              'one'   => 1,
              'two'   => 2,
              'three' => 3,
              'four'  => 4
            },
            'spanish' => {
              'cinco' => 5,
              'seis'  => 'six'
            },
            'french'  => {
              'sept' => 7,
              'huit' => 8,
              'neuf' => 9
            }
          }
        end
        let(:failure_message) do
          super() + diff_message + expected_diff
        end
        let(:expected_diff) do
          <<~STRING.strip
            - "chinese" => expected #{format_expected(expected['chinese'])}
            + "english"."four" => got 4
            + "french" => got #{format_expected(actual['french'])}
            - "spanish"."cuatro" => expected 4
            ~ "spanish"."seis" => expected 6, got "six"
          STRING
        end

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end

      describe 'with a non-matching Hash with Symbol keys' do
        let(:actual) do
          {
            yon:  4,
            go:   5,
            roku: 6
          }
        end
        let(:failure_message) do
          super() + diff_message + expected_diff
        end
        let(:expected_diff) do
          <<~STRING.strip
            - "chinese" => expected #{format_expected(expected['chinese'])}
            - "english" => expected #{format_expected(expected['english'])}
            + :go => got 5
            + :roku => got 6
            - "spanish" => expected #{format_expected(expected['spanish'])}
            + :yon => got 4
          STRING
        end

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end

      describe 'with a matching Hash with Symbol keys' do
        let(:actual) do
          {
            english: {
              one:   1,
              two:   2,
              three: 3
            },
            spanish: {
              cuatro: 4,
              cinco:  5,
              seis:   6
            },
            chinese: {
              qi:  7,
              ba:  8,
              jiu: 9
            }
          }
        end
        let(:failure_message) do
          super() + diff_message + expected_diff
        end
        let(:expected_diff) do
          <<~STRING.strip
            - "chinese" => expected #{format_expected(expected['chinese'])}
            + :chinese => got #{format_expected(actual[:chinese])}
            - "english" => expected #{format_expected(expected['english'])}
            + :english => got #{format_expected(actual[:english])}
            - "spanish" => expected #{format_expected(expected['spanish'])}
            + :spanish => got #{format_expected(actual[:spanish])}
          STRING
        end

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end
    end

    context 'when expected is a Hash with string keys and matcher values' do
      let(:expected) do
        {
          'id'     => an_instance_of(Integer),
          'title'  => an_instance_of(String),
          'author' => an_instance_of(Spec::Author)
        }
      end

      example_class 'Spec::Author', Struct.new(:name)

      describe 'with nil' do
        let(:actual) { nil }

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end

      describe 'with an Object' do
        let(:actual) { Object.new }

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end

      describe 'with a String' do
        let(:actual) { 'The waves that flow and dye the land gold.' }

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end

      describe 'with an Array' do
        let(:actual) { %w[ichi ni san] }

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end

      describe 'with an empty Hash' do
        let(:actual) { {} }
        let(:failure_message) do
          super() + diff_message + expected_diff
        end
        let(:expected_diff) do
          <<~STRING.strip
            - "author" => expected an instance of Spec::Author
            - "id" => expected an instance of Integer
            - "title" => expected an instance of String
          STRING
        end

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end

      describe 'with a non-matching Hash with String keys' do
        let(:actual) do
          {
            'yon'  => 4,
            'go'   => 5,
            'roku' => 6
          }
        end
        let(:failure_message) do
          super() + diff_message + expected_diff
        end
        let(:expected_diff) do
          <<~STRING.strip
            - "author" => expected an instance of Spec::Author
            + "go" => got 5
            - "id" => expected an instance of Integer
            + "roku" => got 6
            - "title" => expected an instance of String
            + "yon" => got 4
          STRING
        end

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end

      describe 'with a matching Hash with String keys' do
        let(:actual) do
          {
            'id'     => 1,
            'title'  => 'The Hobbit',
            'author' => Spec::Author.new('J.R.R. Tolkien')
          }
        end

        include_examples 'should pass with a positive expectation'

        include_examples 'should fail with a negative expectation'
      end

      describe 'with a non-matching Hash with Symbol keys' do
        let(:actual) do
          {
            yon:  4,
            go:   5,
            roku: 6
          }
        end
        let(:failure_message) do
          super() + diff_message + expected_diff
        end
        let(:expected_diff) do
          <<~STRING.strip
            - "author" => expected an instance of Spec::Author
            + :go => got 5
            - "id" => expected an instance of Integer
            + :roku => got 6
            - "title" => expected an instance of String
            + :yon => got 4
          STRING
        end

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end

      describe 'with a matching Hash with Symbol keys' do
        let(:actual) do
          {
            id:     1,
            title:  'The Hobbit',
            author: Spec::Author.new('J.R.R. Tolkien')
          }
        end
        let(:failure_message) do
          super() + diff_message + expected_diff
        end
        let(:expected_diff) do
          <<~STRING.strip
            - "author" => expected an instance of Spec::Author
            + :author => got #<struct Spec::Author name="J.R.R. Tolkien">
            - "id" => expected an instance of Integer
            + :id => got 1
            - "title" => expected an instance of String
            + :title => got "The Hobbit"
          STRING
        end

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end
    end

    context 'when expected is a Hash with string keys and mixed values' do
      let(:author) { Spec::Author.new('J.R.R. Tolkien') }
      let(:expected) do
        {
          'id'     => an_instance_of(Integer),
          'title'  => 'The Hobbit',
          'author' => author
        }
      end

      example_class 'Spec::Author', Struct.new(:name)

      describe 'with nil' do
        let(:actual) { nil }

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end

      describe 'with an Object' do
        let(:actual) { Object.new }

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end

      describe 'with a String' do
        let(:actual) { 'The waves that flow and dye the land gold.' }

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end

      describe 'with an Array' do
        let(:actual) { %w[ichi ni san] }

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end

      describe 'with an empty Hash' do
        let(:actual) { {} }
        let(:failure_message) do
          super() + diff_message + expected_diff
        end
        let(:expected_diff) do
          <<~STRING.strip
            - "author" => expected #<struct Spec::Author name="J.R.R. Tolkien">
            - "id" => expected an instance of Integer
            - "title" => expected "The Hobbit"
          STRING
        end

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end

      describe 'with a non-matching Hash with String keys' do
        let(:actual) do
          {
            'yon'  => 4,
            'go'   => 5,
            'roku' => 6
          }
        end
        let(:failure_message) do
          super() + diff_message + expected_diff
        end
        let(:expected_diff) do
          <<~STRING.strip
            - "author" => expected #<struct Spec::Author name="J.R.R. Tolkien">
            + "go" => got 5
            - "id" => expected an instance of Integer
            + "roku" => got 6
            - "title" => expected "The Hobbit"
            + "yon" => got 4
          STRING
        end

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end

      describe 'with a matching Hash with String keys' do
        let(:actual) do
          {
            'id'     => 1,
            'title'  => 'The Hobbit',
            'author' => author
          }
        end

        include_examples 'should pass with a positive expectation'

        include_examples 'should fail with a negative expectation'
      end

      describe 'with a non-matching Hash with Symbol keys' do
        let(:actual) do
          {
            yon:  4,
            go:   5,
            roku: 6
          }
        end
        let(:failure_message) do
          super() + diff_message + expected_diff
        end
        let(:expected_diff) do
          <<~STRING.strip
            - "author" => expected #<struct Spec::Author name="J.R.R. Tolkien">
            + :go => got 5
            - "id" => expected an instance of Integer
            + :roku => got 6
            - "title" => expected "The Hobbit"
            + :yon => got 4
          STRING
        end

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end

      describe 'with an matching Hash with Symbol keys' do
        let(:actual) do
          {
            id:     1,
            title:  'The Hobbit',
            author: author
          }
        end
        let(:failure_message) do
          super() + diff_message + expected_diff
        end
        let(:expected_diff) do
          <<~STRING.strip
            - "author" => expected #<struct Spec::Author name="J.R.R. Tolkien">
            + :author => got #<struct Spec::Author name="J.R.R. Tolkien">
            - "id" => expected an instance of Integer
            + :id => got 1
            - "title" => expected "The Hobbit"
            + :title => got "The Hobbit"
          STRING
        end

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end
    end

    context 'when expected is a Hash with symbol keys' do
      let(:expected) do
        {
          ichi: 1,
          ni:   2,
          san:  3
        }
      end

      describe 'with nil' do
        let(:actual) { nil }

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end

      describe 'with an Object' do
        let(:actual) { Object.new }

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end

      describe 'with a String' do
        let(:actual) { 'The waves that flow and dye the land gold.' }

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end

      describe 'with an Array' do
        let(:actual) { %w[ichi ni san] }

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end

      describe 'with an empty Hash' do
        let(:actual) { {} }
        let(:failure_message) do
          super() + diff_message + expected_diff
        end
        let(:expected_diff) do
          <<~STRING.strip
            - :ichi => expected 1
            - :ni => expected 2
            - :san => expected 3
          STRING
        end

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end

      describe 'with a non-matching Hash with String keys' do
        let(:actual) do
          {
            'yon'  => 4,
            'go'   => 5,
            'roku' => 6
          }
        end
        let(:failure_message) do
          super() + diff_message + expected_diff
        end
        let(:expected_diff) do
          <<~STRING.strip
            + "go" => got 5
            - :ichi => expected 1
            - :ni => expected 2
            + "roku" => got 6
            - :san => expected 3
            + "yon" => got 4
          STRING
        end

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end

      describe 'with a matching Hash with String keys' do
        let(:actual) do
          {
            'ichi' => 1,
            'ni'   => 2,
            'san'  => 3
          }
        end
        let(:failure_message) do
          super() + diff_message + expected_diff
        end
        let(:expected_diff) do
          <<~STRING.strip
            - :ichi => expected 1
            + "ichi" => got 1
            - :ni => expected 2
            + "ni" => got 2
            - :san => expected 3
            + "san" => got 3
          STRING
        end

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end

      describe 'with a non-matching Hash with Symbol keys' do
        let(:actual) do
          {
            yon:  4,
            go:   5,
            roku: 6
          }
        end
        let(:failure_message) do
          super() + diff_message + expected_diff
        end
        let(:expected_diff) do
          <<~STRING.strip
            + :go => got 5
            - :ichi => expected 1
            - :ni => expected 2
            + :roku => got 6
            - :san => expected 3
            + :yon => got 4
          STRING
        end

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end

      describe 'with a matching Hash with Symbol keys' do
        let(:actual) do
          {
            ichi: 1,
            ni:   2,
            san:  3
          }
        end

        include_examples 'should pass with a positive expectation'

        include_examples 'should fail with a negative expectation'
      end

      describe 'with a Hash with Symbol keys and missing values' do
        let(:actual) do
          {
            ichi: 1,
            san:  3
          }
        end
        let(:failure_message) do
          super() + diff_message + expected_diff
        end
        let(:expected_diff) do
          '- :ni => expected 2'
        end

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end

      describe 'with a Hash with Symbol keys and added values' do
        let(:actual) do
          {
            ichi: 1,
            ni:   2,
            san:  3,
            yon:  4
          }
        end
        let(:failure_message) do
          super() + diff_message + expected_diff
        end
        let(:expected_diff) do
          '+ :yon => got 4'
        end

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end

      describe 'with a Hash with Symbol keys and changed values' do
        let(:actual) do
          {
            ichi: 1,
            ni:   2,
            san:  'three'
          }
        end
        let(:failure_message) do
          super() + diff_message + expected_diff
        end
        let(:expected_diff) do
          '~ :san => expected 3, got "three"'
        end

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end

      describe 'with a Hash with Symbol keys and different keys and values' do
        let(:actual) do
          {
            ichi: 1,
            san:  'three',
            yon:  4,
            go:   5,
            roku: 6
          }
        end
        let(:failure_message) do
          super() + diff_message + expected_diff
        end
        let(:expected_diff) do
          <<~STRING.strip
            + :go => got 5
            - :ni => expected 2
            + :roku => got 6
            ~ :san => expected 3, got "three"
            + :yon => got 4
          STRING
        end

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end
    end

    context 'when expected is a Hash with integer keys' do
      let(:expected) do
        {
          1 => 'one',
          2 => 'two',
          3 => 'three'
        }
      end

      describe 'with nil' do
        let(:actual) { nil }

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end

      describe 'with an Object' do
        let(:actual) { Object.new }

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end

      describe 'with a String' do
        let(:actual) { 'The waves that flow and dye the land gold.' }

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end

      describe 'with an Array' do
        let(:actual) { %w[ichi ni san] }

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end

      describe 'with an empty Hash' do
        let(:actual) { {} }
        let(:failure_message) do
          super() + diff_message + expected_diff
        end
        let(:expected_diff) do
          <<~STRING.strip
            - 1 => expected "one"
            - 2 => expected "two"
            - 3 => expected "three"
          STRING
        end

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end

      describe 'with an non-matching Hash' do
        let(:actual) do
          {
            4 => 'four',
            5 => 'five',
            6 => 'six'
          }
        end
        let(:failure_message) do
          super() + diff_message + expected_diff
        end
        let(:expected_diff) do
          <<~STRING.strip
            - 1 => expected "one"
            - 2 => expected "two"
            - 3 => expected "three"
            + 4 => got "four"
            + 5 => got "five"
            + 6 => got "six"
          STRING
        end

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end

      describe 'with an matching Hash' do
        let(:actual) do
          {
            1 => 'one',
            2 => 'two',
            3 => 'three'
          }
        end

        include_examples 'should pass with a positive expectation'

        include_examples 'should fail with a negative expectation'
      end

      describe 'with a Hash with missing values' do
        let(:actual) do
          {
            1 => 'one',
            3 => 'three'
          }
        end
        let(:failure_message) do
          super() + diff_message + expected_diff
        end
        let(:expected_diff) do
          '- 2 => expected "two"'
        end

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end

      describe 'with a Hash with added values' do
        let(:actual) do
          {
            1 => 'one',
            2 => 'two',
            3 => 'three',
            5 => 'five'
          }
        end
        let(:failure_message) do
          super() + diff_message + expected_diff
        end
        let(:expected_diff) do
          '+ 5 => got "five"'
        end

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end

      describe 'with a Hash with changed values' do
        let(:actual) do
          {
            1 => 'one',
            2 => 2,
            3 => 'three'
          }
        end
        let(:failure_message) do
          super() + diff_message + expected_diff
        end
        let(:expected_diff) do
          '~ 2 => expected "two", got 2'
        end

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end

      describe 'with a Hash with different keys and values' do
        let(:actual) do
          {
            1 => 'one',
            2 => 2,
            5 => 'five'
          }
        end
        let(:failure_message) do
          super() + diff_message + expected_diff
        end
        let(:expected_diff) do
          <<~STRING.strip
            ~ 2 => expected "two", got 2
            - 3 => expected "three"
            + 5 => got "five"
          STRING
        end

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end
    end

    context 'when expected is a Hash with mixed string and symbol keys' do
      let(:expected) do
        {
          id:           1,
          value:        'some value',
          'metadata' => '{"key": "value"}'
        }
      end

      describe 'with nil' do
        let(:actual) { nil }

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end

      describe 'with an Object' do
        let(:actual) { Object.new }

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end

      describe 'with a String' do
        let(:actual) { 'The waves that flow and dye the land gold.' }

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end

      describe 'with an Array' do
        let(:actual) { %w[ichi ni san] }

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end

      describe 'with an empty Hash' do
        let(:actual) { {} }
        let(:failure_message) do
          super() + diff_message + expected_diff
        end
        let(:expected_diff) do
          <<~STRING.strip
            - :id => expected 1
            - "metadata" => expected "{\\"key\\": \\"value\\"}"
            - :value => expected "some value"
          STRING
        end

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end

      describe 'with a non-matching Hash with String keys' do
        let(:actual) do
          {
            'yon'  => 4,
            'go'   => 5,
            'roku' => 6
          }
        end
        let(:failure_message) do
          super() + diff_message + expected_diff
        end
        let(:expected_diff) do
          <<~STRING.strip
            + "go" => got 5
            - :id => expected 1
            - "metadata" => expected "{\\"key\\": \\"value\\"}"
            + "roku" => got 6
            - :value => expected "some value"
            + "yon" => got 4
          STRING
        end

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end

      describe 'with a matching Hash with String keys' do
        let(:actual) do
          {
            'id'       => 1,
            'value'    => 'some value',
            'metadata' => '{"key": "value"}'
          }
        end
        let(:failure_message) do
          super() + diff_message + expected_diff
        end
        let(:expected_diff) do
          <<~STRING.strip
            - :id => expected 1
            + "id" => got 1
            - :value => expected "some value"
            + "value" => got "some value"
          STRING
        end

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end

      describe 'with a non-matching Hash with Symbol keys' do
        let(:actual) do
          {
            yon:  4,
            go:   5,
            roku: 6
          }
        end
        let(:failure_message) do
          super() + diff_message + expected_diff
        end
        let(:expected_diff) do
          <<~STRING.strip
            + :go => got 5
            - :id => expected 1
            - "metadata" => expected "{\\"key\\": \\"value\\"}"
            + :roku => got 6
            - :value => expected "some value"
            + :yon => got 4
          STRING
        end

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end

      describe 'with a matching Hash with Symbol keys' do
        let(:actual) do
          {
            id:       1,
            value:    'some value',
            metadata: '{"key": "value"}'
          }
        end
        let(:failure_message) do
          super() + diff_message + expected_diff
        end
        let(:expected_diff) do
          <<~STRING.strip
            - "metadata" => expected "{\\"key\\": \\"value\\"}"
            + :metadata => got "{\\"key\\": \\"value\\"}"
          STRING
        end

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end

      describe 'with a matching Hash' do
        let(:actual) do
          {
            id:           1,
            value:        'some value',
            'metadata' => '{"key": "value"}'
          }
        end

        include_examples 'should pass with a positive expectation'

        include_examples 'should fail with a negative expectation'
      end
    end

    context 'when expected is a deeply nested data structure' do
      let(:expected) do
        {
          status: 200,
          body:   {
            'errors' => [],
            'order'  => {
              'id'       => an_instance_of(Integer),
              'user'     => {
                'id'    => an_instance_of(Integer),
                'name'  => 'Alan Bradley',
                'email' => 'alan.bradley@example.com'
              },
              'items'    => [
                {
                  'id'        => 100,
                  'name'      => 'Hamburger Combo Meal',
                  'total'     => '9.99',
                  'modifiers' => [
                    {
                      'id'        => 0,
                      'name'      => 'Big Beef Burger',
                      'modifiers' => [
                        {
                          'id'   => 10,
                          'name' => 'Medium-Rare'
                        },
                        {
                          'id'    => 11,
                          'name'  => 'Grilled Onions',
                          'total' => '0.99'
                        },
                        {
                          'id'        => 12,
                          'name'      => 'Guacamole',
                          'total'     => '1.99',
                          'modifiers' => [
                            {
                              'id'   => 20,
                              'name' => 'Spicy'
                            }
                          ]
                        }
                      ]
                    },
                    {
                      'id'        => 1,
                      'name'      => 'Curly Fries',
                      'modifiers' => [
                        {
                          'id'   => 14,
                          'name' => 'Extra Crispy'
                        }
                      ]
                    },
                    {
                      'id'   => 2,
                      'name' => 'Large Soda'
                    }
                  ]
                },
                {
                  'id'        => 101,
                  'name'      => 'Hot Dog Combo Meal',
                  'total'     => '7.99',
                  'modifiers' => [
                    {
                      'id'        => 3,
                      'name'      => 'King Hot Dog',
                      'modifiers' => [
                        {
                          'id'    => 15,
                          'name'  => 'Chili',
                          'total' => '1.49'
                        }
                      ]
                    },
                    {
                      'id'        => 4,
                      'name'      => 'Vanilla Shake',
                      'modifiers' => [
                        {
                          'id'    => 16,
                          'name'  => 'Cookie Crumbles',
                          'total' => '0.99'
                        }
                      ]
                    }
                  ]
                },
                {
                  'id'    => 1_001,
                  'name'  => 'Member Discount',
                  'total' => BigDecimal('-5.0')
                }
              ],
              'payments' => [
                {
                  'id'     => an_instance_of(Integer),
                  'uuid'   => an_instance_of(String),
                  'type'   => :cash,
                  'amount' => '20.0'
                },
                {
                  'id'     => an_instance_of(Integer),
                  'uuid'   => an_instance_of(String),
                  'type'   => :credit,
                  'amount' => '7.45'
                }
              ]
            }
          }
        }
      end
      let(:matching_data) do
        SleepingKingStudios::Tools::Toolbelt
          .instance
          .hsh
          .deep_dup(expected)
          .tap do |hsh|
            order = hsh[:body]['order']

            order['id'] = 0
            order['payments'][0]['id'] = 1
            order['payments'][1]['id'] = 2
            order['user']['id'] = 3

            order['payments'][0]['uuid'] =
              'b169e8a8-c357-4bbb-aa35-dc1758a3ec32'
            order['payments'][1]['uuid'] =
              '9e36d711-307b-43dc-adf7-b33485ea86fa'
          end
      end

      describe 'with nil' do
        let(:actual) { nil }

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end

      describe 'with an Object' do
        let(:actual) { Object.new }

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end

      describe 'with a String' do
        let(:actual) { 'The waves that flow and dye the land gold.' }

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end

      describe 'with an Array' do
        let(:actual) { %w[ichi ni san] }

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end

      describe 'with an empty Hash' do
        let(:actual) { {} }
        let(:failure_message) do
          super() + diff_message + expected_diff
        end
        let(:expected_diff) do
          <<~STRING.strip
            - :body => expected #{format_expected(expected[:body])}
            - :status => expected 200
          STRING
        end

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end

      describe 'with a matching Hash' do
        let(:actual) { matching_data }

        include_examples 'should pass with a positive expectation'

        include_examples 'should fail with a negative expectation'
      end

      describe 'with a missing top-level key' do
        let(:actual) { matching_data.tap { |hsh| hsh.delete :status } }
        let(:failure_message) do
          super() + diff_message + expected_diff
        end
        let(:expected_diff) do
          '- :status => expected 200'
        end

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end

      describe 'with a missing nested key' do
        let(:actual) do
          matching_data.tap do |hsh|
            modifier = hsh.dig(:body, 'order', 'items', 0, 'modifiers', 1)
            modifier.delete 'name'
          end
        end
        let(:failure_message) do
          super() + diff_message + expected_diff
        end
        let(:expected_diff) do
          '- :body."order"."items".0."modifiers".1."name" => expected ' \
            '"Curly Fries"'
        end

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end

      describe 'with a missing keys and items' do
        let(:actual) do
          matching_data.tap do |hsh|
            hsh.delete :status

            modifier = hsh.dig(:body, 'order', 'items', 0, 'modifiers', 1)
            modifier.delete 'name'

            items = hsh.dig(:body, 'order', 'items')
            items.delete_at(1)
          end
        end
        let(:failure_message) do
          super() + diff_message + expected_diff
        end
        let(:expected_diff) do
          <<~STRING.strip
            - :body."order"."items".0."modifiers".1."name" => expected "Curly Fries"
            - :body."order"."items".1 => expected #{format_expected(expected.dig :body, 'order', 'items', 1)}
            - :status => expected 200
          STRING
        end

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end

      describe 'with an added top-level value' do
        let(:actual) do
          matching_data.merge(signature: 'rQjuNgOL4g6sXikyeM4i4Q')
        end
        let(:failure_message) do
          super() + diff_message + expected_diff
        end
        let(:expected_diff) do
          '+ :signature => got "rQjuNgOL4g6sXikyeM4i4Q"'
        end

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end

      describe 'with an added nested value' do
        let(:actual) do
          matching_data.tap do |hsh|
            modifier = hsh.dig(:body, 'order', 'items', 0, 'modifiers', 2)
            modifier['notes'] = 'Extra ice.'
          end
        end
        let(:failure_message) do
          super() + diff_message + expected_diff
        end
        let(:expected_diff) do
          '+ :body."order"."items".0."modifiers".2."notes" => got "Extra ice."'
        end

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end

      describe 'with added values and items' do
        let(:actual) do
          matching_data.tap do |hsh|
            hsh[:signature] = 'rQjuNgOL4g6sXikyeM4i4Q'

            modifiers = hsh.dig(:body, 'order', 'items', 0, 'modifiers')

            modifiers[2]['notes'] = 'Extra ice.'

            modifiers << {
              'id'   => 5,
              'name' => 'Special Brownie'
            }
          end
        end
        let(:failure_message) do
          super() + diff_message + expected_diff
        end
        let(:expected_diff) do
          modifier = actual.dig(:body, 'order', 'items', 0, 'modifiers', 3)

          <<~STRING.strip
            + :body."order"."items".0."modifiers".2."notes" => got "Extra ice."
            + :body."order"."items".0."modifiers".3 => got #{format_expected(modifier)}
            + :signature => got "rQjuNgOL4g6sXikyeM4i4Q"
          STRING
        end

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end

      describe 'with a changed top-level value' do
        let(:actual) { matching_data.merge(status: 418) }
        let(:failure_message) do
          super() + diff_message + expected_diff
        end
        let(:expected_diff) do
          '~ :status => expected 200, got 418'
        end

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end

      describe 'with a changed nested value' do
        let(:actual) do
          matching_data.tap do |hsh|
            modifier = hsh.dig(:body, 'order', 'items', 0, 'modifiers', 2)
            modifier['name'] = 'Chocolate Shake'
          end
        end
        let(:failure_message) do
          super() + diff_message + expected_diff
        end
        let(:expected_diff) do
          '~ :body."order"."items".0."modifiers".2."name" => expected ' \
            '"Large Soda", got "Chocolate Shake"'
        end

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end

      describe 'with changed nested values and items' do
        let(:actual) do
          matching_data.tap do |hsh|
            hsh[:status] = 418

            modifier = hsh.dig(:body, 'order', 'items', 0, 'modifiers', 2)
            modifier['name'] = 'Chocolate Shake'

            modifiers =
              hsh.dig(:body, 'order', 'items', 0, 'modifiers', 0, 'modifiers')
            modifiers[1] = { 'id' => 17, 'name' => 'Turkey Bacon' }
          end
        end
        let(:failure_message) do
          super() + diff_message + expected_diff
        end
        let(:expected_diff) do
          <<~STRING.strip
            ~ :body."order"."items".0."modifiers".0."modifiers".1."id" => expected 11, got 17
            ~ :body."order"."items".0."modifiers".0."modifiers".1."name" => expected "Grilled Onions", got "Turkey Bacon"
            - :body."order"."items".0."modifiers".0."modifiers".1."total" => expected "0.99"
            ~ :body."order"."items".0."modifiers".2."name" => expected "Large Soda", got "Chocolate Shake"
            ~ :status => expected 200, got 418
          STRING
        end

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end

      describe 'with different values and items' do
        let(:actual) do
          matching_data.tap do |hsh|
            hsh[:signature] = 'rQjuNgOL4g6sXikyeM4i4Q'
            hsh[:status]    = 418

            modifier = hsh.dig(:body, 'order', 'items', 0, 'modifiers', 1)
            modifier.delete 'name'

            items = hsh.dig(:body, 'order', 'items')
            items.delete_at(1)

            modifier = hsh.dig(:body, 'order', 'items', 0, 'modifiers', 2)
            modifier['name'] = 'Chocolate Shake'
            modifier['notes'] = 'Extra whipped cream'

            modifiers =
              hsh.dig(:body, 'order', 'items', 0, 'modifiers', 0, 'modifiers')
            modifiers[1] = { 'id' => 17, 'name' => 'Turkey Bacon' }

            modifiers = hsh.dig(:body, 'order', 'items', 0, 'modifiers')
            modifiers << {
              'id'   => 5,
              'name' => 'Special Brownie'
            }
          end
        end
        let(:failure_message) do
          super() + diff_message + expected_diff
        end
        let(:expected_diff) do
          modifier = actual.dig(:body, 'order', 'items', 0, 'modifiers', 3)

          <<~STRING.strip
            ~ :body."order"."items".0."modifiers".0."modifiers".1."id" => expected 11, got 17
            ~ :body."order"."items".0."modifiers".0."modifiers".1."name" => expected "Grilled Onions", got "Turkey Bacon"
            - :body."order"."items".0."modifiers".0."modifiers".1."total" => expected "0.99"
            - :body."order"."items".0."modifiers".1."name" => expected "Curly Fries"
            ~ :body."order"."items".0."modifiers".2."name" => expected "Large Soda", got "Chocolate Shake"
            + :body."order"."items".0."modifiers".2."notes" => got "Extra whipped cream"
            + :body."order"."items".0."modifiers".3 => got #{format_expected(modifier)}
            - :body."order"."items".1 => expected #{format_expected(expected.dig :body, 'order', 'items', 1)}
            + :signature => got "rQjuNgOL4g6sXikyeM4i4Q"
            ~ :status => expected 200, got 418
          STRING
        end

        include_examples 'should fail with a positive expectation'

        include_examples 'should pass with a negative expectation'
      end
    end
  end
end
