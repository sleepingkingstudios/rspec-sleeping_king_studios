# frozen_string_literal: true

source 'https://rubygems.org'

gemspec

gem 'activemodel', '~> 7.0'

gem 'sleeping_king_studios-tasks', '~> 0.4', '>= 0.4.1'

gem 'sleeping_king_studios-tools',
  git:    'https://github.com/sleepingkingstudios/sleeping_king_studios-tools.git',
  branch: 'main'

group :development, :test do
  gem 'appraisal', '~> 2.5'
  gem 'aruba',     '~> 0.14'
  gem 'byebug',    '~> 11.1'

  gem 'cucumber',      '~> 3.1'
  gem 'rspec',         '~> 3.13'
  gem 'rubocop',       '~> 1.64'
  gem 'rubocop-rspec', '~> 2.29', '>= 2.29.2'
  gem 'simplecov',     '~> 0.22'
end
