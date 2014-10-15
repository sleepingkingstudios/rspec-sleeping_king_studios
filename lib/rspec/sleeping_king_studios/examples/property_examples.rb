# subl lib/rspec/sleeping_king_studios/examples/property_examples.rb

require 'rspec/sleeping_king_studios/examples'
require 'rspec/sleeping_king_studios/matchers/core/have_reader'
require 'rspec/sleeping_king_studios/matchers/core/have_writer'

module RSpec::SleepingKingStudios::Examples::PropertyExamples
  UNDEFINED_PROPERTY_EXPECTATION = Object.new.freeze

  class << self
    # @api private
    def apply base, proc, *args, &block
      method_name = :__temporary_method_for_applying_proc__
      metaclass   = class << base; self; end
      metaclass.send :define_method, method_name, &proc

      value = base.send method_name, *args, &block

      metaclass.send :remove_method, method_name

      value
    end # class method apply
  end # class << self

  shared_examples 'has reader' do |property, expected_value = UNDEFINED_PROPERTY_EXPECTATION|
    it "has reader :#{property}" do
      object = defined?(instance) ? instance : subject

      expect(object).to have_reader(property)

      next if expected_value == UNDEFINED_PROPERTY_EXPECTATION

      actual_value = instance.send property

      if expected_value.is_a?(Proc)
        args = [self, expected_value]
        args.push actual_value unless 0 == expected_value.arity

        expected_value = RSpec::SleepingKingStudios::Examples::PropertyExamples.apply *args
      end # if

      case expected_value
      when ->(obj) { obj.respond_to?(:matches?) }
        expect(actual_value).to expected_value
      when true, false
        expected_value
      else
        expect(actual_value).to be == expected_value
      end # case
    end # it
  end # shared_examples

  shared_examples 'has writer' do |property|
    it "has writer :#{property}=" do
      object = defined?(instance) ? instance : subject

      expect(object).to have_writer(property)
    end # it
  end # shared_examples
end # module
