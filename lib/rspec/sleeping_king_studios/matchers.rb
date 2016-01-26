# lib/rspec/sleeping_king_studios/matchers.rb

require 'rspec/sleeping_king_studios'

module RSpec::SleepingKingStudios
  # Custom matchers for use with RSpec::Expectations.
  module Matchers
    # @see RSpec::Matchers::alias_matcher
    def self.alias_matcher(new_name, old_name, options = {}, &description_override)
      description_override ||= if defined?(RSpec::Matchers::Pretty)
        ->(str) { str.gsub(RSpec::Matchers::Pretty.split_words(old_name), RSpec::Matchers::Pretty.split_words(new_name)) }
      elsif defined?(RSpec::Matchers::EnglishPhrasing)
        ->(str) { str.gsub(RSpec::Matchers::EnglishPhrasing.split_words(old_name), RSpec::Matchers::EnglishPhrasing.split_words(new_name)) }
      else
        ->(str) { str }
      end # if-elsif-else

      klass = (options.is_a?(Hash) ? options[:klass] : nil) || RSpec::Matchers::AliasedMatcher
      define_method(new_name) do |*args, &block|
        matcher = __send__(old_name, *args, &block)

        klass.new(matcher, description_override)
      end # define_method
    end # class method alias_matcher
  end # module
end # module

RSpec.configure do |config|
  config.include RSpec::SleepingKingStudios::Matchers
end # configuration
