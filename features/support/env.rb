# features/support/env.rb

require 'aruba/cucumber'
require 'byebug'

require 'rspec'

module Spec
  class GemVersion
    include Comparable

    def initialize(version)
      @segments = version.split('.').map do |str|
        str.to_i.to_s == str ? str.to_i : str
      end

      0.upto(2) { |i| @segments[i] ||= 0 }
    end

    def <=>(version)
      version = GemVersion.new(version) if version.is_a?(String)

      segments
        .zip(version.segments)
        .map { |u, v| compare(u, v) }
        .find(&:nonzero?) || 0
    end

    protected

    attr_reader :segments

    private

    def compare(u, v)
      return -1 if u.nil?
      return 1  if v.nil?

      u <=> v
    end
  end

  RSPEC_VERSION = Spec::GemVersion.new(RSpec::Version::STRING)
end
