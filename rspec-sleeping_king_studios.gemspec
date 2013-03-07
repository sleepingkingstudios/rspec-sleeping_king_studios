# rspec-sleeping_king_studios.gemspec

puts File.expand_path "lib/rspec/sleeping_king_studios/version"
require File.expand_path "lib/rspec/sleeping_king_studios/version"

Gem::Specification.new do |gem|
  gem.name        = 'rspec-sleeping_king_studios'
  gem.version     = RSpec::SleepingKingStudios::VERSION
  gem.date        = '2013-02-28'
  gem.summary     = 'A collection of RSpec patches and custom matchers.'
  gem.description = <<-DESCRIPTION
    A collection of RSpec patches and custom matchers. The features can be
    included individually or by category. For more information, check out the
    README.
  DESCRIPTION
  gem.authors     = ['Rob "Merlin" Smith']
  gem.email       = ['merlin@sleepingkingstudios.com']
  gem.homepage     = 'http://sleepingkingstudios.com'
  
  gem.add_runtime_dependency 'rspec', '~> 2.13'
  gem.add_runtime_dependency 'activesupport', '~> 3.0'
  
  gem.add_development_dependency 'activemodel', '~> 3.0'
end # gemspec
