class Re3dataSerializer
  include FastJsonapi::ObjectSerializer
  set_key_transform :camel_lower
  set_type :re3data

  attributes :re3data_id, :repositoryName, :repositoryUrl, :repositoryContacts, :description, :certificates, :types, 
    :additionalNames, :subjects, :contentTypes, :providerTypes, 
    :keywords, :institutions, :dataAccesses, :dataUploads, :dataUploadLicenses, :pidSystems,
    :apis, :pidSystems, :software, :startDate, :endDate, :created, :updated

  attribute :re3data_id do |object|
    "r3d#{object.identifier["re3data"]}"
  end

  attribute :subjects do |object|
    object.subjects.sort_by { |subject| subject["text"] }
  end

  attribute :created do |object|
    object.created.strftime("%FT%TZ")
  end

  attribute :updated do |object|
    object.updated.strftime("%FT%TZ")
  end
end