# frozen_string_literal: true

require 'spec_helper'

require 'support/contracts/rocket_contract'
require 'support/entities/rocket'

# @note Integration spec for RSpec::SleepingKingStudios::Contract.
RSpec.describe Spec::Support::Entities::Rocket do
  subject(:rocket) { described_class.new }

  Spec::Support::Contracts::RocketContract.apply(self, fuel_type: 'LF/O')
end
