# lib/rspec/sleeping_king_studios/matchers/all.rb

%w(active_model built_in core).each do |dir_name|
  require File.join File.dirname(__FILE__), dir_name, 'all'
end # each
