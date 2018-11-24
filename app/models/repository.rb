class Repository
  include Elasticsearch::Model::Proxy
  include Elasticsearch::Persistence::Model

  include Indexable

  index_name "frontend"

  attribute :identifier, Hash, mapping: { type: 'keyword' }
  attribute :repositoryName, String, mapping: { type: 'text', fields: { sortable: { type: "keyword" }}}
  attribute :repositoryUrl, String, mapping: { type: 'text' }
  attribute :repositoryContacts, String, mapping: { type: 'text' }
  attribute :description, String, mapping: { type: 'text' }
  attribute :startDate, DateTime, mapping: { type: :date }
  attribute :endDate, DateTime, mapping: { type: :date }
  attribute :created, DateTime, mapping: { type: :date }
  attribute :updated, DateTime, mapping: { type: :date }

  attribute :types, String, mapping: { type: 'text' }
  attribute :additionalNames, String, mapping: { type: 'text' }
  attribute :subjects, String, mapping: { type: 'text' }
  attribute :contentTypes, String, mapping: { type: 'text' }
  attribute :certificates, String, mapping: { type: 'text' }
  attribute :providerTypes, String, mapping: { type: 'text' }
  attribute :keywords, String, mapping: { type: 'text' }
  attribute :institutions, String, mapping: { type: 'text' }
  attribute :dataAccesses, String, mapping: { type: 'text' }
  attribute :dataUploads, String, mapping: { type: 'text' }
  attribute :dataUploadLicenses, String, mapping: { type: 'text' }
  attribute :pidSystems, String, mapping: { type: 'text' }
  attribute :apis, String, mapping: { type: 'text' }
  attribute :software, String, mapping: { type: 'text' }

  def self.query_aggregations
    {
      subjects: { terms: { field: 'subjects', size: 15, min_doc_count: 1 } }
    }
  end

  def id
    identifier["doi"]
  end
end
