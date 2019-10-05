# frozen_string_literal: true

class QueryType < BaseObject
  field :data_catalog, DataCatalogType, null: false do
    argument :id, ID, required: true
  end

  def data_catalog(id:)
    Repository.find_by_id(id).first
  end

  field :data_catalogs, DataCatalogConnectionWithMetaType, null: false, connection: true, max_page_size: 1000 do
    argument :query, String, required: false
    argument :first, Int, required: false, default_value: 25
  end

  def data_catalogs(query: nil, first: nil)
    Repository.query(query, page: { number: 1, size: 25 }).to_a
  end
end
