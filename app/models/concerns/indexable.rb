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

    def suggest(query, options={})
      Elasticsearch::Persistence.client.search(
        index: Repository.index_name,
        search_type: "count",
        body: {
          suggest: {
            text: query,
            phrase_prefix: {
              phrase: {
                field: "description",
                size: 4,
                direct_generator: [
                  {
                    field: "description",
                    suggest_mode: "always"
                  },
                  {
                    field: "subjects.text",
                    suggest_mode: "always"
                  },
                  {
                    field: "keywords.text",
                    suggest_mode: "always"
                  },
                ],
                highlight: {
                  pre_tag: "<em>",
                  post_tag: "</em>"
                }
              }
            }
          }
        }
      )
    end

    def query(query, options={})
      must = [
        { terms: { "dataUploads.type" => ["open", "restricted"] }}
      ]
      must << { multi_match: { query: query, fields: query_fields, type: "phrase_prefix", max_expansions: 50 }} if query.present?
      must << { term: { "subjects.text" => options[:subject] }} if options[:subject].present?
      must << { term: { "dataAccesses.type" => "open" }} if options[:open] == "true"
      must << { term: { "types.text" => "disciplinary" }} if options[:disciplinary] == "true"
      must << { regexp: { "certificates.text" => ".+" }} if options[:certified] == "true"
      must << { regexp: { "pidSystems.text" => "doi|hdl|urn|ark" }} if options[:pid] == "true"
      
      __elasticsearch__.search({
        from: options[:from],
        size: options[:size],
        sort: [options[:sort]],
        query: {
          bool: {
            must: must
          }
        },
        explain: true
      })
    rescue Faraday::ConnectionFailed
      OpenStruct.new(total: 0, results: nil)
    end

    def query_fields
      ['repositoryName^10', 'keywords.text^10', 'subjects.text^10', 'description^3', '_all']
    end
  end
end
