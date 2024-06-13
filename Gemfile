# frozen_string_literal: true

source 'https://rubygems.org'

# Web
gem 'erb'
gem 'puma'
gem 'rack-session'
gem 'redis-rack'
gem 'redis-store'
gem 'roda'
gem 'slim'

# Configuration
gem 'figaro'
gem 'rake'

# Communication
gem 'http'
gem 'redis'

# Security
gem 'dry-validation'
gem 'rack-ssl-enforcer'
gem 'rbnacl' # assumes libsodium package already installed

# Encoding
gem 'base64'
gem 'activesupport'

# Debugging
gem 'pry'

# Development
group :development do
  gem 'rubocop'
  gem 'rubocop-performance'
end

# Testing
group :test do
  gem 'minitest'
  gem 'minitest-rg'
  gem 'webmock'
end

group :development, :test do
  gem 'rack-test'
  gem 'rerun'
end
