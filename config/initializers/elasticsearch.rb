Elasticsearch::Persistence.client = Elasticsearch::Client.new hosts: [
  { host: ENV['ES_HOST'],
    port: '80',
    user: ENV['ELASTIC_USER'],
    password: ENV['ELASTIC_PASSWORD'],
    scheme: 'http'
  }]

Hashie.logger = Logger.new('/dev/null')