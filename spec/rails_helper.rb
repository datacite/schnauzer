ENV['RAILS_ENV'] = 'test'

# set up Code Climate
require 'simplecov'
SimpleCov.start

require File.expand_path('../../config/environment', __FILE__)

Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

require 'rspec/rails/view_rendering'
require 'rspec/rails/matchers'
require 'rspec/rails/file_fixture_support'
require 'rspec/rails/fixture_file_upload_support'
require "shoulda-matchers"
require "webmock/rspec"
require "rack/test"

WebMock.allow_net_connect!

WebMock.disable_net_connect!(
  allow: ['codeclimate.com:443'],
  allow_localhost: true
)

# configure shoulda matchers to use rspec as the test framework and full matcher libraries for rails
Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end

RSpec.configure do |config|
  config.include Rack::Test::Methods, :type => :request

  # add custom json method
  config.include RequestSpecHelper, type: :request

  def app
    Rails.application
  end
end

VCR.configure do |config|
  config.cassette_library_dir = "spec/fixtures/vcr_cassettes"
  config.hook_into :webmock
  config.ignore_localhost = true
  config.ignore_hosts "codeclimate.com"
  config.configure_rspec_metadata!
  config.filter_sensitive_data("<ES_HOST>") { ENV['ES_HOST'] }
  config.filter_sensitive_data("<ELASTIC_USER>") { ENV['ELASTIC_USER'] }
  config.filter_sensitive_data("<ELASTIC_PASSWORD>") { ENV['ELASTIC_PASSWORD'] }
end
