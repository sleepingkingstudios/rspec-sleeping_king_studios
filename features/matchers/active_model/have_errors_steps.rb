# features/matchers/active_model/have_errors_steps.rb

Given(/^a file with a model class definition$/) do
  step %{a file named "model.rb" with:}, <<-FILE
require 'active_model'

class Model
  include ActiveModel::Model

  attr_accessor :value

  validates :value, :presence => true

  def inspect
    valid? ? 'a valid model' : 'an invalid model'
  end # method inspect
end # class
  FILE
end # step definition
