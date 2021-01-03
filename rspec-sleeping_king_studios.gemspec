# frozen_string_literal: true

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

  gem.add_runtime_dependency 'hashdiff',                    '~> 0.3.8'
  gem.add_runtime_dependency 'rspec',                       '~> 3.4'
  gem.add_runtime_dependency 'sleeping_king_studios-tools', '>= 0.8.0', '< 2'

  gem.add_development_dependency 'appraisal',    '~> 2.2'
  gem.add_development_dependency 'byebug',       '~> 10.0'
  gem.add_development_dependency 'rake',         '~> 12.3'
  gem.add_development_dependency 'thor',         '~> 0.20', '>= 0.19.4'
  gem.add_development_dependency 'sleeping_king_studios-tasks',
    '~> 0.4', '>= 0.4.1'

  gem.add_development_dependency 'aruba',        '~> 0.14'
  gem.add_development_dependency 'cucumber',     '~> 3.1'

  gem.add_development_dependency 'activemodel',  '>= 3.0', '< 7.0'
end
