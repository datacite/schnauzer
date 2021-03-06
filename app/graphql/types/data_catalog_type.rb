# frozen_string_literal: true

class DataCatalogType < BaseObject
  key fields: 'id'

  description "A collection of datasets."

  field :id, ID, null: false, description: "The ID of the data catalog."
  field :type, String, null: false, description: "The type of the item."
  field :identifier, [IdentifierType], null: true, description: "re3data ID"
  field :name, String, null: true, hash_key: "repositoryName", description: "The name of the data catalog."
  field :alternate_name, [String], null: true, hash_key: "additionalNames", description: "An alias for the data catalog."
  field :url, String, null: true, hash_key: "repositoryUrl", description: "URL of the data catalog."
  # field :contacts, [String], null: true, description: "Repository contact information"
  field :description, String, null: true, description: "A description of the data catalog."
  field :certificates, [DefinedTermType], null: true, description: "Certificates of the data catalog."
  field :subjects, [DefinedTermType], null: true, description: "Subject areas covered by the data catalog."
  # field :types, [String], null: true, description: "Repository types"
  # field :content_types, [SchemeType], null: true, description: "Content types"
  # field :provider_types, [String], null: true, description: "Provider types"
  field :in_language, [String], null: true, description: "The language of the content of the data catalog."
  field :keywords, String, null: true, description: "Keywords or tags used to describe this data catalog. Multiple entries in a keywords list are typically delimited by commas."
  # field :data_accesses, [TextRestrictionType], null: true, description: "Data accesses"
  # field :data_uploads, [TextRestrictionType], null: true, description: "Data uploads"
  # field :pid_systems, [String], null: true, description: "PID Systems"
  # field :apis, [ApiType], null: true, description: "APIs"
  field :software_application, [SoftwareApplicationType], null: true, description: "Software"

  def id
    "https://doi.org/#{object.identifier["doi"].downcase}"
  end

  def type
    "DataCatalog"
  end

  def identifier
    Array.wrap(object.identifier["re3data"]).map { |o| { "name" => "re3data", "value" => "r3d#{o}" } }
  end

  def alternate_name
    Array.wrap(object["additionalNames"]).map { |n| n["text"] }
  end

  def keywords
    Array.wrap(object.keywords).map { |k| k["text"] }.join(", ")
  end

  def in_language
    Array.wrap(object["repositoryLanguages"]).map { |k| k["text"] }
  end

  def certificates
    Array.wrap(object.certificates).map { |s| { "name" => s["text"] } }
  end

  def subjects
    Array.wrap(object.subjects).map do |s|
      term_code, name = s["text"].split(" ", 2)

      {
        "term_code" => term_code,
        "name" => name,
        "in_defined_term_set" => "DFG" }
    end
  end

  def software_application
    Array.wrap(object.software).map { |s| { "name" => s["name"] } }
  end
end
