class Repository
  include Elasticsearch::Model::Proxy
  include Elasticsearch::Persistence::Model

  # include Cacheable
  include Indexable
  # include Importable

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

  # def id
  #   symbol.downcase
  # end

  # def provider
  #   Provider.find_by_id(provider_id)
  # end

  # def to_jsonapi
  #   { "data" => { "type" => "clients", "attributes" => Client.to_kebab_case(attributes) } }
  # end

  # def repository
  #   return nil unless re3data.present?
  #   r = cached_repository_response(re3data)
  #   r[:data] if r.present?
  # end

  # # backwards compatibility
  # def member
  #   m = cached_member_response(provider_id)
  #   m[:data] if m.present?
  # end

  # def year
  #   created.to_datetime.year
  # end

  # def to_jsonapi
  #   attributes = {
  #     "symbol" => symbol,
  #     "name" => name,
  #     "contact-name" => contact_name,
  #     "contact-email" => contact_email,
  #     "url" => url,
  #     "re3data" => re3data,
  #     "domains" => domains,
  #     "provider-id" => provider_id,
  #     "prefixes" => prefixes,
  #     "is-active" => is_active,
  #     "version" => version,
  #     "created" => created.iso8601,
  #     "updated" => updated.iso8601 }

  #   { "id" => symbol.downcase, "type" => "clients", "attributes" => attributes }
  # end

  # protected

  # def freeze_symbol
  #   errors.add(:symbol, "cannot be changed") if self.symbol_changed?
  # end

  # def check_id
  #   errors.add(:symbol, ", Your Client ID must include the name of your provider. Separated by a dot '.' ") if self.symbol.split(".").first.downcase != self.provider.symbol.downcase
  # end

  # def user_url
  #   ENV["VOLPINO_URL"] + "/users?client-id=" + symbol.downcase
  # end
end
