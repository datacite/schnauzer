module Indexable
  extend ActiveSupport::Concern

  module ClassMethods
    # don't raise an exception when not found
    def find_by_id(id, options={})
      return nil unless id.present?

      __elasticsearch__.search(query: { match: { "identifier.re3data" => id } })
    rescue Elasticsearch::Transport::Transport::Errors::NotFound, Elasticsearch::Transport::Transport::Errors::BadRequest, Elasticsearch::Persistence::Repository::DocumentNotFound
      fail Elasticsearch::Transport::Transport::Errors::NotFound
    end

    # def query(query, options={})
    #   __elasticsearch__.search({
    #     from: options[:from],
    #     size: options[:size],
    #     sort: [options[:sort]],
    #     query: {
    #       bool: {
    #         must: {
    #           query_string: {
    #             query: query + "*",
    #             fields: query_fields
    #           }
    #         },
    #         filter: query_filter(options)
    #       }
    #     },
    #     aggregations: query_aggregations
    #   })
    # end

    def query(query, options={})
      __elasticsearch__.search({
        from: options[:from],
        size: options[:size],
        sort: [options[:sort]],
        query: {
          bool: {
            must: {
              query_string: {
                query: query + "*",
                fields: query_fields
              }
            },
            filter: query_filter(options)
          }
        }
      })
    end

    def query_fields
      ['repositoryName^10', 'description^10', '_all']
    end

    def query_filter(options = {})
      return nil unless options[:year].present?

      {
        terms: {
          year: options[:year].split(",")
        }
      }
    end
  end
end
