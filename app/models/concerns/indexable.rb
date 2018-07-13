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
      must = [
        { terms: { "dataUploads.type" => ["open", "restricted"] }}
      ]
      must << { term: { "subjects.text" => options[:subject] }} if options[:subject].present?
      must << { term: { "dataAccesses.type" => "open" }} if options[:open] == "true"
      must << { term: { "types.text" => "disciplinary" }} if options[:disciplinary] == "true"
      must << { regexp: { "certificates.text" => ".+" }} if options[:certified] == "true"
      must << { regexp: { "pidSystems.text" => "doi|hdl|urn|ark" }} if options[:pid] == "true"
      must << { multi_match: { query: query, fields: query_fields }} if query.present?
      
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
    end

    def query_fields
      ['repositoryName^5', 'description^5', 'keywords.text^5', 'subjects.text^5', '_all']
    end
  end
end
