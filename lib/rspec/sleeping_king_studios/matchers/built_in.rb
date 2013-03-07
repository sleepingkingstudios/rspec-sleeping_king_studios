# lib/rspec/sleeping_king_studios/matchers/built_in.rb

Dir[File.join File.dirname(__FILE__), 'built_in', '*.rb'].each do |file|
  require file
end # end each
