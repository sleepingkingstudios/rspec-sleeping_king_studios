# frozen_string_literal: true

RSpec.describe TrueClass do
  it { expect(true).to be nil } # rubocop:disable RSpec/ExpectActual

  it { expect(true).to be false } # rubocop:disable RSpec/ExpectActual

  it { expect(true).to be true } # rubocop:disable RSpec/ExpectActual, RSpec/IdenticalEqualityAssertion
end
