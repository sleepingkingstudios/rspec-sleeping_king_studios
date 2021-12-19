# features/matchers/core/delegate_method_matcher.feature

Feature: `delegate_method` matcher
  Use the `delegate_method` matcher to specify that the actual object forwards
  the specified method to the specified target. For the matcher to pass, both
  the actual object and the target object must respond to :foo, and calling #foo
  on the actual object must call #foo on the target.

  ```ruby
  expect(instance).to delegate_method(:foo).to(target)
  ```

  You can specify that the target must be passed a given set of arguments,
  keywords, and/or a block:

  ```ruby
  expect(instance).to delegate_method(:foo).to(target).with_arguments(:ichi, :ni, :san)
  expect(instance).to delegate_method(:foo).to(target).with_keywords(:foo => 'foo', :bar => 'bar')
  expect(instance).to delegate_method(:foo).to(target).with_a_block
  ```

  Finally, you can specify that the actual method returns a specified value. If
  you specify one value, the method is called once and must return the value.
  If you specify more than one value, the method is called one time for each
  value in that order, and must return the corresponding value.

  ```ruby
  expect(instance).to delegate_method(:foo).to(target).and_return(true)
  expect(instance).to delegate_method(:foo).to(target).and_return(0, 1, 2)
  ```

  Scenario: basic usage
    When the Ruby version is less than "3.0"
    Given a file named "delegate_method_matcher_spec.rb" with:
      """ruby
        require 'rspec/sleeping_king_studios/matchers/core/delegate_method'

        class ArrayWrapper
          def initialize ary
            @ary = ary
          end # constructor

          def inspect
            "#<ArrayWrapper>"
          end # method inspect

          def count
            @ary.count
          end # method count

          def each &block
            @ary.each &block
          end # method each

          def join str
            @ary.join str
          end # method join

          def reduce

          end # method reduce
        end # class

        RSpec.describe ArrayWrapper do
          let(:ary)      { %w(ichi ni san) }
          let(:instance) { ArrayWrapper.new(ary) }

          # Passing expectations.
          it { expect(instance).to delegate_method(:count).to(ary) }
          it { expect(instance).to delegate_method(:count).to(ary).and_return(3) }
          it { expect(instance).to delegate_method(:join).to(ary).with_arguments(', ') }
          it { expect(instance).to delegate_method(:each).to(ary).with_a_block }
          it { expect(instance).not_to delegate_method(:map).to(ary) }

          # Failing expectations.
          it { expect(instance).not_to delegate_method(:count).to(ary) }
          it { expect(instance).to delegate_method(:map).to(ary) }
          it { expect(instance).to delegate_method(:reduce).to(ary) }
        end # describe
      """
    When I run `rspec delegate_method_matcher_spec.rb`
    Then the output should contain "8 examples, 3 failures"
    Then the output should contain consecutive lines:
      | Failure/Error: it { expect(instance).not_to delegate_method(:count).to(ary) } |
      |   expected #<ArrayWrapper> not to delegate :count to ["ichi", "ni", "san"] with no arguments |
    Then the output should contain consecutive lines:
      | Failure/Error: it { expect(instance).to delegate_method(:map).to(ary) } |
      |   expected #<ArrayWrapper> to delegate :map to ["ichi", "ni", "san"], but #<ArrayWrapper> does not respond to :map |
    Then the output should contain consecutive lines:
      | Failure/Error: it { expect(instance).to delegate_method(:reduce).to(ary) } |
      |   expected #<ArrayWrapper> to delegate :reduce to ["ichi", "ni", "san"], but calling #reduce on the object does not call #reduce on the delegate |
