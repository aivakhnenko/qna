class AttachmentSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :filename, :url, :created_at

  def url
    url_for(object)
  end
end
