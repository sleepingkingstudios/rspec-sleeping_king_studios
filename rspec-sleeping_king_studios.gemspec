# rspec-sleeping_king_studios.gemspec

require File.expand_path "lib/rspec/sleeping_king_studios/version"

Gem::Specification.new do |gem|
  gem.name        = 'rspec-sleeping_king_studios'
  gem.version     = RSpec::SleepingKingStudios::VERSION
  gem.date        = Time.now.utc.strftime "%Y-%m-%d"
  gem.summary     = 'A collection of RSpec patches and custom matchers.'
  gem.description = <<-DESCRIPTION
    A collection of RSpec patches and custom matchers. The features can be
    included individually or by category. For more information, check out the
    README.
  DESCRIPTION
  gem.authors     = ['Rob "Merlin" Smith']
  gem.email       = ['merlin@sleepingkingstudios.com']
  gem.homepage    = 'http://sleepingkingstudios.com'
  gem.license     = 'MIT'
  
  gem.require_path = 'lib'
  gem.files        = Dir["lib/**/*.rb", "LICENSE", "*.md"]
  
  gem.add_runtime_dependency 'rspec', '~> 3.0'
  
  gem.add_development_dependency 'rake',         '~> 10.3'
  gem.add_development_dependency 'activemodel',  '~> 3.0'
  gem.add_development_dependency 'factory_girl', '~> 4.2'
  gem.add_development_dependency 'pry',          '~> 0.9', '>= 0.9.12'
end # gemspec
