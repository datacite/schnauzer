require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
# require "active_record/railtie"
# require "active_storage/engine"
require "action_controller/railtie"
# require "action_mailer/railtie"
require "action_view/railtie"
require "action_cable/engine"
# require "sprockets/railtie"
require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

# load ENV variables from .env file if it exists
env_file = File.expand_path("../../.env", __FILE__)
if File.exist?(env_file)
  require 'dotenv'
  Dotenv.load! env_file
end

# load ENV variables from container environment if json file exists
# see https://github.com/phusion/baseimage-docker#envvar_dumps
env_json_file = "/etc/container_environment.json"
if File.exist?(env_json_file)
  env_vars = JSON.parse(File.read(env_json_file))
  env_vars.each { |k, v| ENV[k] = v }
end

# default values for some ENV variables
ENV['APPLICATION'] ||= "re3data-api"
ENV['MEMCACHE_SERVERS'] ||= "memcached:11211"
ENV['SITE_TITLE'] ||= "DataCite re3data internal API"
ENV['LOG_LEVEL'] ||= "info"
ENV['ES_HOST'] ||= "elasticsearch:9200"
ENV['CONCURRENCY'] ||= "25"
ENV['GITHUB_URL'] ||= "https://github.com/datacite/schnauzer"
ENV['API_URL'] ||= "https://api.test.datacite.org"
ENV['RE3DATA_URL'] ||= "https://www.re3data.org/api/beta"
ENV['TRUSTED_IP'] ||= "10.0.50.1"

module Schnauzer
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.1

    # include graphql
    config.paths.add Rails.root.join('app', 'graphql', 'types').to_s, eager_load: true
    # config.paths.add Rails.root.join('app', 'graphql', 'mutations').to_s, eager_load: true

    # config.autoload_paths << Rails.root.join('lib')

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.api_only = true

    # secret_key_base is not used by Rails API, as there are no sessions
    config.secret_key_base = 'blipblapblup'

    # configure logging
    logger = ActiveSupport::Logger.new(STDOUT)
    logger.formatter = config.log_formatter
    config.logger = ActiveSupport::TaggedLogging.new(logger)
    config.lograge.enabled = true
    config.log_level = ENV['LOG_LEVEL'].to_sym

    # add elasticsearch instrumentation to logs
    require 'elasticsearch/rails/instrumentation'
    require 'elasticsearch/rails/lograge'

    # configure caching
    config.cache_store = :dalli_store, nil, { :namespace => ENV['APPLICATION'] }
  end
end
