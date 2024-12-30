# frozen_string_literal: true

RSpec.describe Hash do
  subject { { ok: true } }

  describe '#keys' do
    it { expect(subject.keys).to contain_exactly(:ok) } # rubocop:disable RSpec/NamedSubject
  end
end
