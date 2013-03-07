# lib/rspec/sleeping_king_studios/matchers/core.rb

Dir[File.join File.dirname(__FILE__), 'core', '*.rb'].each do |file|
  require file
end # end each
