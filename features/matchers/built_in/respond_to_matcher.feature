# features/matchers/built_in/respond_to_matcher.feature

Feature: `respond_to` matcher
  Use the respond_to matcher to specify details of an object's interface.  In
  its most basic form:

  ```ruby
  expect(instance).to respond_to(:method_name)
  ```

  RSpec::SleepingKingStudios extends the built-in RSpec `respond_to` matcher
  with several new features. First, mirroring the core Ruby `#respond_to`
  method, you can allow the matcher to match protected or private methods:

  ```ruby
  expect(instance).to respond_to(:method_name, true)
  ```

  As with the built-in RSpec `respond_to` matcher, you can also specify the
  number of arguments using the `with` method. RSpec::SleepingKingStudios
  extends this functionality, allowing you to specify an argument count either
  as a number or as a range to indicate a mix of required and optional
  arguments.

  On Ruby 2.0 and above, you can additionally specify one or more keywords that
  the method must support. On Ruby 2.1 and above, the matcher also checks for
  the presence of required keywords:

  ```ruby
  expect(instance).to respond_to(:method_name).with(1).argument
  expect(instance).to respond_to(:method_name).with(1..2).arguments

  expect(instance).to respond_to(:method_name).with(:headers, :body, :cookies)
  expect(instance).to respond_to(:method_name).with(3, :options, :http_options).arguments
  ```

  Scenario: basic usage
    Given a file named "respond_to_matcher_spec.rb" with:
      """ruby
        require 'rspec/sleeping_king_studios/matchers/built_in/respond_to'

        class String
          private

          def secret_method; end
        end

        RSpec.describe String do
          let(:instance) { 'a String' }

          # Passing expectations.
          it { expect(instance).to respond_to(:length) }
          it { expect(instance).not_to respond_to(:flatten) }
          it { expect(instance).not_to respond_to(:secret_method) }
          it { expect(instance).to respond_to(:secret_method, true) }

          # Failing expectations.
          it { expect(instance).not_to respond_to(:length) }
          it { expect(instance).to respond_to(:flatten) }
          it { expect(instance).to respond_to(:secret_method) }
          it { expect(instance).not_to respond_to(:secret_method, true) }
        end # describe
      """
    When I run `rspec respond_to_matcher_spec.rb`
    Then the output should contain "8 examples, 4 failures"
    Then the output should contain:
      """
           Failure/Error: it { expect(instance).not_to respond_to(:length) }
             expected "a String" not to respond to :length
      """
    Then the output should contain:
      """
           Failure/Error: it { expect(instance).to respond_to(:flatten) }
             expected "a String" to respond to :flatten
      """
    Then the output should contain:
      """
           Failure/Error: it { expect(instance).to respond_to(:secret_method) }
             expected "a String" to respond to :secret_method
      """
    Then the output should contain:
      """
           Failure/Error: it { expect(instance).not_to respond_to(:secret_method, true) }
             expected "a String" not to respond to :secret_method
      """

  Scenario: specifying arguments and keywords
    Given a file named "respond_to_matcher_spec.rb" with:
      """ruby
        require 'rspec/sleeping_king_studios/matchers/built_in/respond_to'

        class MyObject
          def my_method(foo, bar = nil, baz = nil, wibble: 'wibble', wobble: 'wobble'); end

          def inspect
            'my object'
          end # method inspect
        end # class

        RSpec.describe String do
          let(:instance) { MyObject.new }

          # Passing expectations.
          it { expect(instance).not_to respond_to(:my_method).with(0).arguments }
          it { expect(instance).to respond_to(:my_method).with(1).argument }
          it { expect(instance).to respond_to(:my_method).with(3).arguments }
          it { expect(instance).not_to respond_to(:my_method).with(5).arguments }
          it { expect(instance).not_to respond_to(:my_method).with(0..5).arguments }
          it { expect(instance).to respond_to(:my_method).with(1..3).arguments }

          describe 'keywords' do
            it { expect(instance).to respond_to(:my_method).with(:wibble, :wobble) }

            it { expect(instance).not_to respond_to(:my_method).with(:up, :down) }

            it { expect(instance).not_to respond_to(:my_method).with(:wobble, :up) }

            it { expect(instance).to respond_to(:my_method).with(1..3, :wibble, :wobble) }

            it { expect(instance).not_to respond_to(:my_method).with(0..5, :wibble, :wobble) }

            it { expect(instance).not_to respond_to(:my_method).with(1..3, :up, :down) }

            it { expect(instance).not_to respond_to(:my_method).with(0..5, :up, :down) }
          end # describe

          # Failing expectations.
          it { expect(instance).to respond_to(:my_method).with(0).arguments }
          it { expect(instance).not_to respond_to(:my_method).with(1).argument }
          it { expect(instance).not_to respond_to(:my_method).with(3).arguments }
          it { expect(instance).to respond_to(:my_method).with(5).arguments }
          it { expect(instance).to respond_to(:my_method).with(0..5).arguments }
          it { expect(instance).not_to respond_to(:my_method).with(1..3).arguments }

          describe 'keywords' do
            it { expect(instance).not_to respond_to(:my_method).with(:wibble, :wobble) }

            it { expect(instance).to respond_to(:my_method).with(:up, :down) }

            it { expect(instance).to respond_to(:my_method).with(:wobble, :up) }

            it { expect(instance).not_to respond_to(:my_method).with(1..3, :wibble, :wobble) }

            it { expect(instance).to respond_to(:my_method).with(0..5, :wibble, :wobble) }

            it { expect(instance).to respond_to(:my_method).with(1..3, :up, :down) }

            it { expect(instance).to respond_to(:my_method).with(0..5, :up, :down) }
          end # describe
        end # describe
      """
    When I run `rspec respond_to_matcher_spec.rb`
    Then the output should contain "26 examples, 13 failures"
    Then the output should contain:
      """
           Failure/Error: it { expect(instance).to respond_to(:my_method).with(0).arguments }
             expected my object to respond to :my_method with arguments:
               expected at least 1 arguments, but received 0
      """
    Then the output should contain:
      """
           Failure/Error: it { expect(instance).not_to respond_to(:my_method).with(1).argument }
             expected my object not to respond to :my_method with 1 argument
      """
    Then the output should contain:
      """
           Failure/Error: it { expect(instance).not_to respond_to(:my_method).with(3).arguments }
             expected my object not to respond to :my_method with 3 arguments
      """
    Then the output should contain:
      """
           Failure/Error: it { expect(instance).to respond_to(:my_method).with(5).arguments }
             expected my object to respond to :my_method with arguments:
               expected at most 3 arguments, but received 5
      """
    Then the output should contain:
      """
           Failure/Error: it { expect(instance).to respond_to(:my_method).with(0..5).arguments }
             expected my object to respond to :my_method with arguments:
               expected at least 1 arguments, but received 0
      """
    Then the output should contain:
      """
           Failure/Error: it { expect(instance).not_to respond_to(:my_method).with(1..3).arguments }
             expected my object not to respond to :my_method with 1..3 arguments
      """
    Then the output should contain:
      """
           Failure/Error: it { expect(instance).not_to respond_to(:my_method).with(:wibble, :wobble) }
             expected my object not to respond to :my_method with keywords :wibble and :wobble
      """
    Then the output should contain:
      """
           Failure/Error: it { expect(instance).to respond_to(:my_method).with(:up, :down) }
             expected my object to respond to :my_method with arguments:
               unexpected keywords :up and :down
      """
    Then the output should contain:
      """
           Failure/Error: it { expect(instance).to respond_to(:my_method).with(:wobble, :up) }
             expected my object to respond to :my_method with arguments:
               unexpected keyword :up
      """
    Then the output should contain:
      """
           Failure/Error: it { expect(instance).not_to respond_to(:my_method).with(1..3, :wibble, :wobble) }
             expected my object not to respond to :my_method with 1..3 arguments and keywords :wibble and :wobble
      """
    Then the output should contain:
      """
           Failure/Error: it { expect(instance).to respond_to(:my_method).with(0..5, :wibble, :wobble) }
             expected my object to respond to :my_method with arguments:
               expected at least 1 arguments, but received 0
      """
    Then the output should contain:
      """
           Failure/Error: it { expect(instance).to respond_to(:my_method).with(1..3, :up, :down) }
             expected my object to respond to :my_method with arguments:
               unexpected keywords :up and :down
      """
    Then the output should contain:
      """
           Failure/Error: it { expect(instance).to respond_to(:my_method).with(0..5, :up, :down) }
             expected my object to respond to :my_method with arguments:
               expected at least 1 arguments, but received 0
      """

  Scenario: specifying required keywords
    Given Ruby 2.2 or greater
    Given a file named "respond_to_matcher_spec.rb" with:
      """ruby
        require 'rspec/sleeping_king_studios/matchers/built_in/respond_to'

        class MyObject
          def my_method(foo, bar = nil, baz = nil, wibble: 'wibble', wobble: 'wobble', greetings:); end

          def inspect
            'my object'
          end # method inspect
        end # class

        RSpec.describe MyObject do
          let(:instance) { MyObject.new }

          # Passing expectations.
          it { expect(instance).to respond_to(:my_method).with(1..3, :wibble, :wobble, :greetings) }
          it { expect(instance).not_to respond_to(:my_method).with(1..3).arguments }
          it { expect(instance).not_to respond_to(:my_method).with(1..3, :wibble, :wobble) }

          # Failing expectations.
          it { expect(instance).not_to respond_to(:my_method).with(1..3, :wibble, :wobble, :greetings) }
          it { expect(instance).to respond_to(:my_method).with(1..3).arguments }
          it { expect(instance).to respond_to(:my_method).with(1..3, :wibble, :wobble) }
        end # describe
      """
    When I run `rspec respond_to_matcher_spec.rb`
    Then the output should contain "6 examples, 3 failures"
    Then the output should contain:
      """
           Failure/Error: it { expect(instance).to respond_to(:my_method).with(1..3).arguments }
             expected my object to respond to :my_method with arguments:
               missing keyword :greetings
      """
    Then the output should contain:
      """
           Failure/Error: it { expect(instance).to respond_to(:my_method).with(1..3, :wibble, :wobble) }
             expected my object to respond to :my_method with arguments:
               missing keyword :greetings
      """
    Then the output should contain:
      """
           Failure/Error: it { expect(instance).not_to respond_to(:my_method).with(1..3, :wibble, :wobble, :greetings) }
             expected my object not to respond to :my_method with 1..3 arguments and keywords :wibble, :wobble, and :greetings
      """
