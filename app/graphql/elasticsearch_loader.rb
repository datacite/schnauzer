# frozen_string_literal: true

# class ElasticsearchLoader < GraphQL::Batch::Loader
#   def initialize(model)
#     @model = model
#   end

#   def perform(ids)
#     ids = Array.wrap(ids).map { |r| doi_from_url(r) }
#     @model.find_by_id(ids).results.each { |record| fulfill(record.id, record) }
#     ids.each { |id| fulfill(id, nil) unless fulfilled?(id) }
#   end

#   def doi_from_url(url)
#     if /\A(?:(http|https):\/\/(dx\.)?(doi.org|handle.test.datacite.org)\/)?(doi:)?(10\.\d{4,5}\/.+)\z/.match?(url)
#       uri = Addressable::URI.parse(url)
#       uri.path.gsub(/^\//, "").downcase
#     end
#   end
# end
