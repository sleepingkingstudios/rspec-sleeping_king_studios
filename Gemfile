# frozen_string_literal: true

source 'https://rubygems.org'

gemspec

gem 'activemodel', '~> 8.1'

gem 'cuprum-cli', '~> 0.1'

group :development, :test do
  gem 'appraisal', '~> 2.5'
  gem 'aruba',     '~> 0.14'
  gem 'byebug',    '~> 11.1'
  gem 'readline'

  gem 'cucumber',      '~> 3.1'
  gem 'rspec',         '~> 3.13'
  gem 'rubocop',       '~> 1.89'
  gem 'rubocop-rspec', '~> 3.10'
  gem 'simplecov',     '~> 0.22'
end

group :docs do
  gem 'irb', '~> 1.16'

  gem 'jekyll', '~> 4.3'
  gem 'jekyll-theme-dinky', '~> 0.2'

  # Use Kramdown to parse GFM-dialect Markdown.
  gem 'kramdown-parser-gfm', '~> 1.1'

  gem 'sleeping_king_studios-docs', '~> 0.2', '>= 0.2.1'
  gem 'webrick', '~> 1.8' # Use Webrick as local content server.
  gem 'yard', '~> 0.9', require: false
end
