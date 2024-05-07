source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

gem 'rails', '~> 6.1.6'
gem 'dotenv'
gem "dalli", "~> 2.7.6"
gem 'lograge', '~> 0.5'
gem 'sentry-raven', '~> 2.9'
gem 'active_model_serializers', '~> 0.10.0'
gem 'jsonapi-serializer', '~> 2.2'
gem 'kaminari', '~> 1.2'
gem 'elasticsearch', '~> 1.1', '>= 1.1.3'
gem 'elasticsearch-model', '~> 0.1.9', require: 'elasticsearch/model'
gem 'elasticsearch-persistence', '~> 0.1.9', require: 'elasticsearch/persistence/model'
gem 'elasticsearch-rails', '~> 0.1.9'
gem 'maremma', '>= 4.1'
gem 'bootsnap', '>= 1.1.0', require: false
gem 'rack-cors', '~> 1.0', :require => 'rack/cors'
gem 'git', '~> 1.5'
gem 'graphql', '~> 1.9', '>= 1.9.4'
gem 'graphql-errors', '~> 0.3.0'
gem 'graphql-batch', '~> 0.4.0'
gem 'batch-loader', '~> 1.4', '>= 1.4.1'
gem 'graphql-cache', '~> 0.6.0', git: "https://github.com/stackshareio/graphql-cache"
gem 'apollo-federation', '~> 1.0'
gem 'google-protobuf', '~> 3.0'

group :development, :test do
  gem 'rspec-rails', '~> 3.8', '>= 3.8.2'
  gem 'rubocop', '~> 1.3', require: false
  gem 'rubocop-performance', '~> 1.2', require: false
  gem "better_errors"
  gem "binding_of_caller"
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  gem 'listen', '~> 3.9'
  gem 'spring', '~> 4.1', '>= 4.1.3'
  gem 'spring-commands-rspec'
  gem 'spring-watcher-listen', '~> 2.1'
  # gem 'httplog', '~> 1.0'
end

group :test do
  gem 'capybara'
  gem 'webmock', '~> 3.1'
  gem 'vcr', '~> 6.1'
  gem 'codeclimate-test-reporter', '~> 1.0.0'
  gem 'simplecov'
  gem 'shoulda-matchers', '~> 3.1'
  gem 'elasticsearch-extensions'
end
