source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.3.6'

gem 'figaro'
gem 'jsonapi-rails'
gem 'kaminari'
gem 'mysql2', '>= 0.4.4', '< 0.6.0'
gem 'rails', '~> 5.2.3'
gem 'whenever', require: false

group :development, :test do
  gem 'pry', require: true
end

group :development do
  gem 'rubocop-performance'
  gem 'spring'
end

group :test do
  gem 'airborne'
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'rspec-rails'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
