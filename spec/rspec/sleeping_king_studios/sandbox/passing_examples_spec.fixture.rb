# frozen_string_literal: true

RSpec.describe Array do
  subject { %i[one two three] }

  describe '#count' do
    it { expect(subject.count).to be 3 }
  end

  describe '#empty?' do
    it { expect(subject.empty?).to be false }
  end
end
