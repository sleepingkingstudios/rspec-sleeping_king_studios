# frozen_string_literal: true

source 'https://rubygems.org'

gemspec

gem 'activemodel', '~> 8.0'

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
  gem 'rubocop',       '~> 1.73'
  gem 'rubocop-rspec', '~> 3.5'
  gem 'simplecov',     '~> 0.22'
end

group :doc do
  gem 'jekyll', '~> 4.3'
  gem 'jekyll-theme-dinky', '~> 0.2'

  # Use Kramdown to parse GFM-dialect Markdown.
  gem 'kramdown-parser-gfm', '~> 1.1'

  gem 'sleeping_king_studios-docs',
    git:    'https://github.com/sleepingkingstudios/sleeping_king_studios-docs.git',
    branch: 'main'
  gem 'webrick', '~> 1.8' # Use Webrick as local content server.
  gem 'yard', '~> 0.9', require: false
end
