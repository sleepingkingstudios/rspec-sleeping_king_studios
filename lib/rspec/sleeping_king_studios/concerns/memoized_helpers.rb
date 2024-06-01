# frozen_string_literal: true

require 'rspec/sleeping_king_studios/concerns'

module RSpec::SleepingKingStudios::Concerns
  # Methods for defining memoized helpers in example groups.
  module MemoizedHelpers
    # Defines a memoized helper if a method of the same name is not defined.
    #
    # @param method_name [String] the name of the helper method.
    #
    # @yieldreturn [Object] the value of the memoized helper method.
    def let?(method_name, &)
      return method_name if method_defined?(method_name)

      let(method_name, &)
    end
  end
end
