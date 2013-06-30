# lib/rspec/sleeping_king_studios/matchers/rspec.rb

Dir[File.join File.dirname(__FILE__), 'rspec', '*.rb'].each do |file|
  require file
end # end each
