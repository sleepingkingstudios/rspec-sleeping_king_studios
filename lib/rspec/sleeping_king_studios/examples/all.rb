# lib/rspec/sleeping_king_studios/examples/all.rb

Dir[File.join File.dirname(__FILE__), '*_examples.rb'].each do |file|
  require file
end # end each
