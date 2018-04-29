source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

gem 'rails', '~> 5.2.0'
gem 'dotenv'
gem 'librato-rails', '~> 1.4.2'
gem 'kaminari', '~> 1.0', '>= 1.0.1'
gem 'elasticsearch-model', '~> 0.1.9', require: 'elasticsearch/model'
gem 'elasticsearch-persistence', '~> 0.1.9', require: 'elasticsearch/persistence/model'
gem 'elasticsearch-rails', '~> 0.1.9'
gem 'bootsnap', '>= 1.1.0', require: false
gem 'rack-cors', '~> 1.0', '>= 1.0.2', :require => 'rack/cors'

group :development, :test do
  gem 'rspec-rails', '~> 3.5', '>= 3.5.2'
  gem "better_errors"
  gem "binding_of_caller"
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'capybara'
  gem 'webmock', '~> 3.1'
  gem 'vcr', '~> 3.0.3'
  gem 'codeclimate-test-reporter', '~> 1.0.0'
  gem 'simplecov'
  gem 'shoulda-matchers', '~> 3.1'
  gem 'faker'
  gem 'factory_bot_rails', '~> 4.8', '>= 4.8.2'
  gem 'elasticsearch-extensions'
end