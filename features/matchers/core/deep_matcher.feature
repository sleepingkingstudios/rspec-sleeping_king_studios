# frozen_string_literals: true

Feature: `deep_match` matcher
  Use the `deep_match` matcher to build a detailed expectation for an object or
  data structure.

  ```ruby
  book = Book.new(title: 'The Hobbit', author: 'J.R.R. Tolkien')

  expect(book.attributes).to deep_match(
    'id'     => an_instance_of(Integer),
    'title'  => 'The Hobbit',
    'author' => 'J.R.R. Tolkien'
  )
  ```

  If the expected value is a matcher (such as the 'id' expectation above), then
  the actual value is matched against the matcher. If the expected value is a
  basic value, such as a String or Integer, the values are compared via an
  equality comparison.

  If the expected value is a collection, such as an Array or Hash, then the
  items in the Array or the keys and values of the Hash are recursively deep
  matched. This allows for comparing the contents of deeply nested data
  structures, and providing a specific diff when the expectation is not met.

  ```ruby
  expect(json).to deep_match(
    status: 200,
    body: {
      user_uuid: 'a2d0941d-bc70-4ada-a5c7-4e5e19a7d926',
      order: {
        id: an_instance_of(Integer),
        items: [
          { name: 'Red Shirt' },
          { name: 'Blue Blouse' },
          { name: 'Green Shoes' }
        ]
      }
    }
  )
  ```

  Scenario: basic usage
    Given a file named "deep_matcher/basic_spec.rb" with:
      """ruby
        require 'rspec/sleeping_king_studios/matchers/core/deep_match'

        RSpec.describe 'Book' do
          let(:book) do
            {
              'id'     => 0,
              'title'  => 'The Hobbit',
              'author' => 'J.R.R. Tolkien'
            }
          end
          let(:expected) do
            {
              'author' => 'J.R.R. Tolkien',
              'id'     => an_instance_of(Integer),
              'title'  => 'The Hobbit'
            }
          end

          it { expect(book).to deep_match(expected) }

          describe 'when a key is added' do
            let(:book) do
              {
                'id'         => 0,
                'title'      => 'The Hobbit',
                'author'     => 'J.R.R. Tolkien',
                'page_count' => 300
              }
            end

            it 'should list the added key and actual value' do
              expect(book).to deep_match(expected)
            end
          end

          describe 'when a key is missing' do
            let(:book) do
              {
                'id'    => 0,
                'title' => 'The Hobbit'
              }
            end

            it 'should list the missing key and expected value' do
              expect(book).to deep_match(expected)
            end
          end

          describe 'when a value is changed' do
            let(:book) do
              {
                'id'     => 0,
                'title'  => 'The Fellowship of the Ring',
                'author' => 'J.R.R. Tolkien'
              }
            end

            it 'should list the changed key and expected and actual values' do
              expect(book).to deep_match(expected)
            end
          end

          describe 'when there are many differences' do
            let(:book) do
              {
                'id'         => 0,
                'title'      => 'The Fellowship of the Ring',
                'page_count' => 300
              }
            end

            it 'should list the changed key and expected and actual values' do
              expect(book).to deep_match(expected)
            end
          end
        end
      """
    When I run `rspec deep_matcher/basic_spec.rb`
    Then the output should contain "5 examples, 4 failures"
    Then the output should contain:
      """
           Failure/Error: expect(book).to deep_match(expected)

             expected: == {"author"=>"J.R.R. Tolkien", "id"=>an instance of Integer, "title"=>"The Hobbit"}
                  got:    {"id"=>0, "title"=>"The Hobbit", "author"=>"J.R.R. Tolkien", "page_count"=>300}

             (compared using Hashdiff)

             Diff:
             + "page_count" => got 300
      """
    Then the output should contain:
      """
           Failure/Error: expect(book).to deep_match(expected)

             expected: == {"author"=>"J.R.R. Tolkien", "id"=>an instance of Integer, "title"=>"The Hobbit"}
                  got:    {"id"=>0, "title"=>"The Hobbit"}

             (compared using Hashdiff)

             Diff:
             - "author" => expected "J.R.R. Tolkien"
      """
    Then the output should contain:
      """
           Failure/Error: expect(book).to deep_match(expected)

             expected: == {"author"=>"J.R.R. Tolkien", "id"=>an instance of Integer, "title"=>"The Hobbit"}
                  got:    {"id"=>0, "title"=>"The Fellowship of the Ring", "author"=>"J.R.R. Tolkien"}

             (compared using Hashdiff)

             Diff:
             ~ "title" => expected "The Hobbit", got "The Fellowship of the Ring"
      """
    Then the output should contain:
      """
           Failure/Error: expect(book).to deep_match(expected)

             expected: == {"author"=>"J.R.R. Tolkien", "id"=>an instance of Integer, "title"=>"The Hobbit"}
                  got:    {"id"=>0, "title"=>"The Fellowship of the Ring", "page_count"=>300}

             (compared using Hashdiff)

             Diff:
             - "author" => expected "J.R.R. Tolkien"
             + "page_count" => got 300
             ~ "title" => expected "The Hobbit", got "The Fellowship of the Ring"
      """

  Scenario: matching deeply nested data
    Given a file named "deep_matcher/nested_spec.rb" with:
      """ruby
        require 'rspec/sleeping_king_studios/matchers/core/deep_match'

        RSpec.describe "response" do
          let(:expected) do
            {
              'body'   => {
                'lights' => {
                  'count'  => an_instance_of(Integer),
                  'format' => 'There are %i lights!'
                }
              },
              'status' => 200
            }
          end
          let(:response) do
            {
              'status' => 500,
              'errors' => ['Too many lights!'],
              'body'   => {
                'lights' => {
                  'count' => 5
                }
              }
            }
          end

          it { expect(response).to deep_match(expected) }
        end
      """
    When I run `rspec deep_matcher/nested_spec.rb`
    Then the output should contain "1 example, 1 failure"
    Then the output should contain:
      """
           Failure/Error: it { expect(response).to deep_match(expected) }

             expected: == {"body"=>{"lights"=>{"count"=>an instance of Integer, "format"=>"There are %i lights!"}}, "status"=>200}
                  got:    {"status"=>500, "errors"=>["Too many lights!"], "body"=>{"lights"=>{"count"=>5}}}

             (compared using Hashdiff)

             Diff:
             - "body"."lights"."format" => expected "There are %i lights!"
             + "errors" => got ["Too many lights!"]
             ~ "status" => expected 200, got 500
      """
