# spec/rspec/sleeping_king_studios/matchers/built_in_spec.rb

require 'rspec/sleeping_king_studios/spec_helper'

require 'rspec/sleeping_king_studios/matchers/built_in'

describe RSpec::SleepingKingStudios::Matchers::BuiltIn do
  def self.matchers
    Dir[File.join File.dirname(__FILE__), 'built_in', '*_spec.rb'].map do |file|
      File.split(file).last.gsub(/_spec.rb/,'')
    end # end each
  end # class method matchers
  
  let :matchers do self.class.matchers; end
  let :example_group do RSpec::Core::ExampleGroup.new; end
  
  matchers.each do |matcher|
    context do
      specify { expect(example_group).to respond_to matcher }
    end # context
  end # each
end # describe
