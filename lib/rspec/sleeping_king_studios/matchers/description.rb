# lib/rspec/sleeping_king_studios/matchers/description.rb

require 'rspec/sleeping_king_studios/matchers'

require 'sleeping_king_studios/tools/array_tools'
require 'sleeping_king_studios/tools/string_tools'

module RSpec::SleepingKingStudios::Matchers
  # Reusable logic for building a matcher description across different versions
  # of the base RSpec library.
  #
  # @since 2.2.0
  module Description
    # @api private
    DEFAULT_EXPECTED_ITEMS = Object.new

    # A short string that describes the purpose of the matcher.
    #
    # @return [String] the matcher description
    def description
      desc = matcher_name

      desc << format_expected_items

      desc
    end # method description

    private

    def expected_items_for_description
      defined?(@expected) ? @expected : DEFAULT_EXPECTED_ITEMS
    end # method expected_items_for_description

    def format_expected_items
      expected_items = expected_items_for_description

      return '' if expected_items == DEFAULT_EXPECTED_ITEMS

      if defined?(RSpec::Matchers::EnglishPhrasing)
        # RSpec 3.4+
        RSpec::Matchers::EnglishPhrasing.list(expected_items)
      elsif defined?(to_sentence)
        # RSpec 3.0-3.3
        to_sentence(expected_items)
      else
        array_tools = ::SleepingKingStudios::Tools::ArrayTools
        processed   = [expected_items].flatten.map(&:inspect)

        ' ' << array_tools.humanize_list(processed)
      end # if-elsif-else
    end # method format_expected_items

    def matcher_name
      return @matcher_name if @matcher_name

      string_tools = ::SleepingKingStudios::Tools::StringTools
      name         = string_tools.underscore(self.class.name.split('::').last)

      @matcher_name = name.tr('_', ' ').sub(/ matcher\z/, '')
    end # method matcher_name
  end # module
end # module
