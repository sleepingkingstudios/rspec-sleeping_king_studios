# frozen_string_literal: true

RSpec.describe TrueClass do
  it { expect(true).to be nil }

  it { expect(true).to be false }

  it { expect(true).to be true }
end
