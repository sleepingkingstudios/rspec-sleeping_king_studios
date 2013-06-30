# spec/rspec/sleeping_king_studios/matchers/built_in/respond_to_spec.rb

require 'rspec/sleeping_king_studios/spec_helper'

require 'rspec/sleeping_king_studios/matchers/built_in/respond_to'

describe "#respond_to" do
  def self.ruby_version
    Struct.new(:major, :minor, :build).new *RUBY_VERSION.split(".")
  end # class method ruby_version

  let(:example_group) { RSpec::Core::ExampleGroup.new }
  let(:identifier)    { :foo }
  let(:instance)      { example_group.respond_to identifier }
  let(:ruby_version)  { Version.new *RUBY_VERSION.split(".") }
  
  # Paging Douglas Hofstadter, or possibly Xzibit...
  specify { expect(example_group).to respond_to(:respond_to).with(1).arguments }

  describe "#with" do
    specify { expect(instance).to respond_to(:with).with(0..1).arguments }
    specify { expect(instance.with).to be instance }
  end # describe
  
  describe "#and" do
    specify { expect(instance).to respond_to(:and).with(0).arguments }
    specify { expect(instance.and).to be instance }
  end # describe
  
  describe "#a_block" do
    specify { expect(instance).to respond_to(:a_block).with(0).arguments }
    specify { expect(instance.a_block).to be instance }
  end # describe

  <<-SCENARIOS
    When there is no matching method,
      Evaluates to false with should message "to respond to".
    When there is a matching method,
      And there are no argument bounds,
        Evaluates to true with should_not message "not to respond to".
      And there is a set of arguments,
        And the method accepts that set of arguments,
          Evaluates to true with should_not message "respond to with (count) arguments".
        And the method requires more or fewer regular arguments,
          Evaluates to false with should message "requires at least|most (count) arguments".
        And the method requires un-provided key arguments,
          Evaluates to false with should message "requires keyed arguments (*list)".
      And there is a block provided,
        And the method expects a block,
          Evaluates to true with should_not message "not to respond to with a block".
        And the method does not expect a block,
          Evaluates to false with should message "to respond_to with a block".
  SCENARIOS

  describe 'with no matching method' do
    let(:actual) { Object.new }

    specify { expect(instance).to fail_with_actual(actual).
      with_message "expected #{actual.inspect} to respond to #{identifier.inspect}" }
  end # describe

  describe 'with a matching method with no arguments' do
    let(:actual) { Class.new.tap { |klass| klass.send :define_method, identifier, &(Proc.new {}) }.new }

    specify 'with no arguments' do
      expect(instance).to pass_with_actual(actual).
        with_message "expected #{actual} not to respond to :#{identifier}"
    end # specify

    specify 'with too many regular arguments' do
      expect(instance.with(1).arguments).to fail_with_actual(actual).
        with_message "expected at most 0 arguments to :#{identifier}"
    end # specify
  end # describe
  
  describe 'with no matching method' do
    let :actual do Class.new.new; end
    
    specify { expect(instance).to fail_with_actual(actual).
      with_message "expected #{actual.inspect} to respond to #{identifier.inspect}" }
    specify { expect(instance.with(count = 0)).to fail_with_actual(actual).
      with_message "expected #{actual.inspect} to respond to #{identifier.inspect}" }
    specify { expect(instance.with(count = 0..1)).to fail_with_actual(actual).
      with_message "expected #{actual.inspect} to respond to #{identifier.inspect}" }
    specify { expect(instance.with.a_block).to fail_with_actual(actual).
      with_message "expected #{actual.inspect} to respond to #{identifier.inspect}" }
  end # describe
  
  describe 'with a method with no arguments' do
    let :actual do
      Class.new.tap { |klass| klass.define_method identifier, &(Proc.new {}) }.new
    end # let
    
    specify { expect(instance).to pass_with_actual(actual).
      with_message "expected #{actual.inspect} not to respond to #{identifier.inspect}" }
    specify { expect(instance.with(count = 0).arguments).to pass_with_actual(actual).
      with_message "expected #{actual.inspect} not to respond to #{identifier.inspect} with #{count} arguments" }
    specify { expect(instance.with(count = 1).arguments).to fail_with_actual(actual).
      with_message "expected #{actual.inspect} to respond to #{identifier.inspect} with #{count} argument" }
    specify { expect(instance.with(count = 0..1)).to fail_with_actual(actual).
      with_message "expected #{actual.inspect} to respond to #{identifier.inspect} with #{count} arguments" }
    specify { expect(instance.with.a_block).to fail_with_actual(actual).
      with_message "expected #{actual.inspect} to respond to #{identifier.inspect} with a block" }
  end # describe
  
  describe 'with a method with required arguments' do
    let :actual do
      Class.new.tap { |klass| klass.define_method identifier, &(Proc.new { |a, b, c| }) }.new
    end # let
    
    specify { expect(instance).to pass_with_actual(actual).
      with_message "expected #{actual.inspect} not to respond to #{identifier.inspect}" }
    specify { expect(instance.with(count = 0).arguments).to fail_with_actual(actual).
      with_message "expected #{actual.inspect} to respond to #{identifier.inspect} with #{count} arguments" }
    specify { expect(instance.with(count = 1).arguments).to fail_with_actual(actual).
      with_message "expected #{actual.inspect} to respond to #{identifier.inspect} with #{count} argument" }
    specify { expect(instance.with(count = 3).arguments).to pass_with_actual(actual).
      with_message "expected #{actual.inspect} not to respond to #{identifier.inspect} with #{count} arguments" }
    specify { expect(instance.with(count = 4).arguments).to fail_with_actual(actual).
      with_message "expected #{actual.inspect} to respond to #{identifier.inspect} with #{count} arguments" }
    specify { expect(instance.with(count = 0..1)).to fail_with_actual(actual).
      with_message "expected #{actual.inspect} to respond to #{identifier.inspect} with #{count} arguments" }
    specify { expect(instance.with.a_block).to fail_with_actual(actual).
      with_message "expected #{actual.inspect} to respond to #{identifier.inspect} with a block" }
  end # describe
  
  describe 'with a method with optional arguments' do
    let :actual do
      Class.new.tap { |klass| klass.define_method identifier, &(Proc.new { |a, b, c = nil, d = nil| }) }.new
    end # let

    specify { expect(instance).to pass_with_actual(actual).
      with_message "expected #{actual.inspect} not to respond to #{identifier.inspect}" }
    specify { expect(instance.with(count = 0).arguments).to fail_with_actual(actual).
      with_message "expected #{actual.inspect} to respond to #{identifier.inspect} with #{count} arguments" }
    specify { expect(instance.with(count = 1).arguments).to fail_with_actual(actual).
      with_message "expected #{actual.inspect} to respond to #{identifier.inspect} with #{count} argument" }
    specify { expect(instance.with(count = 3).arguments).to pass_with_actual(actual).
      with_message "expected #{actual.inspect} not to respond to #{identifier.inspect} with #{count} arguments" }
    specify { expect(instance.with(count = 4).arguments).to pass_with_actual(actual).
      with_message "expected #{actual.inspect} not to respond to #{identifier.inspect} with #{count} arguments" }
    specify { expect(instance.with(count = 5).arguments).to fail_with_actual(actual).
      with_message "expected #{actual.inspect} to respond to #{identifier.inspect} with #{count} arguments" }
    specify { expect(instance.with(count = 0..1)).to fail_with_actual(actual).
      with_message "expected #{actual.inspect} to respond to #{identifier.inspect} with #{count} arguments" }
    specify { expect(instance.with(count = 3..4)).to pass_with_actual(actual).
      with_message "expected #{actual.inspect} not to respond to #{identifier.inspect} with #{count} arguments" }
    specify { expect(instance.with.a_block).to fail_with_actual(actual).
      with_message "expected #{actual.inspect} to respond to #{identifier.inspect} with a block" }
  end # describe
  
  describe 'with a method with variadic arguments' do
    let :actual do
      Class.new.tap { |klass| klass.define_method identifier, &(Proc.new { |a, b, *c| }) }.new
    end # let
    
    specify { expect(instance).to pass_with_actual(actual).
      with_message "expected #{actual.inspect} not to respond to #{identifier.inspect}" }
    specify { expect(instance.with(count = 0).arguments).to fail_with_actual(actual).
      with_message "expected #{actual.inspect} to respond to #{identifier.inspect} with #{count} arguments" }
    specify { expect(instance.with(count = 1).arguments).to fail_with_actual(actual).
      with_message "expected #{actual.inspect} to respond to #{identifier.inspect} with #{count} argument" }
    specify { expect(instance.with(count = 2).arguments).to pass_with_actual(actual).
      with_message "expected #{actual.inspect} not to respond to #{identifier.inspect} with #{count} arguments" }
    specify { expect(instance.with(count = 10).arguments).to pass_with_actual(actual).
      with_message "expected #{actual.inspect} not to respond to #{identifier.inspect} with #{count} arguments" }
    specify { expect(instance.with(count = 0..1)).to fail_with_actual(actual).
      with_message "expected #{actual.inspect} to respond to #{identifier.inspect} with #{count} arguments" }
    specify { expect(instance.with(count = 2..10)).to pass_with_actual(actual).
      with_message "expected #{actual.inspect} not to respond to #{identifier.inspect} with #{count} arguments" }
    specify { expect(instance.with.a_block).to fail_with_actual(actual).
      with_message "expected #{actual.inspect} to respond to #{identifier.inspect} with a block" }
  end # describe
  
  describe 'with a method with a block argument' do
    let :actual do
      Class.new.tap { |klass| klass.define_method identifier, &(Proc.new { |&a| }) }.new
    end # let
    
    specify { expect(instance).to pass_with_actual(actual).
      with_message "expected #{actual.inspect} not to respond to #{identifier.inspect}" }
    specify { expect(instance.with(count = 0).arguments).to pass_with_actual(actual).
      with_message "expected #{actual.inspect} not to respond to #{identifier.inspect} with #{count} arguments" }
    specify { expect(instance.with(count = 1).arguments).to fail_with_actual(actual).
      with_message "expected #{actual.inspect} to respond to #{identifier.inspect} with #{count} argument" }
    specify { expect(instance.with(count = 0..1)).to fail_with_actual(actual).
      with_message "expected #{actual.inspect} to respond to #{identifier.inspect} with #{count} arguments" }
    specify { expect(instance.with.a_block).to pass_with_actual(actual).
      with_message "expected #{actual.inspect} not to respond to #{identifier.inspect} with a block" }
  end # describe
end # describe
