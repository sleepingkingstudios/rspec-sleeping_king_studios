# lib/rspec/sleeping_king_studios/util/version.rb

module RSpec
  module SleepingKingStudios
    module Util
      class Version
        include Comparable

        def initialize version_string
          self.major, self.minor, self.build = version_string.split(".")
          major ||= 0
          minor ||= 0
          build ||= 0
        end # method initialize

        attr_accessor :major, :minor, :build

        def inspect
          to_s
        end # method inspect

        def to_s
          "#{major}.#{minor}.#{build}"
        end # method to_s

        def <=>(other)
          tmp, other = nil, self.class.new(other) if other.is_a? String

          [:major, :minor, :build].each do |value|
            return tmp unless 0 == (tmp = self.send(value) <=> other.send(value))
          end # each

          0
        end # method <=>
      end # class

      RUBY_VERSION = Version.new ::RUBY_VERSION
    end # module
  end # module
end # module
