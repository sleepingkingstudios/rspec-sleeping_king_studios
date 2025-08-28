# frozen_string_literal: true

require 'rspec/sleeping_king_studios'

module A
  def a; end

  alias_method :b, :a
  alias c a
end

module B
  include A

  alias_method :d, :a
  alias e a
end

RSpec.describe A do
  include RSpec::SleepingKingStudios::Matchers::Macros

  subject { Object.new.extend(A) }

  it { expect(subject).to have_aliased_method('a').as('b') }

  it { expect(subject).to have_aliased_method('a').as('c') }

  it { expect(subject).to have_aliased_method('a').as('d') }

  it { expect(subject).to have_aliased_method('a').as('e') }

  pending
end
