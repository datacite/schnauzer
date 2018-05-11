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

    def query(query, options={})
      __elasticsearch__.search({
        from: options[:from],
        size: options[:size],
        sort: [options[:sort]],
        query: {
          filtered: {
            query: {
              multi_match: {
                query: query,
                fields: query_fields,
                zero_terms_query: "all"
              }
            },
            filter: query_filter(options)
          }
        }
      })
    end

    def query_fields
      ['repositoryName^5', 'description^5', 'keywords.text^5', 'subjects.text^5', '_all']
    end

    def query_filter(options = {})
      return nil unless options[:subject].present?

      {
        nested: {
          path: "subjects",
          filter: {
            bool: {
              must: {
                regexp: {
                  "subjects.text" => "#{options[:subject]}.*"
                }
              }
            }
          }
        }
      }
    end
  end
end
