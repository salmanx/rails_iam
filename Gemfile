# frozen_string_literal: true

source "https://rubygems.org"

# Specify your gem's dependencies in rails_iam.gemspec.
gemspec

gem "sqlite3"

group :development, :test do
  gem "debug", platforms: %i[mri windows], require: "debug/prelude"
  gem "factory_bot_rails"
  gem "faker"
  gem "rspec-rails"
  gem "rubocop-rails", require: false
  gem "shoulda-matchers"
  gem "simplecov", require: false, group: :test
end
