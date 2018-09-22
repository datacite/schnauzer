class RepositorySerializer < ActiveModel::Serializer
  attributes :repositoryName, :repositoryUrl, :repositoryContacts, :description, :certificates, :types, 
    :additionalNames, :subjects, :contentTypes, :providerTypes, 
    :keywords, :institutions, :dataAccesses, :dataUploads, :dataUploadLicenses, :pidSystems,
    :apis, :pidSystems, :software, :startDate, :endDate, :created, :updated

  def id
    "r3d#{object.identifier["re3data"]}"
  end

  def subjects
    object.subjects.sort_by { |subject| subject["text"] }
  end

  def created
    object.created.strftime("%FT%TZ")
  end

  def updated
    object.updated.strftime("%FT%TZ")
  end
end