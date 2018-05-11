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
          function_score: {
            query: {
              multi_match: {
                query: query,
                fields: query_fields,
                zero_terms_query: "all"
              }
            },
            functions: query_functions(options)
          }
        },
        explain: true
      })
    end

    def query_fields
      ['repositoryName^5', 'description^5', 'keywords.text^5', 'subjects.text^5', '_all']
    end

    def query_functions(options = {})
      [
        {
          weight: 10,
          filter: {
            regexp: {
              "subjects.text" => "#{options[:subject]}.*"
            }
          }
        },
        {
          weight: 3,
          filter: {
            regexp: {
              "types.text" => "disciplinary"
            }
          }
        },
        {
          weight: 3,
          filter: {
            regexp: {
              "dataAccesses.type" => "open"
            }
          }
        },
        {
          weight: 3,
          filter: {
            regexp: {
              "dataUploads.text" => "open"
            }
          }
        },
        {
          weight: 0.0001,
          filter: {
            regexp: {
              "dataUploads.text" => "closed"
            }
          }
        },
        {
          weight: 3,
          filter: {
            regexp: {
              "certificates.text" => ".+"
            }
          }
        },
        {
          weight: 0.0001,
          filter: {
            regexp: {
              "pidSystems.text" => "none"
            }
          }
        },
        {
          weight: 0.0001,
          filter: {
            regexp: {
              "endDate" => ".+"
            }
          }
        }
      ]
    end
  end
end
