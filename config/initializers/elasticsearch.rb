Elasticsearch::Persistence.client = Elasticsearch::Client.new hosts: [
  { host: ENV['ES_HOST'],
    port: '80',
    user: ENV['ELASTIC_USER'],
    password: ENV['ELASTIC_PASSWORD'],
    scheme: 'http'
  }]

  module CoreExtensions
    module Elasticsearch
      module Model
  
        # Subclass of `Hashie::Mash` to wrap Hash-like structures
        # (responses from Elasticsearch, search definitions, etc)
        #
        # The primary goal of the subclass is to disable the
        # warning being printed by Hashie for re-defined
        # methods, such as `sort`.
        #
        class HashWrapper < ::Hashie::Mash
          disable_warnings if respond_to?(:disable_warnings)
        end
      end
    end
  end
  
  # backport from later version:
  # https://github.com/elastic/elasticsearch-rails/blob/master/elasticsearch-model/lib/elasticsearch/model/hash_wrapper.rb
  Elasticsearch::Model.include CoreExtensions::Elasticsearch::Model