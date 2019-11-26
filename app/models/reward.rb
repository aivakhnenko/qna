class Reward < ApplicationRecord
  belongs_to :question
  has_one_attached :image

  validates :name, presence: true
  validate :validate_image

  private

  def validate_image
    errors.add(:image, 'Must be an image file') unless image_valid?
  end

  def image_valid?
    image.attached? && image.attachment.blob.content_type.starts_with?('image/')
  end
end
