# spec/rspec/sleeping_king_studios/concerns/wrap_env_spec.rb

require 'rspec/sleeping_king_studios/concerns/wrap_env'

require 'rspec/sleeping_king_studios/matchers/built_in/respond_to'
require 'rspec/sleeping_king_studios/matchers/core/alias_method'

RSpec.describe RSpec::SleepingKingStudios::Concerns::WrapEnv do
  let(:described_class) do
    Class.new do
      include RSpec::SleepingKingStudios::Concerns::WrapEnv

      def self.around(_scope)
        yield example
      end # class method around

      def self.example
        @example ||= new
      end # class method example

      def call; end

      def example
        self
      end # method example
    end # class
  end # let
  let(:instance) { described_class.new }

  describe '::wrap_env' do
    let(:var)   { 'ENV_VARIABLE' }
    let(:value) { '5ca0a61d359a95512acb24588694e669' }

    it { expect(described_class).to respond_to(:wrap_env).with(1..2).arguments }

    it { expect(described_class).to alias_method(:wrap_env).as(:stub_env) }

    describe 'with a variable name and value' do
      it 'should overwrite the environment variable' do
        expect(described_class).
          to receive(:around).with(:example).and_call_original

        expect(described_class.example).to receive(:call) do
          expect(ENV[var]).to be == value
        end # expect

        described_class.wrap_env var, value
      end # it
    end # describe

    describe 'with a variable name and a calculated value' do
      it 'should overwrite the environment variable' do
        calculated_value = 'f886e54c416f972b6d15aee66ef4d9b1'

        expect(described_class).
          to receive(:around).with(:example).and_call_original

        expect(described_class.example).to receive(:call) do
          expect(ENV[var]).to be == calculated_value
        end # expect

        caller = nil

        described_class.wrap_env(var) do
          caller = self

          calculated_value
        end # wrap_env

        expect(caller).to be described_class.example
      end # it
    end # describe
  end # describe

  describe '#wrap_env' do
    let(:var)   { 'ENV_VARIABLE' }
    let(:value) { '5ca0a61d359a95512acb24588694e669' }

    it { expect(instance).to respond_to(:wrap_env).with(2).arguments }

    it { expect(instance).to alias_method(:wrap_env).as(:stub_env) }

    it 'should overwrite the environment variable' do
      expect(ENV[var]).to be nil

      instance.wrap_env(var, value) do
        expect(ENV[var]).to be == value
      end # wrap_env

      expect(ENV[var]).to be nil
    end # it

    context 'when the block raises an error' do
      it 'should reset the value' do
        begin
          instance.wrap_env(var, value) do
            raise ArgumentError
          end # wrap_env
        rescue ArgumentError
        end # begin-rescue

        expect(ENV[var]).to be nil
      end # it
    end # context

    context 'when the environment variable has a value set' do
      let(:default_value) { 'd5ac8151bae204bb3174c62864f1078b' }

      around(:example) do |example|
        begin
          prior_value = ENV[var]
          ENV[var]    = default_value

          example.call
        ensure
          ENV[var]    = prior_value
        end # begin-rescue
      end # around example

      it 'should overwrite the environment variable' do
        expect(ENV[var]).to be == default_value

        instance.wrap_env(var, value) do
          expect(ENV[var]).to be == value
        end # wrap_env

        expect(ENV[var]).to be == default_value
      end # it

      context 'when the block raises an error' do
        it 'should reset the value' do
          begin
            instance.wrap_env(var, value) do
              raise ArgumentError
            end # wrap_env
          rescue ArgumentError
          end # begin-rescue

          expect(ENV[var]).to be == default_value
        end # it
      end # context
    end # context
  end # describe
end # describe
