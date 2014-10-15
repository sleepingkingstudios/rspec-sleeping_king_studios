# lib/rspec/sleeping_king_studios/support.rb

require 'rspec/sleeping_king_studios'

module RSpec::SleepingKingStudios
  module Support
    # @api private
    def self.apply base, proc, *args, &block
      method_name = :__rspec_sleeping_king_studios_support_temporary_method_for_applying_proc__
      metaclass   = class << base; self; end
      metaclass.send :define_method, method_name, &proc

      value = base.send method_name, *args, &block

      metaclass.send :remove_method, method_name

      value
    end # class method apply
  end # module
end # module
