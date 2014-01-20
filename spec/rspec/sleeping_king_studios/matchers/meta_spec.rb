# spec/rspec/sleeping_king_studios/matchers/meta_spec.rb

require 'rspec/sleeping_king_studios/spec_helper'

require 'rspec/sleeping_king_studios/matchers/meta'

describe RSpec::SleepingKingStudios::Matchers::Meta do
  def self.matchers
    Dir[File.join File.dirname(__FILE__), 'meta', '*_spec.rb'].map do |file|
      File.split(file).last.gsub(/_spec.rb/,'')
    end # end each
  end # class method matchers
  
  let(:matchers)      { self.class.matchers }
  let(:example_group) { self }
  
  matchers.each do |matcher|
    context do
      specify { expect(example_group).to respond_to matcher }
    end # context
  end # each
end # describe