# spec/rspec/sleeping_king_studios_spec.rb

require 'rspec/sleeping_king_studios/spec_helper'

require 'rspec/sleeping_king_studios'

describe RSpec::SleepingKingStudios do
  def self.matchers
    Dir[File.join File.dirname(__FILE__), 'sleeping_king_studios', 'matchers', '*'].map do |dir_name|
      next unless File.directory?(dir_name)
      Dir[File.join dir_name, '*_spec.rb'].map do |file_name|
        File.split(file_name).last.gsub(/_spec.rb/,'')
      end # map
    end.flatten.compact # end each
  end # class method matchers
  
  let(:matchers)      { self.class.matchers }
  let(:example_group) { self }

  matchers.each do |matcher|
    context do
      it { expect(example_group).to respond_to matcher }
    end # context
  end # each
end # describe
