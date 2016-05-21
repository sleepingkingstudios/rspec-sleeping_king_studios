# features/matchers/core/have_constant_matcher.feature

Feature: `have_constant` matcher
  Use the `have_constant` matcher to specify that an object must have a constant defined:

  ```ruby
  expect(instance).to have_constant(:ROLES) # True if instance defines the constant ::ROLES, otherwise false.
  ```

  You can also specify a current value for the constant with the `with_value`
  method. This can take a literal value, or you can use RSpec composable
  matchers for a more advanced expectation:

  ```ruby
  expect(instance).to have_constant(:ROLES).with_value(%w(user admin)) # Expects instance::ROLES to be == ['user', 'admin'].

  expect(instance).to have_constant(:ROLES).with_value(contain_exactly 'admin', 'user') # Expects instance::ROLES to be an Array with items 'admin' and 'user'.
  ```

  Finally, you can add an immutable constraint. Values of `nil`, `false`, `true` are always immutable, as are `Numeric` and `Symbol` primitives. `Array` values must be frozen and all array items must be immutable. `Hash` values must be frozen and all hash keys and values must be immutable.

  ```
  expect(instance).to have_immutable_constant(:MAX_USERS) # Expects instance to define the constant :MAX_USERS and have an immutable value.

  expect(instance).to have_immutable_constant(:ADMIN_ROLE).with_value('admin') # Expects instance to define the constant :ADMIN_ROLE with the value 'admin', with the value being a frozen string.
  ```

  Scenario: basic usage
    Given a file named "have_constant_matcher_spec.rb" with:
      """ruby
        require 'rspec/sleeping_king_studios/matchers/core/have_constant'

        module MyModule
          MAX_USERS = 1_000
          ROLES = [
            ADMIN_ROLE = 'admin',
            USER_ROLE  = 'user'.freeze
          ] # end array
        end # module

        RSpec.describe MyModule do
          # Passing expectations.
          it { expect(described_class).to have_constant(:MAX_USERS) }
          it { expect(described_class).to have_constant(:MAX_USERS).with_value(1_000) }
          it { expect(described_class).to have_immutable_constant(:MAX_USERS).with_value(1_000) }
          it { expect(described_class).to have_constant(:ROLES).with_value(contain_exactly 'admin', 'user') }
          it { expect(described_class).to have_immutable_constant(:USER_ROLE) }
          it { expect(described_class).not_to have_constant(:SECRET_KEY) }

          # Failing expectations.
          it { expect(described_class).not_to have_constant(:MAX_USERS) }
          it { expect(described_class).not_to have_constant(:MAX_USERS).with_value(1_000) }
          it { expect(described_class).not_to have_immutable_constant(:MAX_USERS).with_value(1_000) }
          it { expect(described_class).not_to have_constant(:ROLES).with_value(contain_exactly 'admin', 'user') }
          it { expect(described_class).to have_immutable_constant(:ADMIN_ROLE) }
          it { expect(described_class).to have_constant(:SECRET_KEY) }
        end # describe
      """
    When I run `rspec have_constant_matcher_spec.rb`
    Then the output should contain "12 examples, 6 failures"
    Then the output should contain consecutive lines:
      | Failure/Error: it { expect(described_class).not_to have_constant(:MAX_USERS) } |
      |   expected MyModule not to have constant :MAX_USERS, but MyModule defines constant :MAX_USERS with value 1000 |
    Then the output should contain consecutive lines:
      | Failure/Error: it { expect(described_class).not_to have_constant(:MAX_USERS).with_value(1_000) } |
      |   expected MyModule not to have constant :MAX_USERS with value 1000, but MyModule defines constant :MAX_USERS with value 1000 |
    Then the output should contain consecutive lines:
      | Failure/Error: it { expect(described_class).not_to have_immutable_constant(:MAX_USERS).with_value(1_000) } |
      |   expected MyModule not to have immutable constant :MAX_USERS with value 1000, but MyModule defines constant :MAX_USERS with value 1000 |
    Then the output should contain consecutive lines:
      | Failure/Error: it { expect(described_class).not_to have_constant(:ROLES).with_value(contain_exactly 'admin', 'user') } |
      |   expected MyModule not to have constant :ROLES with value contain exactly "admin" and "user", but MyModule defines constant :ROLES with value ["admin", "user"] |
    Then the output should contain consecutive lines:
      | Failure/Error: it { expect(described_class).to have_immutable_constant(:ADMIN_ROLE) } |
      |   expected MyModule to have immutable constant :ADMIN_ROLE, but the value of :ADMIN_ROLE was mutable |
    Then the output should contain consecutive lines:
      | Failure/Error: it { expect(described_class).to have_constant(:SECRET_KEY) } |
      |   expected MyModule to have constant :SECRET_KEY, but MyModule does not define constant :SECRET_KEY |
