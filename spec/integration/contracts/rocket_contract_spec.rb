# frozen_string_literal: true

require 'spec_helper'

require 'support/contracts/rocket_contract'
require 'support/entities/rocket'

# @note Integration spec for RSpec::SleepingKingStudios::Contract.
RSpec.describe Spec::Support::Entities::Rocket do
  extend RSpec::SleepingKingStudios::Concerns::IncludeContract

  subject(:rocket) { described_class.new }

  Spec::Support::Contracts::RocketContract.new.apply(self, fuel_type: 'LF/O')
end
