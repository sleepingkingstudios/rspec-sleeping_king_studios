# lib/rspec/sleeping_king_studios/matchers.rb

%w(active_model built_in core meta).each do |dir_name|
  require File.join File.dirname(__FILE__), 'matchers', dir_name
end # each
