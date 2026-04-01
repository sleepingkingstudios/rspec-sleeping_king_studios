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
      desc = matcher_name.to_s

      desc << format_expected_items

      desc
    end

    private

    def expected_items_for_description
      defined?(@expected) ? @expected : DEFAULT_EXPECTED_ITEMS
    end

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
        processed =
          tools
          .array_tools
          .humanize_list([expected_items].flatten.map(&:inspect))

        ' ' << array_tools.humanize_list(processed)
      end
    end

    def matcher_name
      return @matcher_name if @matcher_name

      name = tools.string_tools.underscore(self.class.name.split('::').last)

      @matcher_name = name.tr('_', ' ').sub(/ matcher\z/, '')
    end

    def tools
      SleepingKingStudios::Tools::Toolbelt.instance
    end
  end
end
