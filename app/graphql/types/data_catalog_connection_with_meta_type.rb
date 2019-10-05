# frozen_string_literal: true

class DataCatalogConnectionWithMetaType < BaseConnection
  edge_type(DataCatalogEdgeType)
  field_class GraphQL::Cache::Field
  
  field :total_count, Integer, null: true, cache: true

  def total_count
    args = object.arguments
    Repository.query(args[:query], page: { number: 1, size: 0 }).total
  end
end
