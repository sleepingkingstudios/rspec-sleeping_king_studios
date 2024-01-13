# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path('./lib')
require 'rspec/sleeping_king_studios/version'

Gem::Specification.new do |gem|
  gem.name        = 'rspec-sleeping_king_studios'
  gem.version     = RSpec::SleepingKingStudios::VERSION
  gem.date        = Time.now.utc.strftime '%Y-%m-%d'
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

  gem.metadata = {
    'bug_tracker_uri' => 'https://github.com/sleepingkingstudios/rspec-sleeping_king_studios/issues',
    'source_code_uri' => 'https://github.com/sleepingkingstudios/rspec-sleeping_king_studios'
  }

  gem.require_path = 'lib'
  gem.files        = Dir['lib/**/*.rb', 'LICENSE', '*.md']

  gem.add_runtime_dependency 'hashdiff',                    '~> 0.3.8'
  gem.add_runtime_dependency 'rspec',                       '~> 3.4'
  gem.add_runtime_dependency 'sleeping_king_studios-tools', '>= 0.8.0', '< 2'
end
