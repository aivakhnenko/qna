class Link < ApplicationRecord
  belongs_to :linkable, polymorphic: true, optional: true

  validates :name, :url, presence: true
  validate :validate_url

  def gist?
    url =~ /^https:\/\/gist\.github\.com/
  end

  private
  
  def validate_url
    errors.add(:url) unless url_valid?(url)
  end

  def url_valid?(url)
    url = URI.parse(url) rescue false
    url.kind_of?(URI::HTTP) || url.kind_of?(URI::HTTPS)
  end
end
