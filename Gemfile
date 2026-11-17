# frozen_string_literal: true

source 'https://rubygems.org'

gemspec

# TODO: Remove this override when ActiveScaffold 4.5 is released with plugin JavaScript test support.
gem 'active_scaffold', github: 'activescaffold/active_scaffold', branch: 'master'
gem 'simplecov', '~> 1.3', require: false

group :test do
  gem 'capybara'
  gem 'jquery-rails'
  gem 'jquery-ui-rails'
  gem 'propshaft'
  gem 'puma'
  gem 'selenium-webdriver'
  gem 'sqlite3', '>= 2.1'
end

group :lint do
  gem 'rubocop', '~> 1.86.0', require: false
  gem 'rubocop-erb', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rails', require: false
end
