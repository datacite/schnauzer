class RepositorySerializer < ActiveModel::Serializer
  attributes :repositoryName, :repositoryUrl, :repositoryContacts, :description, :types, 
    :additionalNames, :subjects, :contentTypes, :providerTypes, 
    :keywords, :institutions, :dataUploads, :dataUploadLicenses,
    :apis, :pidSystems, :startDate, :endDate, :created, :updated

  def id
    object.identifier["re3data"]
  end

  def created
    object.created.strftime("%FT%TZ")
  end

  def updated
    object.updated.strftime("%FT%TZ")
  end
end