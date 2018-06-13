# rspec-sleeping_king_studios.gemspec

$LOAD_PATH.unshift File.expand_path('./lib')
require 'rspec/sleeping_king_studios/version'

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

  gem.add_runtime_dependency 'rspec',                       '~> 3.4'
  gem.add_runtime_dependency 'sleeping_king_studios-tools', '~> 0.7'

  gem.add_development_dependency 'appraisal',    '~> 1.0', '>= 1.0.3'
  gem.add_development_dependency 'byebug',       '~> 8.2', '>= 8.2.2'
  gem.add_development_dependency 'rake',         '~> 12.0'
  gem.add_development_dependency 'thor',         '~> 0.19', '>= 0.19.4'
  gem.add_development_dependency 'sleeping_king_studios-tasks', '>= 0.1.0'

  gem.add_development_dependency 'aruba',        '~> 0.9'
  gem.add_development_dependency 'cucumber',     '~> 1.3', '>= 1.3.19'

  gem.add_development_dependency 'activemodel',  '>= 3.0', '< 6.0'
end # gemspec
