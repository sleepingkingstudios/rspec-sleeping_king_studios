# frozen_string_literals: true

require 'rspec/sleeping_king_studios/matchers/core/be_a_uuid_matcher'
require 'rspec/sleeping_king_studios/matchers/macros'

module RSpec::SleepingKingStudios::Matchers::Macros
  # @see RSpec::SleepingKingStudios::Matchers::Core::BeAUuidMatcher#matches?
  def be_a_uuid
    RSpec::SleepingKingStudios::Matchers::Core::BeAUuidMatcher.new
  end

  # @!method a_uuid
  #   @see RSpec::SleepingKingStudios::Matchers::Core::BeBooleanMatcher#matches?
  alias_matcher :a_uuid, :be_a_uuid do |description|
    'a UUID'
  end
end
